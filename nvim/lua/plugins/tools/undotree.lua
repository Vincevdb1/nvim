return {
  "XXiaoA/atone.nvim",
  cmd = "Atone",
  keys = {
    { "<leader>uu", "<cmd>Atone toggle<cr>", desc = "Undotree" },
  },
  opts = {
    auto_attach = {
      excluded_ft = { "neotree" },
    },
  },
}
