return {
  "Bekaboo/dropbar.nvim",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  config = function() 
    require("dropbar.api")
    vim.api.nvim_set_hl(0, 'WinBar', { fg = '#5A5A5A' })
  end,
}
