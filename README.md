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
- Install formatters (stylua, prettierd, csharpier)
- Symlink `~/dev/nvim-setup/nvim` → `~/.config/nvim`
- Bootstrap lazy.nvim plugins and Mason LSP servers (pyright, terraform-ls, roslyn)

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
        ├── editor.lua       Gitsigns, toggleterm, autopairs, comment, bufremove
        ├── lsp.lua          Mason + LSP (pyright, terraformls, roslyn)
        ├── completion.lua   nvim-cmp + LuaSnip
        └── formatting.lua   conform.nvim + nvim-lint

scripts/
└── setup.sh            Full Mac setup script
```

## Per-project overrides

`opt.exrc = true` is set in `nvim/lua/config/options.lua`, so Neovim will load a `.nvim.lua` from any project root (with a one-time `:trust` prompt). Use this for repo-scoped settings that shouldn't live in the global config.

Example — auto-select the target solution for `seblyng/roslyn.nvim` in a repo that has multiple `.sln`/`.slnx` files (otherwise you get `Multiple potential target files found` on every `.cs` open):

```lua
-- <repo-root>/.nvim.lua
local root = vim.fs.dirname(debug.getinfo(1, "S").source:sub(2))
vim.g.roslyn_nvim_selected_solution = root .. "/YourSolution.slnx"
```

Keep `.nvim.lua` out of the project repo — either `.gitignore` it or add to `.git/info/exclude`.

## LSP Servers

| Language | Server | Formatter |
|----------|--------|-----------|
| Python | pyright | ruff |
| Terraform | terraform-ls | terraform fmt |
| C# | roslyn (seblyng/roslyn.nvim) | csharpier |
