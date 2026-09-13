return {
  "folke/flash.nvim",
  enabled = true,
  event = "VeryLazy",
  keys = {
    { "<Tab>", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  },
}
