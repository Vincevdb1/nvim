return {
  "Mirsmog/real-icons.nvim",
  build = ":RealIconsInstallPack material",
  opts = {
    pack = "material",
    integrations = {
      telescope = true,
    },
  },
  config = function()
    require("real-icons").setup({
      pack = "material",
      packs = {},
      overrides = {},
      backend = "auto",
      size = {
        cols = 2,
        rows = 1,
        pixels = 64,
        padding = 0,
        trim = false,
      },
      color = {
        tint = nil,
        saturation = 0,
        brightness = 0,
        hue = 0,
        monochrome = false,
      },
      fallback = {
        enabled = true,
        provider = "auto",
      },
      integrations = {
        bufferline = true,
        lualine = false,
        mini_files = false,
        neo_tree = false,
        nvim_tree = false,
        oil = false,
        snacks_picker = true,
        telescope = false,
        telescope_file_browser = false,
      },
    })
  end,
}
