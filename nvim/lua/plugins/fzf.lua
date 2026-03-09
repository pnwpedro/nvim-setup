return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
        winopts = {
          height = 0.85,
          width = 0.85,
          preview = { layout = "vertical", vertical = "down:50%" },
        },
      })

      local map = vim.keymap.set
      -- Files
      map("n", "<leader>ff", function() fzf.files() end,        { desc = "Find files" })
      map("n", "<leader>fr", function() fzf.oldfiles() end,     { desc = "Recent files" })
      map("n", "<leader>fb", function() fzf.buffers() end,      { desc = "Find buffers" })
      -- Search
      map("n", "<leader>fg", function() fzf.live_grep() end,    { desc = "Live grep" })
      map("n", "<leader>fw", function() fzf.grep_cword() end,   { desc = "Grep word under cursor" })
      map("n", "<leader>fs", function() fzf.grep_visual() end,  { desc = "Grep selection" })
      -- LSP
      map("n", "<leader>fd", function() fzf.lsp_document_symbols() end,  { desc = "Document symbols" })
      map("n", "<leader>fD", function() fzf.lsp_live_workspace_symbols() end, { desc = "Workspace symbols" })
      map("n", "<leader>fx", function() fzf.diagnostics_document() end,  { desc = "Document diagnostics" })
      -- Git
      map("n", "<leader>gc", function() fzf.git_commits() end,  { desc = "Git commits" })
      map("n", "<leader>gs", function() fzf.git_status() end,   { desc = "Git status" })
      -- Misc
      map("n", "<leader>fk", function() fzf.keymaps() end,      { desc = "Find keymaps" })
      map("n", "<leader>fh", function() fzf.helptags() end,     { desc = "Help tags" })
      map("n", "<leader>f:", function() fzf.command_history() end, { desc = "Command history" })
    end,
  },
}
