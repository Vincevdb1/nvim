-- Bootstrap lazy.nvimlazy.lualazy.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins.ai" },
    { import = "plugins.behaviors" },
    { import = "plugins.git" },
    { import = "plugins.integrations" },
    { import = "plugins.lsp" },
    { import = "plugins.misc" },
    { import = "plugins.syntax" },
    { import = "plugins.tools" },
    { import = "plugins.ui" },
  },
  -- automatically check for plugin updates
  -- checker = { enabled = true },
})
