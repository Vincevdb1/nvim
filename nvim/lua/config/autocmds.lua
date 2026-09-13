vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

-- highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern = "*",
  desc = "highlight selection on yank",
  callback = function()
    vim.highlight.on_yank({ timeout = 200, visual = true })
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

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
  group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
  pattern = { ".env", ".env.*" },
  callback = function()
    vim.bo.filetype = "dosini"
  end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMoved", {
  group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
  desc = "Highlight references under cursor",
  callback = function()
    -- Only run if the cursor is not in insert mode
    if vim.fn.mode() ~= "i" then
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      local supports_highlight = false
      for _, client in ipairs(clients) do
        if client.server_capabilities.documentHighlightProvider then
          supports_highlight = true
          break -- Found a supporting client, no need to check others
        end
      end

      -- 3. Proceed only if an LSP is active AND supports the feature
      if supports_highlight then
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
      end
    end
  end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMovedI", {
  group = "LspReferenceHighlight",
  desc = "Clear highlights when entering insert mode",
  callback = function()
    vim.lsp.buf.clear_references()
  end,
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

-- Appearance of diagnostics
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    -- Add a custom format function to show error codes
    format = function(diagnostic)
      local code = diagnostic.code and string.format("[%s]", diagnostic.code) or ""
      return string.format("%s %s", code, diagnostic.message)
    end,
  },
  underline = false,
  update_in_insert = true,
  float = {
    source = "always", -- Or "if_many"
  },
  -- Make diagnostic background transparent
  on_ready = function()
    vim.cmd("highlight DiagnosticVirtualText guibg=NONE")
  end,
})

-- Disable spell checking for certain buffers by filetype or buffer name
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("SpellCheckIgnoreLazy", { clear = true }),
  pattern = { "lazy", "lazyvim", "noice" },
  callback = function()
    vim.opt_local.spell = false
  end,
})
