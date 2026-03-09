# nvim-setup

My Neovim config and Mac dev environment setup.

## Fresh Mac Setup

```bash
git clone https://github.com/pnwpedro/nvim-setup ~/dev/nvim-setup
cd ~/dev/nvim-setup
./scripts/setup.sh
```

The script will:
- Install Homebrew (if missing)
- Install Neovim, fzf, ripgrep, fd, node, python, dotnet
- Install formatters (stylua, prettierd)
- Symlink `~/dev/nvim-setup/nvim` → `~/.config/nvim`

On first `nvim` launch, lazy.nvim will auto-install all plugins.
Then run `:Mason` to install LSP servers.

## Structure

```
nvim/                   Neovim config
├── init.lua            Entry point — bootstraps lazy.nvim
└── lua/
    ├── config/
    │   ├── options.lua Editor settings
    │   └── keymaps.lua Global keybindings
    └── plugins/
        ├── colorscheme.lua  Catppuccin
        ├── neo-tree.lua     File explorer
        ├── fzf.lua          Fuzzy finder
        ├── treesitter.lua   Syntax & code understanding
        ├── ui.lua           Lualine, bufferline, which-key
        ├── editor.lua       Gitsigns, toggleterm, autopairs, comment
        ├── lsp.lua          Mason + LSP (pyright, terraformls, omnisharp)
        ├── completion.lua   nvim-cmp + LuaSnip
        └── formatting.lua   conform.nvim + nvim-lint

scripts/
└── setup.sh            Full Mac setup script
```

## Key Bindings

Leader key: `<Space>`

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fw` | Grep word under cursor |
| `<leader>fd` | Document symbols |
| `<leader>gc` | Git commits |
| `<leader>gs` | Git status |
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover docs |
| `<leader>lr` | Rename symbol |
| `<leader>la` | Code action |
| `<leader>lf` | Format buffer |
| `]d` / `[d` | Next/prev diagnostic |
| `<leader>t` | Toggle terminal |

## LSP Servers

| Language | Server | Formatter |
|----------|--------|-----------|
| Python | pyright | ruff |
| Terraform | terraform-ls | terraform fmt |
| C# | omnisharp | csharpier |
