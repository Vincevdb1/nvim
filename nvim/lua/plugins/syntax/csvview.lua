return {
  "hat0uma/csvview.nvim",
  ft = { "csv", "tsv" },
  config = function()
    require("csvview").setup({
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    })

    require("csvview").enable()

    vim.api.nvim_set_hl(0, "CsvViewCol0", { fg = "#A6626D" })
    vim.api.nvim_set_hl(0, "CsvViewCol1", { fg = "#CB9990" })
    vim.api.nvim_set_hl(0, "CsvViewCol2", { fg = "#D9A69F" })
    vim.api.nvim_set_hl(0, "CsvViewCol3", { fg = "#F0DAD5" })
    vim.api.nvim_set_hl(0, "CsvViewCol4", { fg = "#B8C4A9" })
    vim.api.nvim_set_hl(0, "CsvViewCol5", { fg = "#FFBDBD" })
    vim.api.nvim_set_hl(0, "CsvViewCol6", { fg = "#A4D8F8" })
    vim.api.nvim_set_hl(0, "CsvViewCol7", { fg = "#C2A68C" })
    vim.api.nvim_set_hl(0, "CsvViewCol8", { fg = "#E6D8C3" })
  end,
  cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
}
