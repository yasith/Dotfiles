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
    local backup="${3:-${dest}.bak}"

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
        if [ -e "$backup" ] || [ -L "$backup" ]; then
            echo -e "${RED}[error]${NC} Backup already exists: $backup" >&2
            return 1
        fi
        mkdir -p "$(dirname "$backup")"
        echo -e "${YELLOW}[backup]${NC} $dest -> $backup"
        mv "$dest" "$backup"
    else
        echo -e "${GREEN}[link]${NC} $dest -> $src"
    fi

    ln -s "$src" "$dest"
}

link_skills() {
    local agent skill name target
    for agent in agents claude pi; do
        target="$HOME/.$agent/skills"
        if [ "$agent" = pi ]; then
            target="$HOME/.pi/agent/skills"
        fi
        for skill in "$DOTFILES_DIR/$agent/skills/"*; do
            [ -d "$skill" ] || continue
            name="$(basename "$skill")"
            # Keep backups outside skill discovery paths to avoid duplicates.
            link "$skill" "$target/$name" \
                "$HOME/.local/state/dotfiles/skills/$agent/$name"
        done
    done
}

# Claude Code reads skills from ~/.claude/skills and from plugins, never from
# ~/.agents/skills. The shared skills reach it as the "engineering" plugin of a
# marketplace rooted in this repo, which also namespaces skills whose names
# collide with Claude Code built-ins (code-review, pr, research, ...).
register_claude_marketplace() {
    local source="$DOTFILES_DIR/claude/plugins"

    if ! command -v claude >/dev/null 2>&1; then
        echo -e "${YELLOW}[skip]${NC} claude not installed; run 'claude plugin marketplace add $source' later"
        return
    fi

    if claude plugin marketplace list --json 2>/dev/null | grep -q '"name": "dotfiles"'; then
        echo -e "${GREEN}[ok]${NC} marketplace dotfiles -> $source"
        return
    fi

    echo -e "${GREEN}[add]${NC} marketplace dotfiles -> $source"
    claude plugin marketplace add "$source" --scope user >/dev/null ||
        echo -e "${RED}[error]${NC} could not add marketplace $source" >&2
}

if [ "${1:-}" = "--skills-only" ]; then
    link_skills
    register_claude_marketplace
    exit 0
fi

echo "Setting up dotfiles from $DOTFILES_DIR"
echo ""

# Ghostty
link "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"

# Herdr
link "$DOTFILES_DIR/herdr/config.toml" "$HOME/.config/herdr/config.toml"

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

# Shared agent instructions. Claude Code only reads AGENTS.md as *project*
# instructions, so the global copy must be linked as ~/.claude/CLAUDE.md.
link "$DOTFILES_DIR/home/AGENTS.md" "$HOME/AGENTS.md"
link "$DOTFILES_DIR/home/AGENTS.md" "$HOME/.claude/CLAUDE.md"

# Claude Code
link "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
link "$DOTFILES_DIR/claude/keybindings.json" "$HOME/.claude/keybindings.json"
link "$DOTFILES_DIR/claude/hooks/herdr-agent-state.sh" "$HOME/.claude/hooks/herdr-agent-state.sh"

# Local agent skills (app-managed skills stay in their original directories).
link_skills
register_claude_marketplace

echo ""
echo -e "${GREEN}Done!${NC}"
