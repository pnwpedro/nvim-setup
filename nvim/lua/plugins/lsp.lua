return {
  -- Mason: installs LSP servers, linters, formatters
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed   = "✓",
          package_pending     = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Mason bridge: auto-installs servers
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "pyright",     -- Python
        "terraformls", -- Terraform
        "omnisharp",   -- C#
      },
      automatic_installation = true,
    },
  },

  -- nvim-lspconfig: provides default server configs (cmd, filetypes, etc.)
  -- We keep it as a runtime source but avoid the deprecated .setup() API.
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Diagnostic display
      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        severity_sort = true,
        float = { border = "rounded", source = true },
      })

      -- Keymaps set whenever an LSP attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          map("gd",         vim.lsp.buf.definition,      "Go to definition")
          map("gD",         vim.lsp.buf.declaration,     "Go to declaration")
          map("gr",         vim.lsp.buf.references,      "References")
          map("gi",         vim.lsp.buf.implementation,  "Go to implementation")
          map("K",          vim.lsp.buf.hover,           "Hover docs")
          map("<C-k>",      vim.lsp.buf.signature_help,  "Signature help")
          map("<leader>lr", vim.lsp.buf.rename,          "Rename symbol")
          map("<leader>la", vim.lsp.buf.code_action,     "Code action")
          map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
          map("<leader>ld", vim.diagnostic.open_float,   "Line diagnostics")
          map("]d",         vim.diagnostic.goto_next,    "Next diagnostic")
          map("[d",         vim.diagnostic.goto_prev,    "Prev diagnostic")
        end,
      })

      -- Configure servers with the new vim.lsp.config API (nvim 0.11+)
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.lsp.config("terraformls", {
        capabilities = capabilities,
      })

      vim.lsp.config("omnisharp", {
        capabilities = capabilities,
        cmd = { "omnisharp" },
        settings = {
          FormattingOptions = {
            EnableEditorConfigSupport = true,
          },
          RoslynExtensionsOptions = {
            AnalyzeOpenDocumentsOnly = true,
          },
        },
      })

      vim.lsp.enable({ "pyright", "terraformls", "omnisharp" })
    end,
  },
}
