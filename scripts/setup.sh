#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> nvim-setup: Mac setup script"
echo "    Repo: $REPO_DIR"
echo ""

# ── Homebrew ─────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✓  Homebrew already installed"
fi

# ── Core tools ────────────────────────────────────────────────────────────────
echo "==> Installing core tools..."
brew install \
  neovim \
  fzf \
  ripgrep \
  fd \
  git \
  node \
  python \
  dotnet

echo "✓  Core tools installed"

# ── Optional: install stylua (Lua formatter used by conform.nvim) ─────────
if ! command -v stylua &>/dev/null; then
  echo "==> Installing stylua..."
  brew install stylua
else
  echo "✓  stylua already installed"
fi

# ── Optional: install prettierd (JSON/YAML/Markdown formatter) ───────────
if ! command -v prettierd &>/dev/null; then
  echo "==> Installing prettierd..."
  npm install -g @fsouza/prettierd
else
  echo "✓  prettierd already installed"
fi

# ── Neovim config symlink ─────────────────────────────────────────────────────
NVIM_CONFIG_SRC="$REPO_DIR/nvim"
NVIM_CONFIG_DST="$HOME/.config/nvim"

if [ -L "$NVIM_CONFIG_DST" ]; then
  echo "✓  ~/.config/nvim symlink already exists"
elif [ -d "$NVIM_CONFIG_DST" ]; then
  echo "==> Backing up existing ~/.config/nvim to ~/.config/nvim.bak..."
  mv "$NVIM_CONFIG_DST" "${NVIM_CONFIG_DST}.bak"
  ln -s "$NVIM_CONFIG_SRC" "$NVIM_CONFIG_DST"
  echo "✓  Symlinked ~/.config/nvim -> $NVIM_CONFIG_SRC"
else
  ln -s "$NVIM_CONFIG_SRC" "$NVIM_CONFIG_DST"
  echo "✓  Symlinked ~/.config/nvim -> $NVIM_CONFIG_SRC"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "✓  Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Open nvim — lazy.nvim will auto-install all plugins on first launch"
echo "  2. Run :Mason to verify LSP servers (pyright, terraformls, omnisharp)"
echo "  3. Run :TSUpdate to ensure all treesitter parsers are current"
