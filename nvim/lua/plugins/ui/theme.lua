return {
  {
    "Mofiqul/vscode.nvim",
    enabled = true,
    config = function()
      require("vscode").setup({
        transparent = true,
        italic_comments = true,
        italic_inlayhints = true,
        underline_links = true,
        -- terminal_colors = true,

        color_overrides = {
          vscTabOutside = "None", -- bufferline bg
          vscLeftMid = "None", -- lualine bg
          vscPopupBack = "None", -- cmp bg
        },
        group_overrides = {
          CursorLineNr = { bold = true, italic = true },
          DropBarIconUISeparator = { fg = "#5A5A5A" },
          BufferLineNumbers = { fg = "#D4D4D4" },
          TreesitterContextSeparator = { fg = "#222222" },
          SnacksDashboardHeader = { fg = "#569CD6" },
        },
      })

      -- Prefer the matugen palette; without one, stay on vscode.
      local matugen = require("config.matugen")
      vim.cmd.colorscheme(matugen.load() and "matugen" or "vscode")
      matugen.watch()
    end,
  },
}
