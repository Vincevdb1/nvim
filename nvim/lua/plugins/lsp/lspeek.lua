return {
  "r4ppz/lspeek.nvim",
  opts = {
    window = {
      border = "rounded",
    },
  },
  keys = {
    {
      "grp",
      function()
        require("lspeek").peek_definition()
      end,
      desc = "Peek LSP definition",
    },
    {
      "grP",
      function()
        require("lspeek").peek_type_definition()
      end,
      desc = "Peek LSP type definition",
    },
  },
}
