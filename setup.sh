#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

link() {
    local src="$1"
    local dest="$2"

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    if [ -L "$dest" ]; then
        local current_target
        current_target="$(readlink "$dest")"
        if [ "$current_target" = "$src" ]; then
            echo -e "${GREEN}[ok]${NC} $dest -> $src"
            return
        fi
        echo -e "${YELLOW}[update]${NC} $dest (was -> $current_target)"
        rm "$dest"
    elif [ -e "$dest" ]; then
        echo -e "${YELLOW}[backup]${NC} $dest -> ${dest}.bak"
        mv "$dest" "${dest}.bak"
    else
        echo -e "${GREEN}[link]${NC} $dest -> $src"
    fi

    ln -s "$src" "$dest"
}

echo "Setting up dotfiles from $DOTFILES_DIR"
echo ""

# Ghostty
link "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"

# Fish
link "$DOTFILES_DIR/fish/config.fish"                    "$HOME/.config/fish/config.fish"
link "$DOTFILES_DIR/fish/fish_variables"                  "$HOME/.config/fish/fish_variables"
link "$DOTFILES_DIR/fish/conf.d/fish_frozen_theme.fish"   "$HOME/.config/fish/conf.d/fish_frozen_theme.fish"
link "$DOTFILES_DIR/fish/conf.d/fish_frozen_key_bindings.fish" "$HOME/.config/fish/conf.d/fish_frozen_key_bindings.fish"
link "$DOTFILES_DIR/fish/conf.d/rustup.fish"              "$HOME/.config/fish/conf.d/rustup.fish"
link "$DOTFILES_DIR/fish/conf.d/uv.env.fish"              "$HOME/.config/fish/conf.d/uv.env.fish"

# tmux
link "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"

# Neovim
link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Git
link "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"

# Claude Code
link "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"

echo ""
echo -e "${GREEN}Done!${NC}"
