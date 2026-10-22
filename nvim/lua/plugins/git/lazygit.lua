return {
  -- Git TUI inside Neovim
  "kdheepak/lazygit.nvim",
  config = function()
    vim.keymap.set("n", "<leader>gl", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
  end,
}
