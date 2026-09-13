return {
  "Exafunction/windsurf.nvim",
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("codeium").setup({
      enable_cmp_source = false,
      virtual_text = {
        enabled = true,

        key_bindings = {
          accept = "<M-l>",
          accept_word = false,
          accept_line = false,
          clear = "<C-c>",
          next = "<C-n>",
          prev = "<C-m>",
        },
      },
    })
    -- Disable by default
    require("codeium").disable()
    vim.g.codeium_status = false

    vim.keymap.set("n", "<leader>cc", function()
      require("codeium").toggle()
      vim.g.codeium_status = not vim.g.codeium_status
    end, { desc = "Toggle Codeium" })

    require("codeium.virtual_text").set_statusbar_refresh(function()
      require("lualine").refresh()
    end)
  end,
}
