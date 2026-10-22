return {
  "fedepujol/move.nvim",
  cmd = { "MoveLine", "MoveHChar", "MoveBlock", "MoveHBlock", "MoveWord" },
  keys = {
    -- Normal-mode commands
    { "<a-j>", ":MoveLine(1)<cr>", silent = true },
    { "<a-k>", ":MoveLine(-1)<cr>", silent = true },
    { "<a-h>", ":MoveHChar(-1)<cr>", silent = true },
    { "<a-l>", ":MoveHChar(1)<cr>", silent = true },

    -- visual-mode commands
    { "<a-j>", ":MoveBlock(1)<cr>", mode = "v", silent = true },
    { "<a-k>", ":MoveBlock(-1)<cr>", mode = "v", silent = true },
    { "<a-h>", ":MoveHBlock(-1)<cr>", mode = "v", silent = true },
    { "<a-l>", ":MoveHBlock(1)<cr>", mode = "v", silent = true },
  },
  opts = {},
}
