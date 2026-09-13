return {
  "hat0uma/prelive.nvim",
  opts = {},
  config = function()
    require("prelive").setup({
      server = {
        port = 3000
      }
    })
    vim.keymap.set("n", "<leader>tl", "<cmd>PreLiveGo<cr>", { desc = "Toggle Live Server" })
  end,
  cmd = {
    "PreLiveGo",
    "PreLiveStatus",
    "PreLiveClose",
    "PreLiveCloseAll",
    "PreLiveLog",
  },
}
