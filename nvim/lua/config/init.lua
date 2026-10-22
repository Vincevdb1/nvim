-- globals
vim.g.is_windows = package.config:sub(1,1) == "\\"
vim.g.is_nixos = vim.fn.getenv("NIXPKGS_CONFIG") ~= vim.NIL and vim.fn.getenv("NIXPKGS_CONFIG") ~= ""
vim.g.is_nix = vim.g.is_nixos or vim.fn.getenv("NVIM_NIX") == "1"
vim.g.is_slim = vim.fn.getenv("NVIM_SLIM") == "1"
-- mason binaries don't run on NixOS, elsewhere only install when nix doesn't ship the tools
vim.g.mason_auto_install = not vim.g.is_nixos and (not vim.g.is_nix or vim.g.is_slim)
vim.g.is_dev_shell = vim.fn.getenv("NVIM_DEV_SHELL") == "1"

require("config.keymaps")
require("config.lazy")
require("config.host-env")
require("config.options")
require("config.autocmds")
require("scripts.diagnostics").setup()

