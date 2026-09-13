return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    { "<leader>fs", "<cmd>AutoSession search<CR>", desc = "Find Session" },
    { "<leader>us", "<cmd>AutoSession toggle<CR>", desc = "Toggle Session Autosave" },
  },

  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
  },
}
