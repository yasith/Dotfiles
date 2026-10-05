# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for macOS. Configs are stored in this repo and symlinked to their target locations via `setup.sh`.

## Setup

```bash
./setup.sh
```

This creates symlinks from the repo to the filesystem. It backs up existing files to `.bak`, skips already-correct links, and creates parent directories as needed.

## Config mapping

| Repo path | Symlink target |
|-----------|---------------|
| `home/AGENTS.md` | `~/AGENTS.md` and `~/.claude/CLAUDE.md` |
| `ghostty/config` | `~/.config/ghostty/config` |
| `herdr/config.toml` | `~/.config/herdr/config.toml` |
| `fish/config.fish` | `~/.config/fish/config.fish` |
| `fish/fish_variables` | `~/.config/fish/fish_variables` |
| `fish/conf.d/*.fish` | `~/.config/fish/conf.d/*.fish` (individual files) |
| `tmux.conf` | `~/.tmux.conf` |
| `nvim/` | `~/.config/nvim` (whole directory) |
| `gitconfig` | `~/.gitconfig` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `claude/keybindings.json` | `~/.claude/keybindings.json` |
| `claude/hooks/herdr-agent-state.sh` | `~/.claude/hooks/herdr-agent-state.sh` |
| `codex/skills/*` | `~/.codex/skills/*` (individual skill directories) |
| `agents/skills/*` | `~/.agents/skills/*` (individual skill directories) |
| `claude/skills/*` | `~/.claude/skills/*` (individual skill directories) |
| `pi/skills/*` | `~/.pi/agent/skills/*` (individual skill directories) |

Skills use individual directory links so app-managed `synced/`, `.system/`, and
plugin caches stay outside the repo. Run `./setup.sh --skills-only` to link just
skills. Original skill directories are backed up outside discovery paths under
`~/.local/state/dotfiles/skills/<agent>/`.

## Adding or changing configs

When adding or modifying configs in this repo:

1. Copy the config file/directory into the repo under a descriptive folder name.
2. Add a `link` call in `setup.sh` mapping the repo path to the target path on the filesystem.
3. If symlinking an entire directory (like nvim), link the directory itself rather than individual files.
4. Update `README.md` to reflect the change — keep the "What's included" summaries and the config mapping table current.

## Key conventions

- nvim is linked as a whole directory; fish and ghostty are linked as individual files.
- `setup.sh` uses a `link` helper function — add new entries using the same `link "$DOTFILES_DIR/..." "$HOME/..."` pattern.
- `README.md` must be kept in sync with any config changes (see step 4 above).
- `home/AGENTS.md` is the single source of global agent instructions. It is linked to
  both `~/AGENTS.md` and `~/.claude/CLAUDE.md`, because Claude Code reads `AGENTS.md`
  only as project instructions, not at user scope. Do not duplicate its contents.
- `gitconfig` includes `~/.gitconfig.local` (untracked) for per-machine overrides such as
  a work commit email. Git silently skips the include when the file does not exist.
- `claude/hooks/herdr-agent-state.sh` is installed by Herdr upstream. Reinstalling the
  Herdr integration writes through the symlink into this repo; commit the result rather
  than editing the script by hand.
- Claude Code treats `alt` and `meta` as the same modifier, so its own `meta+*` defaults
  can shadow Herdr's prefix-free `alt+*` bindings. Resolve those in
  `claude/keybindings.json` by unbinding the Claude Code side.
