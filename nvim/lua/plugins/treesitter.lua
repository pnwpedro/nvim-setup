local parsers = {
  "lua", "vim", "vimdoc",
  "python",
  "c_sharp",
  "hcl", "terraform",
  "bash",
  "json", "yaml", "toml",
  "markdown", "markdown_inline",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup()

      -- Enable treesitter highlighting for any buffer with a known parser
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local ft = vim.bo.filetype
          if vim.treesitter.language.get_lang(ft) then
            pcall(vim.treesitter.start)
          end
        end,
      })

      -- Install parsers that are missing
      local installed = require("nvim-treesitter").get_installed()
      local to_install = {}
      for _, p in ipairs(parsers) do
        if not vim.tbl_contains(installed, p) then
          table.insert(to_install, p)
        end
      end
      if #to_install > 0 then
        vim.cmd("TSInstall " .. table.concat(to_install, " "))
      end
    end,
  },
}
