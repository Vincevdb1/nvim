-- Colorscheme built from the palette matugen renders to M.path (see the
-- "nvim" template in the dotfiles matugen config).
local M = {}

M.path = (vim.env.XDG_DATA_HOME or vim.fn.expand("~/.local/share")) .. "/matugen/nvim.lua"

local required = {
  "black",
  "red",
  "green",
  "yellow",
  "blue",
  "magenta",
  "cyan",
  "white",
  "bright_black",
  "bright_red",
  "bright_green",
  "bright_yellow",
  "bright_blue",
  "bright_magenta",
  "bright_cyan",
  "bright_white",
  "foreground",
  "background",
  "surface_container_low",
  "surface_container",
  "surface_container_high",
  "surface_container_highest",
  "outline",
  "outline_variant",
  "primary",
  "on_primary",
  "primary_container",
  "on_primary_container",
  "secondary",
  "secondary_container",
  "on_secondary_container",
  "tertiary",
  "on_tertiary",
  "tertiary_container",
  "on_tertiary_container",
  "error",
  "error_container",
  "on_error_container",
}

--- Returns the palette, or nil when the file is missing, broken or incomplete.
function M.load()
  if not vim.uv.fs_stat(M.path) then
    return nil
  end

  local ok, palette = pcall(dofile, M.path)
  if not ok or type(palette) ~= "table" then
    return nil
  end

  for _, key in ipairs(required) do
    local color = palette[key]
    if type(color) ~= "string" or not color:match("^#%x%x%x%x%x%x$") then
      return nil
    end
  end

  return palette
end

local function is_light(hex)
  local r, g, b = tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
  return (0.299 * r + 0.587 * g + 0.114 * b) > 128
end

