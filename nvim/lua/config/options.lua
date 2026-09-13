vim.opt.nu = true
vim.opt.fillchars = {eob = " "}

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.termguicolors = true

vim.opt.clipboard = 'unnamedplus'

vim.opt.scrolloff = 10

vim.opt.undofile = true

vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'

vim.opt.spell = true
vim.opt.spelllang = { 'en', 'nl' }

vim.filetype.add({
  extension = {
    grm = "yacc",
  },
})

if vim.g.is_windows then
    vim.cmd("language en_US")
end
