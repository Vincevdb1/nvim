return {
  "ramanshrivastava/claude-complete.nvim",
  event = "InsertEnter",
  opts = {
    keymaps = { trigger = false, accept = "<C-l>", cancel = "<C-c>" },
    auto = { enabled = true, model = "haiku" },
  },
}
