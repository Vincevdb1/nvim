vim.opt.nu = true
vim.opt.fillchars = {eob = " "}

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.wrap = false

vim.opt.clipboard = 'unnamedplus'

vim.opt.scrolloff = 10

vim.opt.undofile = true

vim.opt.signcolumn = "yes"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.updatetime = 250
vim.opt.confirm = true

vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'

vim.opt.spell = true
vim.opt.spelllang = { 'en', 'nl' }

local severity = vim.diagnostic.severity
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    -- show error codes
    format = function(diagnostic)
      local code = diagnostic.code and string.format("[%s]", diagnostic.code) or ""
      return string.format("%s %s", code, diagnostic.message)
    end,
  },
  signs = {
    text = {
      [severity.ERROR] = " ",
      [severity.WARN] = " ",
      [severity.HINT] = "󰠠 ",
      [severity.INFO] = " ",
    },
  },
  underline = false,
  update_in_insert = false,
  float = { source = true },
})

vim.filetype.add({
  extension = {
    grm = "yacc",
    xaml = "xaml",
    axaml = "xaml",
  },
  filename = {
    [".env"] = "dosini",
  },
  pattern = {
    ["%.env%..*"] = "dosini",
  },
})

if vim.g.is_windows then
    vim.cmd("language en_US")
end
