return {
  "folke/which-key.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    preset = "modern",
    spec = {
      { "<leader>a", group = "AI" },
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>gh", group = "Hunks" },
      { "<leader>m", group = "Match" },
      { "<leader>r", group = "Run" },
      { "<leader>t", group = "Tools" },
      { "<leader>u", group = "UI / Toggles" },
      { "<leader>un", group = "Notifications" },
      { "<leader>x", group = "Diagnostics / Lists" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps",
    },
  },
}
