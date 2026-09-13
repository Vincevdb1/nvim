return {
  {
    "barkinunal/floaterminal.nvim",
    config = function()
      require("floaterminal").setup({
        width = 0.8,
        height = 0.8,
        border = "rounded",
        max_tab_size = 1,
      })

      vim.keymap.set("n", "<leader>tt", function()
        -- Open Floaterminal
        vim.cmd("Floaterminal")
        vim.opt_local.buflisted = false
        vim.cmd("startinsert")

        -- Get the newly opened terminal buffer
        local term_buf = vim.api.nvim_get_current_buf()

        -- Set <Esc> only for this buffer
        vim.keymap.set("t", "<Esc>", "<cmd>Floaterminal<CR>", {
          buffer = term_buf,
          desc = "Toggle Floating terminal",
        })
      end, { desc = "Toggle Floating terminal" })
    end,
  },
}
