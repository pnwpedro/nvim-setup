local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.showmode = false  -- lualine shows this

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Files
opt.undofile = true
opt.swapfile = false
opt.backup = false

-- Load per-project `.nvim.lua` (with trust prompt)
opt.exrc = true

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Clipboard (sync with system)
opt.clipboard = "unnamedplus"

-- Update time (faster CursorHold, gitsigns)
opt.updatetime = 250

-- Ensure filetype detection runs for buffers opened by plugins (e.g. neo-tree)
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    if vim.bo.filetype == "" then
      vim.cmd("filetype detect")
    end
  end,
})
