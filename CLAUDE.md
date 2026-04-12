# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Neovim configuration and dev environment setup for macOS and Debian. The `nvim/` directory is symlinked to `~/.config/nvim` via the setup scripts.

## Setup

```bash
./scripts/setup-mac.sh      # macOS — installs deps via Homebrew
./scripts/setup-debian.sh   # Debian 12 — installs deps via apt + direct downloads
```

Each setup script installs all dependencies, symlinks the config, bootstraps plugins, and installs LSP servers automatically.

## Architecture

- **Plugin manager**: lazy.nvim, bootstrapped in `nvim/init.lua`. Plugins auto-discovered from `nvim/lua/plugins/` (each file returns a lazy.nvim plugin spec table).
- **Config loading order**: `init.lua` → `config/options.lua` → `config/keymaps.lua` → lazy.nvim loads `plugins/*`
- **Treesitter**: Uses the new nvim-treesitter rewrite (main branch). The old `configs` submodule and `ensure_installed`/`highlight`/`indent` opts no longer exist. Parsers are installed via `:TSInstall`, highlighting is enabled via `vim.treesitter.start()` in a `FileType` autocmd. Requires `tree-sitter-cli` (not `tree-sitter`) from Homebrew.
- **LSP**: Uses nvim 0.11+ `vim.lsp.config()` / `vim.lsp.enable()` API (not the deprecated `lspconfig.setup()`). Mason auto-installs pyright and terraform-ls via `mason-lspconfig` `ensure_installed`. C# uses `seblyng/roslyn.nvim` with the Roslyn language server installed via Mason (requires the `Crashdummyy/mason-registry` custom registry).
- **Formatting**: conform.nvim with format-on-save enabled. Formatters: ruff (Python), terraform_fmt, csharpier (C#), stylua (Lua), prettierd (JSON/YAML/Markdown).
- **Linting**: nvim-lint runs on save/read/insert-leave. Linters: ruff (Python), tflint (Terraform).
- **Filetype detection**: `options.lua` has a `BufReadPost` autocmd to run `filetype detect` for buffers with no filetype (needed for files opened via neo-tree).

## Conventions

- Lua files use 2-space indentation (enforced by stylua)
- Each plugin or plugin group gets its own file under `nvim/lua/plugins/`
- Leader key is `<Space>`. LSP keymaps use `<leader>l` prefix, find/search uses `<leader>f`, git uses `<leader>g`
- LSP keymaps are set via `LspAttach` autocmd, not per-server
