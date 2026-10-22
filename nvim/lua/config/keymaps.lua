-- Keymaps for better default experience
-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- For conciseness
local opts = {
  noremap = true,
  silent = true,
}

-- Open Lazy
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Open Lazy" })

-- Allow moving the cursor through wrapped lines with j, k
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", {
  expr = true,
  silent = true,
})
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", {
  expr = true,
  silent = true,
})

-- select all text
vim.keymap.set("n", "<C-a>", "ggVG", opts)

-- clear highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- save file
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", opts)

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- delete line without copying into register
-- vim.keymap.set("n", "dd", '"_dd', opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Another option to scroll up
vim.keymap.set("n", "<C-e>", "<C-u>", opts)

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", "<cmd>resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", "<cmd>resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize +2<CR>", opts)
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize -2<CR>", opts)

-- window management
vim.keymap.set("n", "<leader>v", "<C-w>v", {
  noremap = true,
  silent = true,
  desc = "Split window vertically",
})
vim.keymap.set("n", "<leader>h", "<C-w>s", {
  noremap = true,
  silent = true,
  desc = "Split window horizontally",
})
vim.keymap.set("n", "<leader>=", "<C-w>=", { desc = "Equalize splits" })

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

vim.keymap.set("n", "<leader>w", ":Bdelete!<CR>", {
  noremap = true,
  silent = true,
  desc = "Close Buffer",
}) -- close buffer

-- Press jj or kj fast to exit insert mode
vim.keymap.set("i", "jj", "<ESC>", opts)
vim.keymap.set("i", "kj", "<ESC>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)
