-- System-info dashboard header, adapted from
-- https://github.com/Necrom4/dotfiles/blob/master/.config/nvim/lua/modules/dashboard.lua
-- Stats come from fastfetch; computed on first render and refreshed while the dashboard is open.

local M = {}

local function sh(cmd)
  return (vim.fn.system({ "sh", "-c", cmd }):gsub("%s+$", ""))
end

local fastfetch_cmd = {
  "fastfetch", "-s", "CPUUsage:Memory:Swap:Disk:Uptime:Battery:Processes:LocalIP", "--format", "json",
}

local function parse_stats(json)
  local ok, data = pcall(vim.json.decode, json or "")
  if not ok or type(data) ~= "table" then
    return {}
  end

  local s = {}
  for _, item in ipairs(data) do
    local r = item.result
    if r and r ~= vim.NIL then
      if item.type == "CPUUsage" and #r > 0 then
        local sum = 0
        for _, v in ipairs(r) do
          sum = sum + v
        end
        s.cpu = math.floor(sum / #r + 0.5)
      elseif item.type == "Memory" then
        s.ram_used, s.ram_total = r.used, r.total
      elseif item.type == "Swap" and r[1] then
        s.swap_used, s.swap_total = r[1].used, r[1].total
      elseif item.type == "Disk" and r[1] then
        s.disk_used, s.disk_total = r[1].bytes.used, r[1].bytes.total
      elseif item.type == "Battery" and r[1] then
        s.bat = math.floor(r[1].capacity + 0.5)
        s.charging = vim.tbl_contains(r[1].status or {}, "Charging")
          or vim.tbl_contains(r[1].status or {}, "AC Connected")
      elseif item.type == "Processes" then
        s.procs = tostring(r)
      elseif item.type == "LocalIp" and r[1] then
        s.ip = (r[1].ipv4 or ""):match("([^/]+)")
      elseif item.type == "Uptime" then
        s.boot = r.bootTime:sub(1, 19):gsub("T", " ")
      end
    end
  end
  return s
end

local function fetch_stats()
  if vim.fn.executable("fastfetch") == 0 then
    return {}
  end
  return parse_stats(vim.system(fastfetch_cmd, { text = true }):wait().stdout)
end

local function graph(percent, width)
  percent = tonumber(percent) or 0
  if percent ~= percent then
    percent = 0
  end
  width = width or 20

  local start_empty, start_filled = "\u{ee00}", "\u{ee03}"
  local mid_empty, mid_filled = "\u{ee01}", "\u{ee04}"
  local end_empty, end_filled = "\u{ee02}", "\u{ee05}"

  if percent >= 100 then
    return start_filled .. mid_filled:rep(width - 2) .. end_filled
  end
  local filled = math.max(0, math.min(math.floor(percent / 100 * width), width - 1))
  if filled == 0 then
    return start_empty .. mid_empty:rep(width - 2) .. end_empty
  end
  return start_filled .. mid_filled:rep(filled - 1) .. mid_empty:rep(width - filled - 1) .. end_empty
end

local function battery_icon(capacity, charging)
  if charging then
    return "󰂄"
  end
  local icons = { "󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹" }
  return icons[math.min(math.floor(capacity / 10) + 1, #icons)]
end

local function os_version()
  local id = sh("grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '\"'"):lower()
  local name = sh("grep '^PRETTY_NAME=' /etc/os-release | cut -d'\"' -f2")
  local icons = { nixos = "\u{f313}", arch = "󰣇", ubuntu = "\u{f31b}", debian = "\u{e77d}", fedora = "\u{f30a}" }
  if vim.fn.has("mac") == 1 then
    return "\u{e711} " .. sh("sw_vers -productName") .. " " .. sh("sw_vers -productVersion")
  end
  return (icons[id] or "\u{f17c}") .. " " .. (name ~= "" and name or "Linux")
end

-- Pad by display width; string.format pads by bytes, which breaks on glyphs
local function pad(str, width, right)
  local fill = (" "):rep(math.max(0, width - vim.fn.strdisplaywidth(str)))
  return right and fill .. str or str .. fill
end

local function gb(bytes, base)
  return math.floor((tonumber(bytes) or 0) / base ^ 3 * 10) / 10
end

local logo = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]

local cache
local live_lines -- stats lines as currently shown, to find and replace them in the buffer
local timer

local os_line

local function build(s)
  os_line = os_line or os_version()
  local v = vim.version()
  local ram_used, ram_total = gb(s.ram_used, 1024), gb(s.ram_total, 1024)
  local swap_used, swap_total = gb(s.swap_used, 1000), gb(s.swap_total, 1000)
  local disk_used = math.floor((tonumber(s.disk_used) or 0) / 1000 ^ 3 + 0.5)
  local disk_total = math.floor((tonumber(s.disk_total) or 0) / 1000 ^ 3 + 0.5)
  local bat = s.bat or 0

  local function pct(used, total)
    return total > 0 and used / total * 100 or 0
  end

  local info = {
    "╭────────┬─────────────────────────────────────────╮",
    string.format("│ CPU    │ %-16s %s │", (s.cpu or 0) .. "%", "\u{f4bc} " .. graph(s.cpu)),
    string.format("│ RAM    │ %-16s %s │", ram_used .. "/" .. ram_total .. "GB", "\u{efc5} " .. graph(pct(ram_used, ram_total))),
    string.format("│ SWAP   │ %-16s %s │", swap_used .. "/" .. swap_total .. "GB", "󰯍 " .. graph(pct(swap_used, swap_total))),
    string.format("│ DISK   │ %-16s %s │", disk_used .. "/" .. disk_total .. "GB", "\u{f0a0} " .. graph(pct(disk_used, disk_total))),
    string.format(
      "│ UPTIME │ %-21s %3d%% %s %s │",
      s.boot or "?",
      bat,
      battery_icon(bat, s.charging),
      graph(bat, 10)
    ),
    string.format(
      "│ \u{eb8a}\u{eb8a}\u{eb8a}\u{eb8a}\u{eb8a}\u{eb8a} │ %s %s %s │",
      pad("\u{f007} " .. (vim.env.USER or "?") .. "@" .. vim.fn.hostname(), 16),
      pad("\u{f013} " .. (s.procs or "?"), 6, true),
      pad("󰩠 " .. (s.ip or "N/A"), 15, true)
    ),
    "╰────────┴─────────────────────────────────────────╯",
  }

  table.insert(info, os.date())
  live_lines = info
  cache = logo
    .. "\n\n"
    .. os_line
    .. " | \u{e6ae} "
    .. v.major .. "." .. v.minor .. "." .. v.patch
    .. "\n"
    .. table.concat(info, "\n")
end

local function dashboard_buf()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "snacks_dashboard" then
      return buf
    end
  end
end

-- Swap the old stats lines for fresh ones in place; set_text keeps extmarks (highlights) aligned
local function refresh(buf, old, new)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  vim.bo[buf].modifiable = true
  for i, line in ipairs(old) do
    if line ~= new[i] then
      for row, text in ipairs(lines) do
        local col = text:find(line, 1, true)
        if col then
          vim.api.nvim_buf_set_text(buf, row - 1, col - 1, row - 1, col - 1 + #line, { new[i] })
          break
        end
      end
    end
  end
  vim.bo[buf].modifiable = false
end

-- Refetch stats every second while a dashboard is visible
local function start_live()
  if timer or vim.fn.executable("fastfetch") == 0 then
    return
  end
  timer = vim.uv.new_timer()
  local busy = false
  timer:start(1000, 1000, vim.schedule_wrap(function()
    if not dashboard_buf() then
      timer:stop()
      timer:close()
      timer, cache = nil, nil
      return
    end
    if busy then
      return
    end
    busy = true
    vim.system(fastfetch_cmd, { text = true }, vim.schedule_wrap(function(out)
      busy = false
      local buf = dashboard_buf()
      if not buf or out.code ~= 0 then
        return
      end
      local old = live_lines
      build(parse_stats(out.stdout))
      refresh(buf, old, live_lines)
    end))
  end))
end

function M.header()
  if not cache then
    build(fetch_stats())
  end
  vim.schedule(start_live)
  return cache
end

return M
