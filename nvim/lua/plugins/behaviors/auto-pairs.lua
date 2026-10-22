return {
  {
    -- Autoclose parentheses, brackets, quotes, etc.
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    opts = {},
  },
  {
    -- autoclose tags
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    -- detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",
    event = { "BufReadPre", "BufNewFile" },
  },
}

