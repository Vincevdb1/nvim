return {
  "nvim-tree/nvim-web-devicons",
  lazy = true,
  config = function()
    require("nvim-web-devicons").setup({
      override_by_filename = {
        [".envrc"] = {
          icon = "",
          color = "#5a5a5a",
          name = "envrc",
        },
      },
      override_by_extension = {
        ["log"] = {
          icon = "",
          color = "#5a5a5a",
          name = "log",
        },
      },
      default = true,
    })
  end,
}
