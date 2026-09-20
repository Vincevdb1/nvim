-- The nix wrappers point XDG_CONFIG_HOME at this config so neovim can find it.
-- Restore the user's own value for child processes: terminals, LSPs, git.

-- stdpath() re-reads the environment, so pin it before restoring.
vim.g.nvim_config_dir = vim.fn.stdpath("config")

local host = vim.env.NVIM_HOST_XDG_CONFIG_HOME
if host and host ~= "" then
  vim.env.XDG_CONFIG_HOME = host
  vim.env.NVIM_HOST_XDG_CONFIG_HOME = nil
end