local function highlights(c)
  return {
    -- Editor
    Normal = { fg = c.foreground, bg = "NONE" },
    NormalNC = { link = "Normal" },
    NormalFloat = { fg = c.foreground, bg = "NONE" },
    FloatBorder = { fg = c.outline, bg = "NONE" },
    FloatTitle = { fg = c.primary, bg = "NONE", bold = true },
    Cursor = { fg = c.on_primary, bg = c.primary },
    CursorLine = { bg = c.surface_container },
    CursorColumn = { link = "CursorLine" },
    ColorColumn = { bg = c.surface_container_low },
    CursorLineNr = { fg = c.primary, bold = true, italic = true },
    LineNr = { fg = c.outline },
    SignColumn = { bg = "NONE" },
    FoldColumn = { fg = c.outline, bg = "NONE" },
    Folded = { fg = c.secondary, bg = c.surface_container },
    WinSeparator = { fg = c.outline_variant, bg = "NONE" },
    VertSplit = { link = "WinSeparator" },
    Visual = { bg = c.primary_container },
    VisualNOS = { link = "Visual" },
    Search = { fg = c.on_secondary_container, bg = c.secondary_container },
    IncSearch = { fg = c.on_primary, bg = c.primary },
    CurSearch = { link = "IncSearch" },
    Substitute = { fg = c.on_tertiary, bg = c.tertiary },
    MatchParen = { fg = c.primary, bg = c.surface_container_highest, bold = true },
    NonText = { fg = c.outline_variant },
    Whitespace = { fg = c.outline_variant },
    SpecialKey = { fg = c.outline_variant },
    EndOfBuffer = { fg = c.outline_variant },
    Conceal = { fg = c.outline },
    Directory = { fg = c.primary },
    Title = { fg = c.primary, bold = true },
    Question = { fg = c.tertiary },
    MoreMsg = { fg = c.tertiary },
    ModeMsg = { fg = c.primary, bold = true },
    ErrorMsg = { fg = c.error },
    WarningMsg = { fg = c.yellow },
    Pmenu = { fg = c.bright_white, bg = "NONE" },
    PmenuSel = { fg = c.on_primary_container, bg = c.primary_container },
    PmenuSbar = { bg = c.surface_container_highest },
    PmenuThumb = { bg = c.secondary },
    WildMenu = { link = "PmenuSel" },
    QuickFixLine = { fg = c.on_secondary_container, bg = c.secondary_container },
    StatusLine = { fg = c.bright_white, bg = "NONE" },
    StatusLineNC = { fg = c.outline, bg = "NONE" },
    TabLine = { fg = c.white, bg = "NONE" },
    TabLineFill = { bg = "NONE" },
    TabLineSel = { fg = c.primary, bg = "NONE", bold = true },
    WinBar = { fg = c.white, bg = "NONE" },
    WinBarNC = { fg = c.outline, bg = "NONE" },
    SpellBad = { sp = c.red, undercurl = true },
    SpellCap = { sp = c.yellow, undercurl = true },
    SpellLocal = { sp = c.cyan, undercurl = true },
    SpellRare = { sp = c.magenta, undercurl = true },

    -- Syntax
    Comment = { fg = c.outline, italic = true },
    Constant = { fg = c.blue },
    String = { fg = c.green },
    Character = { fg = c.green },
    Number = { fg = c.bright_green },
    Boolean = { fg = c.blue },
    Float = { fg = c.bright_green },
    Identifier = { fg = c.foreground },
    Function = { fg = c.tertiary },
    Statement = { fg = c.primary },
    Operator = { fg = c.white },
    Keyword = { fg = c.primary },
    PreProc = { fg = c.secondary },
    Type = { fg = c.secondary },
    Special = { fg = c.bright_blue },
    Delimiter = { fg = c.white },
    Underlined = { fg = c.blue, underline = true },
    Error = { fg = c.red },
    Todo = { fg = c.on_tertiary_container, bg = c.tertiary_container, bold = true },

    -- Treesitter
    ["@variable"] = { fg = c.foreground },
    ["@variable.builtin"] = { fg = c.bright_magenta },
    ["@variable.parameter"] = { fg = c.bright_blue },
    ["@variable.member"] = { fg = c.bright_blue },
    ["@property"] = { fg = c.bright_blue },
    ["@constant.builtin"] = { fg = c.blue },
    ["@module"] = { fg = c.secondary, italic = true },
    ["@string.escape"] = { fg = c.yellow },
    ["@string.regexp"] = { fg = c.yellow },
    ["@function.builtin"] = { fg = c.tertiary, italic = true },
    ["@keyword.conditional"] = { fg = c.primary },
    ["@keyword.repeat"] = { fg = c.primary },
    ["@keyword.return"] = { fg = c.primary, italic = true },
    ["@keyword.exception"] = { fg = c.primary },
    ["@keyword.import"] = { fg = c.primary },
    ["@constructor"] = { fg = c.secondary },
    ["@type.builtin"] = { fg = c.secondary, italic = true },
    ["@tag"] = { fg = c.primary },
    ["@tag.attribute"] = { fg = c.bright_blue },
    ["@tag.delimiter"] = { fg = c.white },
    ["@punctuation.special"] = { fg = c.bright_magenta },
    ["@markup.heading"] = { fg = c.primary, bold = true },
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.link"] = { fg = c.tertiary, underline = true },
    ["@markup.raw"] = { fg = c.green },
    ["@markup.list"] = { fg = c.primary },

    -- Diagnostics
    DiagnosticError = { fg = c.error },
    DiagnosticWarn = { fg = c.yellow },
    DiagnosticInfo = { fg = c.secondary },
    DiagnosticHint = { fg = c.tertiary },
    DiagnosticOk = { fg = c.green },
    DiagnosticUnderlineError = { sp = c.error, undercurl = true },
    DiagnosticUnderlineWarn = { sp = c.yellow, undercurl = true },
    DiagnosticUnderlineInfo = { sp = c.secondary, undercurl = true },
    DiagnosticUnderlineHint = { sp = c.tertiary, undercurl = true },
    DiagnosticUnnecessary = { fg = c.outline },

    -- LSP
    LspReferenceText = { bg = c.surface_container_high },
    LspReferenceRead = { link = "LspReferenceText" },
    LspReferenceWrite = { bg = c.tertiary_container },
    LspInlayHint = { fg = c.outline, italic = true },
    LspSignatureActiveParameter = { fg = c.primary, bold = true },
    LspCodeLens = { fg = c.outline },

    -- Diff / git
    DiffAdd = { bg = c.surface_container, fg = c.green },
    DiffChange = { bg = c.surface_container, fg = c.yellow },
    DiffDelete = { bg = c.error_container, fg = c.on_error_container },
    DiffText = { bg = c.primary_container, fg = c.on_primary_container },
    Added = { fg = c.green },
    Changed = { fg = c.yellow },
    Removed = { fg = c.red },
    GitSignsAdd = { fg = c.green },
    GitSignsChange = { fg = c.yellow },
    GitSignsDelete = { fg = c.red },
    GitSignsCurrentLineBlame = { fg = c.outline },

    -- Plugins
    DropBarIconUISeparator = { fg = c.outline },
    TreesitterContextSeparator = { fg = c.surface_container_highest },
    SnacksDashboardHeader = { fg = c.primary },
    BufferLineNumbers = { fg = c.bright_white },
    BlinkCmpMenuBorder = { fg = c.outline, bg = "NONE" },
    BlinkCmpDocBorder = { link = "BlinkCmpMenuBorder" },
    BlinkCmpSignatureHelpBorder = { link = "BlinkCmpMenuBorder" },
    BlinkCmpMenuSelection = { fg = c.on_primary_container, bg = c.primary_container, bold = true },
    BlinkCmpLabelMatch = { fg = c.yellow, bold = true },
    BlinkCmpLabelDescription = { fg = c.outline },
    BlinkCmpLabelDetail = { fg = c.outline },
    BlinkCmpKind = { fg = c.white },
    BlinkCmpKindText = { fg = c.white },
    BlinkCmpKindMethod = { fg = c.tertiary },
    BlinkCmpKindFunction = { fg = c.tertiary },
    BlinkCmpKindConstructor = { fg = c.yellow },
    BlinkCmpKindField = { fg = c.bright_blue },
    BlinkCmpKindVariable = { fg = c.bright_magenta },
    BlinkCmpKindProperty = { fg = c.bright_blue },
    BlinkCmpKindClass = { fg = c.yellow },
    BlinkCmpKindInterface = { fg = c.yellow },
    BlinkCmpKindStruct = { fg = c.yellow },
    BlinkCmpKindModule = { fg = c.secondary },
    BlinkCmpKindUnit = { fg = c.bright_green },
    BlinkCmpKindValue = { fg = c.bright_green },
    BlinkCmpKindEnum = { fg = c.yellow },
    BlinkCmpKindEnumMember = { fg = c.blue },
    BlinkCmpKindKeyword = { fg = c.primary },
    BlinkCmpKindConstant = { fg = c.blue },
    BlinkCmpKindSnippet = { fg = c.green },
    BlinkCmpKindColor = { fg = c.red },
    BlinkCmpKindFile = { fg = c.cyan },
    BlinkCmpKindReference = { fg = c.cyan },
    BlinkCmpKindFolder = { fg = c.cyan },
    BlinkCmpKindEvent = { fg = c.red },
    BlinkCmpKindOperator = { fg = c.white },
    BlinkCmpKindTypeParameter = { fg = c.secondary },
  }
