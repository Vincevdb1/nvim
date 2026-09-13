return {
  'richwomanbtc/overleaf.nvim',
  config = function()
    require('overleaf').setup({
      pdf_viewer = "false" -- Disables auto opening
    })
  end,
  build = 'cd node && npm install',
}
