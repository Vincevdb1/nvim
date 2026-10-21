-- Mermaid preview in a vertical split, rendered with mmdc and shown with snacks.image.
-- Every render writes a new png, because snacks caches converted images by path.
local M = {}

local cache = vim.fn.stdpath("cache") .. "/mermaid-preview"
local previews = {} ---@type table<number, {win: number, buf?: number, png?: string, seq: number}>

local function set_preview_buf(p, buf)
  local old = p.buf
  vim.api.nvim_win_set_buf(p.win, buf)
  p.buf = buf
  if old and vim.api.nvim_buf_is_valid(old) then
    vim.api.nvim_buf_delete(old, { force = true })
  end
end

-- Show the error in the preview pane; the next successful save replaces it with the diagram
local function show_error(p, msg)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  local lines = { "# Mermaid render failed", "", "```" }
  vim.list_extend(lines, vim.split(msg ~= "" and msg or "unknown error", "\n"))
  table.insert(lines, "```")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
  set_preview_buf(p, buf)
  vim.wo[p.win].wrap = true
end

local function render(src_buf)
  local p = previews[src_buf]
  if not p then
    return
  end
  if vim.fn.executable("mmdc") == 0 then
    return show_error(p, "`mmdc` not found, install mermaid-cli")
  end
  p.seq = p.seq + 1
  local seq = p.seq
  vim.fn.mkdir(cache, "p")
  local png = ("%s/%d-%d.png"):format(cache, src_buf, vim.uv.hrtime())
  local theme = vim.o.background == "light" and "neutral" or "dark"
  local cmd = { "mmdc", "-i", vim.api.nvim_buf_get_name(src_buf), "-o", png, "-b", "transparent", "-t", theme, "-s", "2" }

  vim.system(cmd, { text = true }, vim.schedule_wrap(function(res)
    p = previews[src_buf]
    -- Drop results of closed previews and of renders that were superseded
    if not p or p.seq ~= seq or not vim.api.nvim_win_is_valid(p.win) then
      os.remove(png)
      return
    end
    if res.code ~= 0 then
      os.remove(png)
      return show_error(p, vim.trim((res.stderr or "") .. "\n" .. (res.stdout or "")))
    end
    local old_png = p.png
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"
    set_preview_buf(p, buf)
    Snacks.image.buf.attach(buf, { src = png })
    p.png = png
    if old_png then
      os.remove(old_png)
    end
  end))
end

local function close(src_buf, win)
  local p = previews[src_buf]
  if not p or (win and p.win ~= win) then
    return
  end
  previews[src_buf] = nil
  if vim.api.nvim_win_is_valid(p.win) then
    vim.api.nvim_win_close(p.win, true)
  end
  if p.png then
    os.remove(p.png)
  end
end

function M.toggle(src_buf)
  src_buf = src_buf or vim.api.nvim_get_current_buf()
  local p = previews[src_buf]
  if p and vim.api.nvim_win_is_valid(p.win) then
    return close(src_buf)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Rendering..." })
  local win = vim.api.nvim_open_win(buf, false, { split = "right", win = vim.api.nvim_get_current_win() })
  previews[src_buf] = { win = win, buf = buf, seq = 0 }

  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win),
    once = true,
    callback = function()
      vim.schedule(function()
        close(src_buf, win)
      end)
    end,
  })
  render(src_buf)
end

function M.attach(src_buf)
  local group = vim.api.nvim_create_augroup("mermaid_preview_" .. src_buf, { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    buffer = src_buf,
    callback = function()
      render(src_buf)
    end,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    buffer = src_buf,
    callback = function()
      close(src_buf)
    end,
  })
  vim.keymap.set("n", "<leader>tm", function()
    M.toggle(src_buf)
  end, { buffer = src_buf, desc = "Toggle Mermaid Preview" })
end

return M
