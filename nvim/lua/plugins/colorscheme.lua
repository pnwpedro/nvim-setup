return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- load before other plugins
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      integrations = {
        neo_tree = true,
        gitsigns = true,
        treesitter = true,
        cmp = true,
        mason = true,
        which_key = true,
        bufferline = true,
        telescope = false,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
