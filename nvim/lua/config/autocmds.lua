vim.hl.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

-- highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern = "*",
  desc = "highlight selection on yank",
  callback = function()
    vim.hl.on_yank({ timeout = 200, visual = true })
  end,
})

-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      -- defer centering slightly so it's applied after render
      vim.schedule(function()
        vim.cmd("normal! zz")
      end)
    end
  end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  command = "wincmd L",
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("no_auto_comment", {}),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
})

-- Delete empty buffers on BufReadPost
-- vim.api.nvim_create_autocmd("BufReadPost", {
--   callback = function()
--     for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
--       if vim.api.nvim_buf_get_name(bufnr) == "" and vim.api.nvim_buf_is_loaded(bufnr) then
--         vim.cmd("bdelete " .. bufnr)
--       end
--     end
--   end,
-- })

-- Open certain extensions in correct app instead of in Neovim (with xdg-open)
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "*.pdf", "*.mp4", "*.mp3", "*.jpg", "*.png", "*.gif" },
  callback = function()
    local filepath = vim.fn.expand("%:p")
    -- Use silent !xdg-open to open file externally in background
    vim.cmd("silent !xdg-open " .. vim.fn.shellescape(filepath) .. " &")
    -- Close the buffer that tried to open the file
    vim.cmd("bdelete!")
    -- Notify User that file has been opened externally
    vim.notify("Opened file in external application: " .. filepath, vim.log.levels.INFO)
  end,
})

if vim.g.is_dev_shell then
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    callback = function()
      vim.schedule(function()
        vim.notify("Config developer mode", vim.log.levels.WARN)
      end)
    end,
  })
end

-- Disable spell checking for certain buffers by filetype or buffer name
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SpellCheckIgnoreLazy", { clear = true }),
  pattern = { "lazy", "noice" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- diagnostic virtual text: same color as the severity, on a darker tint of it
local function tint_diagnostic_virtual_text()
  local function blend(fg, bg, alpha)
    local function ch(c, s) return bit.band(bit.rshift(c, s), 0xff) end
    local function mix(s) return math.floor(ch(fg, s) * alpha + ch(bg, s) * (1 - alpha) + 0.5) end
    return string.format("#%02x%02x%02x", mix(16), mix(8), mix(0))
  end
  local base = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg or 0x000000
  for _, sev in ipairs({ "Error", "Warn", "Info", "Hint", "Ok" }) do
    local fg = vim.api.nvim_get_hl(0, { name = "Diagnostic" .. sev, link = false }).fg
    if fg then
      vim.api.nvim_set_hl(0, "DiagnosticVirtualText" .. sev, { fg = fg, bg = blend(fg, base, 0.15) })
    end
  end
end
tint_diagnostic_virtual_text()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("diagnostic_virtual_text_tint", { clear = true }),
  callback = tint_diagnostic_virtual_text,
})
