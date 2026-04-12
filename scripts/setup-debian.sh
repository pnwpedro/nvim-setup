#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> nvim-setup: Debian 12 setup script"
echo "    Repo: $REPO_DIR"
echo ""

# ── System packages ──────────────────────────────────────────────────────────
echo "==> Updating apt and installing core packages..."
sudo apt-get update
sudo apt-get install -y \
  git \
  curl \
  build-essential \
  fzf \
  ripgrep \
  fd-find \
  python3 \
  python3-pip \
  python3-venv \
  unzip

# fd is named fdfind on Debian — symlink it so plugins find it as "fd"
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
  sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
  echo "✓  Symlinked fdfind -> fd"
fi

# ── Neovim (stable PPA — Debian 12 ships an old version) ────────────────────
if ! command -v nvim &>/dev/null || [[ "$(nvim --version | head -1 | grep -oP '\d+\.\d+')" < "0.11" ]]; then
  echo "==> Installing Neovim from GitHub releases..."
  NVIM_URL="https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz"
  curl -fsSL "$NVIM_URL" -o /tmp/nvim.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar xzf /tmp/nvim.tar.gz -C /opt
  sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  rm /tmp/nvim.tar.gz
  echo "✓  Neovim installed to /opt/nvim-linux-x86_64"
else
  echo "✓  Neovim $(nvim --version | head -1) already installed"
fi

# ── Node.js (for prettierd, tree-sitter-cli) ────────────────────────────────
if ! command -v node &>/dev/null; then
  echo "==> Installing Node.js via NodeSource..."
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt-get install -y nodejs
else
  echo "✓  Node.js already installed"
fi

# ── .NET SDK (for csharpier, roslyn) ─────────────────────────────────────────
if ! command -v dotnet &>/dev/null; then
  echo "==> Installing .NET SDK..."
  curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
  chmod +x /tmp/dotnet-install.sh
  /tmp/dotnet-install.sh --channel LTS --install-dir "$HOME/.dotnet"
  rm /tmp/dotnet-install.sh
  export PATH="$HOME/.dotnet:$PATH"
  # Add to shell profile if not already there
  if ! grep -q '\.dotnet' "$HOME/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.dotnet:$HOME/.dotnet/tools:$PATH"' >> "$HOME/.bashrc"
    echo "✓  Added .dotnet to ~/.bashrc"
  fi
else
  echo "✓  .NET SDK already installed"
fi

# ── tree-sitter CLI ─────────────────────────────────────────────────────────
if ! command -v tree-sitter &>/dev/null; then
  echo "==> Installing tree-sitter-cli via npm..."
  sudo npm install -g tree-sitter-cli
else
  echo "✓  tree-sitter-cli already installed"
fi

# ── Formatters & linters ─────────────────────────────────────────────────────
echo "==> Installing formatters & linters..."

# stylua
if ! command -v stylua &>/dev/null; then
  echo "==> Installing stylua..."
  STYLUA_URL="https://github.com/JohnnyMorganz/StyLua/releases/latest/download/stylua-linux-x86_64.zip"
  curl -fsSL "$STYLUA_URL" -o /tmp/stylua.zip
  sudo unzip -o /tmp/stylua.zip -d /usr/local/bin
  sudo chmod +x /usr/local/bin/stylua
  rm /tmp/stylua.zip
else
  echo "✓  stylua already installed"
fi

# ruff
if ! command -v ruff &>/dev/null; then
  echo "==> Installing ruff..."
  pip3 install --user ruff
else
  echo "✓  ruff already installed"
fi

# tflint
if ! command -v tflint &>/dev/null; then
  echo "==> Installing tflint..."
  curl -fsSL https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
else
  echo "✓  tflint already installed"
fi

# prettierd
if ! command -v prettierd &>/dev/null; then
  echo "==> Installing prettierd..."
  sudo npm install -g @fsouza/prettierd
else
  echo "✓  prettierd already installed"
fi

# csharpier
if ! command -v dotnet-csharpier &>/dev/null; then
  echo "==> Installing csharpier..."
  dotnet tool install -g csharpier
else
  echo "✓  csharpier already installed"
fi

# ── Neovim config symlink ────────────────────────────────────────────────────
NVIM_CONFIG_SRC="$REPO_DIR/nvim"
NVIM_CONFIG_DST="$HOME/.config/nvim"

mkdir -p "$HOME/.config"

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

# ── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo "✓  Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Run: source ~/.bashrc (or open a new shell)"
echo "  2. Open nvim and verify with :LspInfo in a .cs, .py, or .tf file"
echo "  3. Run :TSUpdate to ensure all treesitter parsers are current"
