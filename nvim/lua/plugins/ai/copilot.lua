return {
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    cmd = "Copilot",
    -- event = "InsertEnter",
    build = ":Copilot auth",
    keys = {
      { "<leader>cp", "<cmd>Copilot toggle<cr>", desc = "Toggle Copilot" },
    },
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,

          auto_trigger = true,
          keymap = {
            accept = "<C-l>",
            accept_word = "<M-p>",
            accept_line = "<M-P>",
            -- accept = "<TAB>",
            next = "<C-n>",
            prev = "<C-N>",
            dismiss = "<C-c>",
          },
        },
      })
    end,
  },
  { "AndreM222/copilot-lualine" },
}
