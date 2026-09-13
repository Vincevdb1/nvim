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
  },
  {
    -- detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",
  },
}

