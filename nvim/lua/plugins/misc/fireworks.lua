return {
  "btj93/fireworks.nvim",
  lazy = true,
  cmd = "Fireworks",
  config = function(_, opts)
    local fireworks = require("fireworks")
    fireworks.setup(opts)
    -- Off by default; armed with <leader>uF (toggle lives in snacks.lua)
    fireworks.enabled = false
  end,
}
