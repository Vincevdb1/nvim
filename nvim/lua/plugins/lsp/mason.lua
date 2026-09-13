return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = vim.g.is_nixos and {} or {
        "lua_ls",
        "nil",
        "hyprls",
        "clangd",
      },
    },
    keys = {
      { "<leader>um", "<cmd>Mason<cr>", desc = "Mason" },
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
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
      ensure_installed = vim.g.is_nixos and {} or { "stylua" },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
