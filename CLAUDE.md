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
| `ghostty/config` | `~/.config/ghostty/config` |
| `fish/config.fish` | `~/.config/fish/config.fish` |
| `fish/fish_variables` | `~/.config/fish/fish_variables` |
| `fish/conf.d/*.fish` | `~/.config/fish/conf.d/*.fish` (individual files) |
| `tmux.conf` | `~/.tmux.conf` |
| `nvim/` | `~/.config/nvim` (whole directory) |
| `gitconfig` | `~/.gitconfig` |
| `claude/settings.json` | `~/.claude/settings.json` |

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
