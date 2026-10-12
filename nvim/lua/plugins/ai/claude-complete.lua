return {
  "ramanshrivastava/claude-complete.nvim",
  event = "InsertEnter",
  keys = {
    { "<leader>ca", "<cmd>ClaudeCompleteAuto toggle<cr>", desc = "Toggle Claude Autocomplete" },
  },
  opts = {
    keymaps = { trigger = false, accept = "<C-l>", cancel = "<C-c>" },
    auto = { enabled = true, model = "haiku" },
  },
}
