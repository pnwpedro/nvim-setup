return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    opts = {
      close_if_last_window = true,
      window = {
        width = 35,
        mappings = {
          ["<space>"] = "none", -- don't conflict with leader
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        hide_dotfiles = false,
        hide_gitignored = false,
        filtered_items = {
          visible = true, -- show filtered items dimmed
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
      buffers = {
        follow_current_file = { enabled = true },
      },
      default_component_configs = {
        git_status = {
          symbols = {
            added     = "✚",
            modified  = "",
            deleted   = "✖",
            renamed   = "󰁕",
            untracked = "",
            ignored   = "",
            unstaged  = "󰄱",
            staged    = "",
            conflict  = "",
          },
        },
      },
    },
  },
}
