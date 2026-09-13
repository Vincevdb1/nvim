return {
  {
    "mbbill/undotree",
    enabled = false,
    config = function()
      vim.keymap.set("n", "<leader>uu", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
    end,
  },
  {
    "XXiaoA/atone.nvim",
    enabled = true,
    config = function()
      require("atone").setup({
        auto_attach = {
          excluded_ft = { "neotree"}
        }
      })
      vim.keymap.set("n", "<leader>uu", ":Atone toggle<CR>", { desc = "Toggle Undotree" })
    end,
  },
}
