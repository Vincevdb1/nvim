return {
  "Root-lee/screensaver.nvim",
  config = function()
    require("screensaver").setup({
      idle_ms = 15 * 60 * 1000,
      animations = {
        "matrix",
        "rain",
        "game_of_life",
        "scramble",
        "pipes"
      },
    })
  end,
}
