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
        },
      })

      vim.cmd.colorscheme("vscode")
    end,
  },
  {
    "RedsXDD/neopywal.nvim",
    name = "neopywal",
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      -- local C = require("neopywal").get_colors()
      -- local U = require("neopywal.utils.color")

      require("neopywal").setup({
        transparent_background = true,
        dim_inactive = false,
        plugins = {
          dashboard = true,
          git_gutter = true,
          indent_blankline = true,
          lazy = true,
          lazygit = true,
          noice = true,
          notify = true,
          nvim_cmp = true,
        },
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = { "bold" },
          includes = { "italic" },
          strings = {},
          variables = { "italic" },
          numbers = {},
          booleans = { "italic" },
          types = { "italic" },
          operators = {},
        },
      })
      if not vim.g.is_windows then
        -- vim.cmd.colorscheme("neopywal")
        -- NOTE: Temporary use vscode theme on Linux due to visability issue with neopywal
        vim.cmd.colorscheme("vscode")
      end
    end,
  },
  {
    "briones-gabriel/darcula-solid.nvim",
    dependencies = {
      "rktjmp/lush.nvim",
    },
  },
}
