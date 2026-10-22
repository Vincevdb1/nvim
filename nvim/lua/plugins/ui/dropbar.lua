return {
  "Bekaboo/dropbar.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function() 
    require("dropbar.api")
    vim.api.nvim_set_hl(0, 'WinBar', { fg = '#5A5A5A' })
  end,
}
