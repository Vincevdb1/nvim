return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    { "<leader>fs", "<cmd>AutoSession search<CR>", desc = "Find Session" },
  },

  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
  },
}
