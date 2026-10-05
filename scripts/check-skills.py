#!/usr/bin/env python3
"""Report vendored skills that have drifted from their upstream source.

Reads skills-provenance.json, keeps a shallow checkout of each upstream repo
under ~/.cache/dotfiles/skill-sources, and diffs every tracked skill against it.
Exits non-zero when anything has drifted or gone missing upstream.
"""

from __future__ import annotations

import argparse
import filecmp
import json
import pathlib
import subprocess
import sys

REPO = pathlib.Path(__file__).resolve().parent.parent
MANIFEST = REPO / "skills-provenance.json"
CACHE = pathlib.Path.home() / ".cache" / "dotfiles" / "skill-sources"

GREEN, YELLOW, RED, DIM, NC = "\033[0;32m", "\033[0;33m", "\033[0;31m", "\033[2m", "\033[0m"


def run(*args: str, cwd: pathlib.Path | None = None) -> subprocess.CompletedProcess:
    return subprocess.run(args, cwd=cwd, capture_output=True, text=True)


def sync(name: str, source: dict, offline: bool) -> pathlib.Path | None:
    """Clone or fast-forward a source checkout; return its path, or None if unusable."""
    path = CACHE / name
    if not path.exists():
        if offline:
            print(f"{YELLOW}[skip]{NC} {name}: no cached checkout and --offline given")
            return None
        CACHE.mkdir(parents=True, exist_ok=True)
        print(f"{DIM}cloning {source['url']}{NC}")
        cloned = run("git", "clone", "--depth", "1", "--branch", source["ref"],
                     source["url"], str(path))
        if cloned.returncode != 0:
            print(f"{RED}[error]{NC} {name}: clone failed: {cloned.stderr.strip().splitlines()[-1:]}")
            return None
    elif not offline:
        run("git", "fetch", "--depth", "1", "origin", source["ref"], cwd=path)
        run("git", "reset", "--hard", f"origin/{source['ref']}", cwd=path)
    return path


def differing_files(local: pathlib.Path, upstream: pathlib.Path) -> list[str]:
    """Every path under either tree whose contents differ."""
    out: list[str] = []

    def walk(rel: pathlib.Path) -> None:
        a, b = local / rel, upstream / rel
        names = {p.name for p in a.iterdir()} | {p.name for p in b.iterdir()}
        for name in sorted(names):
            child = rel / name
            ca, cb = local / child, upstream / child
            if ca.is_dir() and cb.is_dir():
                walk(child)
            elif not ca.exists() or not cb.exists():
                out.append(str(child))
            elif not filecmp.cmp(ca, cb, shallow=False):
                out.append(str(child))

    walk(pathlib.Path("."))
    return [p.removeprefix("./") for p in out]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--offline", action="store_true",
                        help="use the cached checkouts as-is instead of fetching")
    args = parser.parse_args()

    manifest = json.loads(MANIFEST.read_text())
    checkouts = {name: sync(name, source, args.offline)
                 for name, source in manifest["sources"].items()}

    in_sync = local_only = 0
    problems: list[str] = []

    for rel, entry in manifest["skills"].items():
        local = REPO / rel
        if entry["source"] == "local":
            local_only += 1
            continue
        checkout = checkouts.get(entry["source"])
        if checkout is None:
            continue
        if not local.exists():
            problems.append(f"{RED}[gone]{NC}    {rel}: tracked here but not on disk")
            continue
        upstream = checkout / entry["path"]
        if not upstream.exists():
            problems.append(f"{YELLOW}[moved]{NC}   {rel}: {entry['source']}/{entry['path']} no longer exists")
            continue
        changed = differing_files(local, upstream)
        if changed:
            problems.append(f"{YELLOW}[drift]{NC}   {rel}: {', '.join(changed)}")
        else:
            in_sync += 1

    for line in problems:
        print(line)
    print(f"\n{GREEN}{in_sync} in sync{NC}, {len(problems)} needing attention, "
          f"{local_only} local-only")
    if problems:
        print(f"{DIM}Refresh one with: cp -R {CACHE}/<source>/<upstream path>/ <repo path>/{NC}")
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
