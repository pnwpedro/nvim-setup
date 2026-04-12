return {
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")

      -- Helper: pad string to width
      local function pad(str, width)
        return str .. string.rep(" ", width - #str)
      end

      -- Helper: build a two-column row from key/desc pairs
      local function columns(left_key, left_desc, right_key, right_desc)
        local col_w = 38
        local left = "  " .. pad(left_key, 14) .. left_desc
        local right = ""
        if right_key then
          right = "  " .. pad(right_key, 14) .. right_desc
        end
        return pad(left, col_w) .. right
      end

      -- Highlight groups
      vim.api.nvim_set_hl(0, "AlphaHeader", { link = "Type" })
      vim.api.nvim_set_hl(0, "AlphaSection", { link = "Keyword" })
      vim.api.nvim_set_hl(0, "AlphaKey", { link = "String" })
      vim.api.nvim_set_hl(0, "AlphaShortcut", { link = "Number" })

      local header = {
        type = "text",
        val = {
          "",
          [[                    ╱|、              ]],
          [[                   (˚ˎ 。7            ]],
          [[                    |、˜〵            ]],
          [[                    じしˍ,)ノ         ]],
          "",
          [[        ~ nvim for plebeians ~        ]],
          "",
          [[   you need a cheat sheet to use a    ]],
          [[   text editor. you are being judged.  ]],
          "",
        },
        opts = { position = "center", hl = "AlphaHeader" },
      }

      local leader_info = {
        type = "text",
        val = {
          "   Space = Leader     \\ = Local leader     C = Ctrl     S = Shift     :q! = surrender",
          "",
        },
        opts = { position = "center", hl = "AlphaSection" },
      }

      local cheatsheet = {
        type = "text",
        val = {
          " Files & Navigation                     Code Navigation (LSP)",
          " ───────────────────                     ─────────────────────",
          columns("<ldr> e",     "Toggle explorer",    "gd",          "Go to definition"),
          columns("<ldr> o",     "Focus explorer",     "gD",          "Go to declaration"),
          columns("<ldr> ff",    "Find files",         "gr",          "References"),
          columns("<ldr> fg",    "Live grep",          "gi",          "Go to implementation"),
          columns("<ldr> fr",    "Recent files",       "K",           "Hover docs"),
          columns("<ldr> fb",    "Find buffers",       "<C-k>",       "Signature help"),
          columns("<ldr> fw",    "Grep word at cursor", "<ldr> lr",   "Rename symbol"),
          columns("<ldr> fk",    "Find keymaps",       "<ldr> la",    "Code action"),
          columns("<ldr> fh",    "Help tags",          "<ldr> lf",    "Format buffer"),
          "",
          " Buffers & Windows                      Diagnostics",
          " ──────────────────                      ───────────",
          columns("S-h",         "Previous buffer",    "<ldr> ld",    "Line diagnostics"),
          columns("S-l",         "Next buffer",        "]d",          "Next diagnostic"),
          columns("<ldr> bd",    "Delete buffer",      "[d",          "Prev diagnostic"),
          columns("<C-h/j/k/l>", "Navigate windows",   "<ldr> fx",   "Document diagnostics"),
          columns("<ldr> w",     "Save file",          "",            ""),
          columns("<ldr> q",     "Quit",               "",            ""),
          "",
          " Movement & Editing                     Git",
          " ─────────────────                       ───",
          columns("<C-o>",       "Jump back",          "<ldr> gs",    "Git status"),
          columns("<C-i>",       "Jump forward",       "<ldr> gc",    "Git commits"),
          columns("<C-d>",       "Half-page down",     "<ldr> gp",    "Preview hunk"),
          columns("<C-u>",       "Half-page up",       "<ldr> gr",    "Reset hunk"),
          columns("J/K (vis)",   "Move lines up/down", "<ldr> gb",    "Blame line"),
          columns("jk (ins)",    "Exit insert mode",   "]h / [h",     "Next/prev hunk"),
          "",
          " Other                                  Symbols (LSP + fzf)",
          " ─────                                  ────────────────────",
          columns("<ldr> t",     "Toggle terminal",    "<ldr> fd",    "Document symbols"),
          columns("gc (vis)",    "Toggle comment",     "<ldr> fD",    "Workspace symbols"),
          columns("Esc",         "Clear search hl",    "<ldr> f:",    "Command history"),
          columns("<ldr> h",     "This cheat sheet",   "",            ""),
          "",
        },
        opts = { position = "center", hl = "AlphaKey" },
      }

      local config = {
        layout = {
          header,
          { type = "padding", val = 1 },
          leader_info,
          cheatsheet,
        },
        opts = { margin = 3 },
      }

      alpha.setup(config)

      vim.keymap.set("n", "<leader>h", "<cmd>Alpha<CR>", { desc = "Cheat sheet" })

      -- Disable folding on alpha buffer
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "alpha",
        callback = function()
          vim.opt_local.foldenable = false
          vim.opt_local.laststatus = 0
        end,
      })
    end,
  },
}
