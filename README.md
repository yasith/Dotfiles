# Dotfiles

Personal configuration files for macOS, managed with symlinks.

## What's included

- **Herdr** - prefix-free `Alt+t` for a new tab, `Alt+Shift+T` for a new Git worktree, `Alt+j`/`Alt+k` for previous/next spaces, `Alt+p`/`Alt+n` for previous/next tabs, and `Alt+Shift+J`/`Alt+Shift+K` for previous/next agents
- **Ghostty** — terminal keybindings and macOS settings
- **fish** — shell config with Starship prompt, conda, tmux helpers, and git worktree workflow
- **tmux** — `Ctrl+A` prefix, alt-key navigation, minimalist status bar, resurrect/continuum plugins
- **Neovim** — AstroNvim-based config with Lazy.nvim, Treesitter, Mason, and none-ls
- **Git** — LFS, aliases (`st`, `d`, `l`, `co`, `ci`, `cia`, `br`), delta pager, and a machine-local override file
- **Claude Code** — permissions for common CLI tools, plugins, co-author attribution disabled, the Herdr `SessionStart` hook, and keybindings that free Alt+T for Herdr
- **Agent skills** - one shared set of agent skills, reaching Codex through `~/.agents/skills` and Claude Code through a repo-local `engineering` plugin, plus the Claude-specific skill variants
- **Agent instructions** — one shared `AGENTS.md` of cross-agent rules, linked to both the generic and Claude Code locations

## Setup

```bash
git clone https://github.com/yasith/Dotfiles.git
cd Dotfiles
./setup.sh
```

This symlinks each config to its correct location on the filesystem. Existing files are backed up to `.bak`.

### Machine-local git settings

`gitconfig` ends with an include of `~/.gitconfig.local`, which is not tracked here.
Use it for anything that differs per computer — most often the commit email on a
work machine:

```ini
[user]
	email = you@work.example
```

Git ignores the include when the file is absent, so machines without one fall back
to the tracked defaults.

### Global agent instructions

`home/AGENTS.md` holds the cross-agent rules and is linked to two places:

- `~/AGENTS.md` — the generic location other agents read.
- `~/.claude/CLAUDE.md` — Claude Code reads `AGENTS.md` only as *project* instructions
  (controlled by its `instructionFiles` setting), never at user scope, so the global
  copy has to carry the `CLAUDE.md` name. Verified on Claude Code 2.1.289: a
  `~/.claude/AGENTS.md` is ignored while `~/.claude/CLAUDE.md` loads.

Both links point at the same tracked file, so there is one copy to edit.

### Claude Code keybindings

`claude/keybindings.json` unbinds `meta+t` in the `Chat` context, which Claude Code
uses for its thinking toggle. In a terminal `alt` and `meta` are the same key, so that
default swallowed Herdr's `alt+t` new-tab binding before Herdr ever saw it. Unbinding
it hands `alt+t` back to Herdr.

## Config mapping

| Repo path | Target |
|-----------|--------|
| `home/AGENTS.md` | `~/AGENTS.md` and `~/.claude/CLAUDE.md` |
| `ghostty/config` | `~/.config/ghostty/config` |
| `herdr/config.toml` | `~/.config/herdr/config.toml` |
| `fish/` | `~/.config/fish/` (individual files) |
| `tmux.conf` | `~/.tmux.conf` |
| `nvim/` | `~/.config/nvim` (whole directory) |
| `gitconfig` | `~/.gitconfig` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `claude/keybindings.json` | `~/.claude/keybindings.json` |
| `claude/hooks/herdr-agent-state.sh` | `~/.claude/hooks/herdr-agent-state.sh` |
| `agents/skills/*` | `~/.agents/skills/*` (individual skill directories) |
| `claude/skills/*` | `~/.claude/skills/*` (individual skill directories) |
| `pi/skills/*` | `~/.pi/agent/skills/*` (individual skill directories) |
| `claude/plugins/` | registered as the `dotfiles` marketplace (not symlinked) |

Run `./setup.sh --skills-only` to install only the skills. Existing skill directories
are backed up under `~/.local/state/dotfiles/skills/<agent>/`; setup refuses to
overwrite an existing backup. Edit the skills here after linking them.

`agents/skills/` holds every shared skill body. Claude-specific variants live in
`claude/skills/`, and the entries there that need no variant are symlinks back to
`agents/skills/`. Add new shared skills to `agents/skills/` and rerun setup.

App-managed `synced/`, Codex `.system/`, `.trash/`, and plugin caches (such as
`~/.codex/plugins/cache/`) remain outside this repo and are managed by their apps.

### The `engineering` plugin

Claude Code discovers skills in `~/.claude/skills` and in plugins. It does not read
`~/.agents/skills`, so the shared skills reach it as a plugin instead:
`claude/plugins/` is a marketplace named `dotfiles` holding one plugin, `engineering`,
whose `skills/` entries are symlinks back to `agents/skills/`. One body per skill still
serves both agents, and editing it in `agents/skills/` takes effect in both.

A plugin rather than more `~/.claude/skills` links, because it namespaces. Eight of
these skills share a name with a Claude Code built-in (`code-review`, `pr`, `research`,
`teach`, `implement`, `triage`, `handoff`, `retro`), and twenty-six are cross-referenced
by name from other skills, so renaming them to avoid the clash was not an option. As
plugin skills they are addressed as `engineering:code-review` and leave the built-ins
alone.

`setup.sh` registers the marketplace from the clone's own path, so the plugin tracks the
working tree and needs no push to pick up an edit. `claude/settings.json` enables it as
`engineering@dotfiles`, which carries no path and so works on every machine. Check what
is loaded with:

```bash
claude plugin details engineering@dotfiles
```

## Skills on another computer

Commit and push the skill files and setup changes before cloning on another computer:

```bash
git clone https://github.com/yasith/Dotfiles.git
cd Dotfiles
./setup.sh --skills-only
```

Use `./setup.sh` instead to install all dotfiles as well. Setup calculates the clone's
location, so it does not need to be in the same directory on each computer. The
agent applications and Herdr itself must be installed separately.

Skill contents live in this repo; the agent directories contain symlinks to them.
Edits through either path change the same files. On an existing computer, run
`git pull` and `./setup.sh --skills-only` to pick up changes and link new skills.

### Herdr

Source: [herdrdev/herdr](https://github.com/herdrdev/herdr/tree/master/skills/herdr).
Installed with:

```bash
npx skills@latest add herdrdev/herdr --skill herdr --global --agent codex claude-code opencode pi --yes
```

The installed shared copy is tracked at `agents/skills/herdr`. Codex and OpenCode
discover it through `~/.agents/skills/herdr`; Claude Code and Pi have links to the
same copy. Cloning this repo and running setup restores these links without
downloading the skill again. The installer records upstream provenance in the
machine-local `~/.agents/.skill-lock.json`; that file is not part of Dotfiles.

#### Installers that refuse symlinked configs

`tsk setup herdr` (and anything else that opens a config with `O_NOFOLLOW`) fails on
the symlinked `~/.config/herdr/config.toml` with *"symlinks/non-directories refused:
Too many levels of symbolic links"*. Swap in a real file, run the installer, then fold
the result back:

```bash
rm ~/.config/herdr/config.toml
cp herdr/config.toml ~/.config/herdr/config.toml
tsk setup herdr
cat ~/.config/herdr/config.toml > herdr/config.toml   # keep the installer's additions
rm ~/.config/herdr/config.toml
./setup.sh                                            # restore the symlink
herdr server reload-config
```

Herdr's own `config.toml.tsk-backup-*` files stay in `~/.config/herdr/` and are not
tracked here.
