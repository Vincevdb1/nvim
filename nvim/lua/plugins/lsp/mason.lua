-- Nix provides the LSPs, linters and formatters, except for the slim build
local use_mason = not vim.g.is_nix or vim.g.mason_auto_install

return {
  {
    "mason-org/mason.nvim",
    enabled = use_mason,
    cmd = "Mason",
    keys = {
      { "<leader>um", "<cmd>Mason<cr>", desc = "Mason" },
    },
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
  {
    "mason-org/mason-lspconfig.nvim",
    enabled = use_mason,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = vim.g.mason_auto_install and {
        "lua_ls",
        "hyprls",
        "clangd",
      } or {},
    },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    enabled = use_mason,
    event = "VeryLazy",
    opts = {
      ensure_installed = vim.g.mason_auto_install and { "stylua" } or {},
    },
    dependencies = {
      "mason-org/mason.nvim",
    },
  },
}
