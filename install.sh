#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${REPO_DIR:-$HOME/Repos/nvim}"   # adjust if needed
TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

mkdir -p "$(dirname "$TARGET")"
[ -e "$TARGET" ] && mv "$TARGET" "$TARGET.bak.$(date +%s)" || true
ln -s "$REPO_DIR" "$TARGET"

# Optional: install lazy.nvim if missing
if [ ! -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]; then
  git clone --filter=blob:none https://github.com/folke/lazy.nvim.git \
    "$HOME/.local/share/nvim/lazy/lazy.nvim"
fi

echo "✅ Linked $REPO_DIR -> $TARGET"
echo "Now run: nvim +Lazy! sync +qa"
