return {
  {
    "mistricky/codesnap.nvim",
    enabled = vim.g.is_windows,
    build = "make",
    config = function()
      require("codesnap").setup({
        has_breadcrumbs = true,
        has_line_number = true,
        bg_padding = 0,
        watermark = "",
        mac_window_bar = false,
        title = "CodeSnap",
      })

      vim.keymap.set("x", "<leader>us", "<cmd>CodeSnap<cr>", { desc = "CodeSnap Selection" })
    end,
  },
  {
    "narutoxy/silicon.lua",
    enabled = not vim.g.is_windows,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("silicon").setup({
        padHoriz = 0,
        padVert = 0,
        font = "CaskaydiaCove Nerd Font",
        windowControls = false
      })

      vim.keymap.set("v", "<leader>us", function()
        require("silicon").visualise_api({ to_clip = true })
      end)
    end,
  },
}
