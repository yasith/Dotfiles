# Dotfiles

Personal configuration files for macOS, managed with symlinks.

## What's included

- **Ghostty** — terminal keybindings and macOS settings
- **fish** — shell config with Starship prompt, conda, tmux helpers, and git worktree workflow
- **tmux** — `Ctrl+A` prefix, alt-key navigation, minimalist status bar, resurrect/continuum plugins
- **Neovim** — AstroNvim-based config with Lazy.nvim, Treesitter, Mason, and none-ls
- **Git** — LFS, aliases (`st`, `d`, `l`, `co`, `ci`, `cia`, `br`)
- **Claude Code** — permissions for common CLI tools, plugins, co-author attribution disabled

## Setup

```bash
git clone https://github.com/yasith/Dotfiles.git
cd Dotfiles
./setup.sh
```

This symlinks each config to its correct location on the filesystem. Existing files are backed up to `.bak`.

## Config mapping

| Repo path | Target |
|-----------|--------|
| `ghostty/config` | `~/.config/ghostty/config` |
| `fish/` | `~/.config/fish/` (individual files) |
| `tmux.conf` | `~/.tmux.conf` |
| `nvim/` | `~/.config/nvim` (whole directory) |
| `gitconfig` | `~/.gitconfig` |
| `claude/settings.json` | `~/.claude/settings.json` |
