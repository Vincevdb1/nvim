return {
  "ankushbhagats/match.nvim",
  cmd = { "Match", "MatchWord", "MatchLine" },
  keys = {
    { "<leader>mm", "<cmd>Match<cr>", desc = "Match: Search/Replace" },
    { "<leader>mw", "<cmd>MatchWord<cr>", desc = "Match: Word under cursor" },
    { "<leader>ml", "<cmd>MatchLine<cr>", desc = "Match: Current line" },
  },
  opts = {
    border = "rounded",
  },
}
