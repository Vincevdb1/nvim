return {
  "fedepujol/move.nvim",
  cmd = { "MoveLine", "MoveHChar", "MoveBlock", "MoveHBlock", "MoveWord" },
  keys = {
    -- Normal-mode commands
    { "]e", ":MoveLine(1)<cr>", silent = true, desc = "Move line down" },
    { "[e", ":MoveLine(-1)<cr>", silent = true, desc = "Move line up" },
    { "<a-h>", ":MoveHChar(-1)<cr>", silent = true },
    { "<a-l>", ":MoveHChar(1)<cr>", silent = true },

    -- visual-mode commands
    { "J", ":MoveBlock(1)<cr>", mode = "v", silent = true, desc = "Move block down" },
    { "K", ":MoveBlock(-1)<cr>", mode = "v", silent = true, desc = "Move block up" },
    { "<a-h>", ":MoveHBlock(-1)<cr>", mode = "v", silent = true },
    { "<a-l>", ":MoveHBlock(1)<cr>", mode = "v", silent = true },
  },
  opts = {},
}
