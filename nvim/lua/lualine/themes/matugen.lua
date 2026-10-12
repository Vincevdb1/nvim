local c = require("config.matugen").load()
if not c then
  return require("lualine.themes.auto")
end

local function mode(color, fg)
  return {
    a = { fg = fg or c.background, bg = color, gui = "bold" },
    b = { fg = color, bg = "NONE" },
    c = { fg = c.foreground, bg = "NONE" },
  }
end

return {
  normal = mode(c.primary, c.on_primary),
  insert = mode(c.green),
  visual = mode(c.yellow),
  replace = mode(c.red),
  command = mode(c.magenta),
  terminal = mode(c.cyan),
  inactive = {
    a = { fg = c.outline, bg = "NONE", gui = "bold" },
    b = { fg = c.outline, bg = "NONE" },
    c = { fg = c.outline, bg = "NONE" },
  },
}
