#!/usr/bin/env bash
#
# install.sh – Bootstrap Neovim config
#
# Usage:
#   ./install.sh [--force]
#

set -euo pipefail

# --- CONFIG ---
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"   # folder where script lives
TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
BACKUP_DIR="$HOME/.config-backups"
FORCE=false

# --- ARGS ---
if [[ "${1:-}" == "--force" ]]; then
  FORCE=true
fi

# --- FUNCTIONS ---
backup_target() {
  if [[ -e "$TARGET" || -L "$TARGET" ]]; then
    mkdir -p "$BACKUP_DIR"
    local ts
    ts="$(date +%Y%m%d-%H%M%S)"
    mv "$TARGET" "$BACKUP_DIR/nvim.$ts"
    echo "📦 Existing config moved to $BACKUP_DIR/nvim.$ts"
  fi
}

link_repo() {
  ln -s "$REPO_DIR" "$TARGET"
  echo "🔗 Linked $REPO_DIR → $TARGET"
}

install_lazy() {
  local lazy_path="$HOME/.local/share/nvim/lazy/lazy.nvim"
  if [[ ! -d "$lazy_path" ]]; then
    echo "⬇️  Installing lazy.nvim..."
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git "$lazy_path"
  fi
}

post_instructions() {
  cat <<'EOF'

✅ Setup complete!

Now run:
  nvim +Lazy! sync +qa

This will install plugins and close Neovim.
EOF
}

# --- MAIN ---
if [[ -e "$TARGET" || -L "$TARGET" ]]; then
  if [[ "$FORCE" == true ]]; then
    echo "⚠️  Force mode enabled – overwriting existing config"
    rm -rf "$TARGET"
  else
    backup_target
  fi
fi

link_repo
install_lazy
post_instructions
