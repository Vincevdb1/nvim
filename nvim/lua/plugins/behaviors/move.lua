return {
  "fedepujol/move.nvim",
  config = function()
    require("move").setup({})

    local opts = { noremap = true, silent = true }

    -- Normal-mode commands
    vim.keymap.set("n", "<a-j>", ":MoveLine(1)<cr>", opts)
    vim.keymap.set("n", "<a-k>", ":MoveLine(-1)<cr>", opts)
    vim.keymap.set("n", "<a-h>", ":movehchar(-1)<cr>", opts)
    vim.keymap.set("n", "<a-l>", ":movehchar(1)<cr>", opts)
    -- vim.keymap.set("n", "<leader>wf", ":MoveWord(1)<cr>", opts)
    -- vim.keymap.set("n", "<leader>wb", ":MoveWord(-1)<cr>", opts)

    -- visual-mode commands
    vim.keymap.set("v", "<a-j>", ":MoveBlock(1)<cr>", opts)
    vim.keymap.set("v", "<a-k>", ":MoveBlock(-1)<cr>", opts)
    vim.keymap.set("v", "<a-h>", ":movehblock(-1)<cr>", opts)
    vim.keymap.set("v", "<a-l>", ":movehblock(1)<cr>", opts)
  end,
}
