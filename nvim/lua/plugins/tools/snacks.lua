return {
  "folke/snacks.nvim",
  -- INFO: Fixed tag because of certain devicons not being displayed
  tag = "v2.23.0",
  priority = 1000,
  lazy = false,
  config = function()
    require("snacks").setup({
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = "\u{f4a5} ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = "󰥨 ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = "󰈞 ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = "\u{f1da} ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = "\u{f423} ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.g.nvim_config_dir})",
            },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = "\u{e348} ", key = "s", desc = "Restore Session", action = ":lua require('persistence').select()" },
            { icon = "\u{f426} ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          function()
            return { header = require("scripts.dashboard").header(), padding = 1, pane = 1 }
          end,
          { pane = 1, section = "startup" },
          { pane = 2, section = "keys", padding = 1 },
          { pane = 2, icon = "\u{f0c5} ", title = "RECENT FILES", section = "recent_files", indent = 2, padding = 1 },
          function()
            local root = Snacks.git.get_root()
            if not root then
              return nil
            end
            local branch = vim.fn.trim(vim.fn.system({ "git", "-C", root, "branch", "--show-current" }))
            return {
              pane = 2,
              icon = "\u{e725} ",
              title = "GIT STATUS" .. (branch ~= "" and (" [" .. branch .. "]") or ""),
              section = "terminal",
              cmd = "git --no-pager diff --stat -B -M -C && git status --short --renames",
              height = 5,
              padding = 1,
              ttl = 5 * 60,
              indent = 2,
            }
          end,
        },
      },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      toggle = { enabled = true },
      dim = { enabled = true },
      picker = {
        enabled = true,
        layout = "telescope",
        sources = {
          explorer = {
            layout = {
              auto_hide = { "input" },
            },
            hidden = true,
            ignored = true
          },
          files = {
            hidden = true,
            matcher = {
              cwd_bonus = true,
              frecency = true,
              sort_empty = true
            },
          },
          buffers = {
            layout = "vscode"
          },
          help = {
            layout = {
              preset = "ivy_split"
            }
          },
          todo_comments = {
            layout = "ivy"
          },
          highlights = {
            layout = "vertical"
          }
        },
      },
      gh = { enabled = true },
      lazygit = { enabled = true },
      notifier = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        lazygit = { border = "rounded" },
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>e", function()
      Snacks.explorer()
    end, { desc = "Explorer" })

    -- Picker keymaps Neovim
    vim.keymap.set("n", "<leader>ff", function()
      Snacks.picker.files()
    end, { desc = "Find Files" })
    vim.keymap.set("n", "<leader>fr", function()
      Snacks.picker.grep()
    end, { desc = "Find Recursive" })
    vim.keymap.set("n", "<leader>fg", function()
      Snacks.picker.git_files()
    end, { desc = "Find Git" })
    vim.keymap.set("n", "<leader>fb", function()
      Snacks.picker.buffers()
    end, { desc = "Find Buffer" })
    vim.keymap.set("n", "<leader>fh", function()
      Snacks.picker.help()
    end, { desc = "Find Help" })
    vim.keymap.set("n", "<leader>fc", function()
      Snacks.picker.command_history()
    end, { desc = "Find Command" })
    vim.keymap.set("n", "<leader>ft", function()
      Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
    end, { desc = "Find TODO" })
    vim.keymap.set("n", "<leader>fH", function()
      Snacks.picker.highlights()
    end, { desc = "Find highlights" })

    -- Git
    vim.keymap.set("n", "<leader>gl", function()
      Snacks.lazygit()
    end, { desc = "LazyGit" })

    -- Github
    vim.keymap.set("n", "<leader>gi", function()
      Snacks.picker.gh_issue()
    end, { desc = "GitHub Issues (open)" })
    vim.keymap.set("n", "<leader>gI", function()
      Snacks.picker.gh_issue({ state = "all" })
    end, { desc = "GitHub Issues (all)" })
    vim.keymap.set("n", "<leader>gp", function()
      Snacks.picker.gh_pr()
    end, { desc = "GitHub Pull Requests (open)" })
    vim.keymap.set("n", "<leader>gP", function()
      Snacks.picker.gh_pr({ state = "all" })
    end, { desc = "GitHub Pull Requests (all)" })

    -- Scratch
    vim.keymap.set("n", "<leader>tp", function()
      Snacks.scratch()
    end, { desc = "Scratch Pad" })

    -- Toggles
    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>uS")
    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
    Snacks.toggle.option("wrap", { name = "Code Wrap" }):map("<leader>cw")
    Snacks.toggle.diagnostics():map("<leader>ud")
    Snacks.toggle.treesitter():map("<leader>uT")
    Snacks.toggle.inlay_hints():map("<leader>uh")
    Snacks.toggle.dim():map("<leader>uD")

    -- Plugin toggles: getters check package.loaded so rendering which-key doesn't load lazy plugins
    Snacks.toggle.new({
      name = "Auto Format",
      get = function() return not vim.g.disable_autoformat end,
      set = function(state) vim.g.disable_autoformat = not state end,
    }):map("<leader>uf")
    Snacks.toggle.new({
      name = "Session Autosave",
      get = function() return package.loaded["persistence"] ~= nil and require("persistence").active() end,
      set = function(state) require("persistence")[state and "start" or "stop"]() end,
    }):map("<leader>us")
    Snacks.toggle.new({
      name = "Cloak",
      get = function() return package.loaded["cloak"] ~= nil and require("cloak").opts.enabled end,
      set = function(state) require("cloak")[state and "enable" or "disable"]() end,
    }):map("<leader>uc")
    Snacks.toggle.new({
      name = "Lensline",
      get = function() return package.loaded["lensline.config"] ~= nil and require("lensline.config").is_visible() end,
      set = function(state) require("lensline.commands")[state and "show" or "hide"]() end,
    }):map("<leader>ul")
    Snacks.toggle.new({
      name = "Screenkey Statusline",
      get = function() return package.loaded["screenkey"] ~= nil and require("screenkey").statusline_component_is_active() end,
      set = function(state)
        local screenkey = require("screenkey")
        if screenkey.statusline_component_is_active() ~= state then
          screenkey.toggle_statusline_component()
        end
      end,
    }):map("<leader>uk")
    Snacks.toggle.new({
      name = "Brainrot",
      get = function() return vim.g.brainrot_enabled == true end,
      set = function(state)
        vim.g.brainrot_enabled = state
        require("brainrot").setup(state and {
          phonk_time = 2.5,
          disable_phonk = false,
          sound_enabled = true,
          image_enabled = true,
          volume = 50,
        } or {
          disable_phonk = true,
          sound_enabled = false,
          image_enabled = false,
        })
      end,
    }):map("<leader>ub")
    Snacks.toggle.new({
      name = "Copilot",
      get = function() return package.loaded["copilot.client"] ~= nil and require("copilot.client").buf_is_attached(0) == true end,
      set = function(state) vim.cmd("Copilot " .. (state and "attach" or "detach")) end,
    }):map("<leader>ap")
    Snacks.toggle.new({
      name = "Claude Autocomplete",
      -- The auto lane starts enabled (opts.auto.enabled) once the plugin loads on InsertEnter
      get = function() return package.loaded["claude-complete.auto"] == nil or require("claude-complete.auto").is_enabled() end,
      set = function(state)
        require("claude-complete")
        vim.cmd("ClaudeCompleteAuto " .. (state and "on" or "off"))
      end,
    }):map("<leader>ac")
  end,
}
