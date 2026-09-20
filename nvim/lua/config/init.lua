-- globals
vim.g.is_windows = package.config:sub(1,1) == "\\"
vim.g.is_nixos = vim.fn.getenv("NIXPKGS_CONFIG") ~= vim.NIL and vim.fn.getenv("NIXPKGS_CONFIG") ~= ""
vim.g.is_dev_shell = vim.fn.getenv("NVIM_DEV_SHELL") == "1"

require("config.keymaps")
require("config.lazy")
require("config.host-env")
require("config.options")
require("config.autocmds")

