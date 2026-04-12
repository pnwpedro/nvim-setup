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
  tree-sitter-cli \
  fzf \
  ripgrep \
  fd \
  git \
  node \
  python \
  dotnet

echo "✓  Core tools installed"

# ── Formatters & linters ─────────────────────────────────────────────────────
echo "==> Installing formatters & linters..."
brew install stylua ruff tflint

if ! command -v prettierd &>/dev/null; then
  echo "==> Installing prettierd..."
  npm install -g @fsouza/prettierd
else
  echo "✓  prettierd already installed"
fi

if ! command -v dotnet-csharpier &>/dev/null; then
  echo "==> Installing csharpier..."
  dotnet tool install -g csharpier
else
  echo "✓  csharpier already installed"
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

# ── Neovim plugin & LSP bootstrap ────────────────────────────────────────────
echo "==> Bootstrapping Neovim plugins and LSP servers..."
nvim --headless \
  -c "lua require('lazy').sync({ wait = true })" \
  -c "MasonInstall pyright terraform-ls roslyn" \
  -c "sleep 30" \
  -c "qa!"

echo "✓  Plugins synced and LSP servers installed"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "✓  Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Open nvim and verify with :LspInfo in a .cs, .py, or .tf file"
echo "  2. Run :TSUpdate to ensure all treesitter parsers are current"
