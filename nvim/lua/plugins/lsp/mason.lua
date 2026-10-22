return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = vim.g.mason_auto_install and {
        "lua_ls",
        "nil",
        "hyprls",
        "clangd",
      } or {},
    },
    keys = {
      { "<leader>um", "<cmd>Mason<cr>", desc = "Mason" },
    },
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = vim.g.mason_auto_install and { "stylua" } or {},
    },
    dependencies = {
      "mason-org/mason.nvim",
    },
  },
}
