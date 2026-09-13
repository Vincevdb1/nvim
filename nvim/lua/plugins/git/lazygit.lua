return {
  -- Git TUI inside Neovim
  "kdheepak/lazygit.nvim",
  config = function()
    local wk = require("which-key")

    wk.add({
      { "<leader>g", group = "Git" },
    })

    vim.keymap.set("n", "<leader>gl", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
  end,
}
