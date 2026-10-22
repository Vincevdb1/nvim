return {
  "NStefan002/screenkey.nvim",
  cmd = "Screenkey",
  config = function()
    require("screenkey").setup({
      win_opts = {
        width = 50,
      },
      keys = {
        ["<Tab>"] = "󰌒",
        ["<CR>"] = "󰌑",
        ["<Esc>"] = "󱊷",
        ["<Space>"] = "␣",
        ["<BS"] = "󰌥",
        ["<Del>"] = "",
        ["<Left>"] = "",
        ["<Right>"] = "",
        ["<Up>"] = "",
        ["<Down>"] = "",
        ["<Home>"] = "Home",
        ["<End>"] = "End",
        ["<PageUp>"] = "PgUp",
        ["<PageDown>"] = "PgDn",
        ["<Insert>"] = "Ins",
        ["<F1>"] = "󱊫",
        ["<F2>"] = "󱊬",
        ["<F3>"] = "󱊭",
        ["<F4>"] = "󱊮",
        ["<F5>"] = "󱊯",
        ["<F6>"] = "󱊰",
        ["<F7>"] = "󱊱",
        ["<F8>"] = "󱊲",
        ["<F9>"] = "󱊳",
        ["<F10>"] = "󱊴",
        ["<F11>"] = "󱊵",
        ["<F12>"] = "󱊶",
        ["CTRL"] = "Ctrl",
        ["ALT"] = "Alt",
        ["SUPER"] = "󰘳",
        ["<leader>"] = "␣",
      },
    })

    require("screenkey").toggle_statusline_component()
  end,
}
