return {
  -- Formatter
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        python    = { "ruff_format" },
        terraform = { "terraform_fmt" },
        tf        = { "terraform_fmt" },
        cs        = { "csharpier" },
        lua       = { "stylua" },
        json      = { "prettierd" },
        yaml      = { "prettierd" },
        markdown  = { "prettierd" },
      },
      -- Format on save
      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = true,
      },
    },
  },

  -- Linter (ruff for Python, tflint for Terraform)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python    = { "ruff" },
        terraform = { "tflint" },
      }
      -- Run lint on save and when entering a buffer
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