end

--- Applies the colorscheme. Returns false when there is no usable palette.
function M.apply()
  local c = M.load()
  if not c then
    return false
  end

  vim.cmd.highlight("clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd.syntax("reset")
  end
  vim.o.background = is_light(c.background) and "light" or "dark"
  vim.g.colors_name = "matugen"

  for group, spec in pairs(highlights(c)) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  local ansi = { "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white" }
  for i, name in ipairs(ansi) do
    vim.g["terminal_color_" .. (i - 1)] = c[name]
    vim.g["terminal_color_" .. (i + 7)] = c["bright_" .. name]
  end

  return true
end

local watcher

--- Reapplies the colorscheme whenever matugen rewrites the palette.
function M.watch()
  if watcher then
    return
  end

  local dir = vim.fs.dirname(M.path)
  local name = vim.fs.basename(M.path)
  local handle = vim.uv.new_fs_event()
  local timer = vim.uv.new_timer()
  if not handle or not timer then
    return
  end

  -- Watch the directory: matugen may replace the file rather than write in place.
  local ok = handle:start(dir, {}, function(err, filename)
    if err or (filename and filename ~= name) then
      return
    end
    timer:start(
      100,
      0,
      vim.schedule_wrap(function()
        if vim.g.colors_name == "matugen" and M.load() then
          vim.cmd.colorscheme("matugen")
        end
      end)
    )
  end)

  if ok then
    watcher = handle
  else
    handle:close()
    timer:close()
  end
end

return M
