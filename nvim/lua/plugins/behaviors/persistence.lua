-- Directories that never get a session, like auto-session's suppressed_dirs
local suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" }

local function is_suppressed()
  local cwd = vim.fs.normalize(vim.fn.getcwd())
  for _, dir in ipairs(suppressed_dirs) do
    if cwd == vim.fs.normalize(vim.fn.expand(dir)) then
      return true
    end
  end
  return false
end

return {
  "folke/persistence.nvim",
  lazy = false,
  keys = {
    {
      "<leader>fs",
      function()
        local persistence = require("persistence")
        -- Save the current session before switching to another one
        local has_files = vim.iter(vim.api.nvim_list_bufs()):any(function(buf)
          return vim.bo[buf].buflisted and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= ""
        end)
        if persistence.active() and has_files then
          persistence.save()
        end
        persistence.select()
      end,
      desc = "Find Session",
    },
  },
  opts = {
    -- One session per directory, not per git branch
    branch = false,
  },
  config = function(_, opts)
    vim.opt.sessionoptions:remove("blank")

    local persistence = require("persistence")
    persistence.setup(opts)

    local group = vim.api.nvim_create_augroup("config.persistence", { clear = true })

    local function update_active()
      if is_suppressed() then
        persistence.stop()
      else
        persistence.start()
      end
    end
    update_active()
    vim.api.nvim_create_autocmd("DirChanged", { group = group, callback = update_active })

    -- Close the buffers of the previous session before loading another one
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "PersistenceLoadPre",
      callback = function()
        vim.cmd("silent! %bwipeout")
      end,
    })

    local started_with_stdin = false
    vim.api.nvim_create_autocmd("StdinReadPre", {
      group = group,
      once = true,
      callback = function()
        started_with_stdin = true
      end,
    })

    -- Restore the session of the cwd when started without arguments
    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      once = true,
      nested = true,
      callback = function()
        if vim.fn.argc(-1) == 0 and not started_with_stdin and not is_suppressed() then
          persistence.load()
        end
      end,
    })
  end,
}
