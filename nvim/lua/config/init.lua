-- globals
vim.g.is_windows = package.config:sub(1,1) == "\\"
vim.g.is_nixos = vim.fn.getenv("NIXPKGS_CONFIG") ~= vim.NIL and vim.fn.getenv("NIXPKGS_CONFIG") ~= ""

require("config.keymaps")
require("config.lazy")
require("config.options")
require("config.autocmds")

