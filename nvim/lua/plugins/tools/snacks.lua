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
          header = [[                                                                       
                                                                     
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ 
	                                                                       ]],
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Sessions", action = "<cmd>AutoSession search<CR>" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
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
      notifier = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = false },
    })

    vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#569CD6" })

    -- Keymaps
    local wk = require("which-key")

    vim.keymap.set("n", "<leader>e", function()
      Snacks.explorer()
    end, { desc = "Toggle Explorer" })

    -- Picker keymaps Neovim
    wk.add({
      { "<leader>f", group = "File/Find" },
    })
    vim.keymap.set("n", "<leader>ff", function()
      Snacks.picker.files()
    end, { desc = "Find Files" })
    vim.keymap.set("n", "<leader>fr", function()
      Snacks.picker.grep()
    end, { desc = "Find Recursive" })
    vim.keymap.set("n", "<leader>fg", function()
      Snacks.picker.git_files()
 Snacks.toggle.dim():map("<leader>uD")   end, { desc = "Find Git" })
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
    Snacks.toggle.option("spell", { name = "Toggle Spelling" }):map("<leader>uS")
    Snacks.toggle.option("relativenumber", { name = "Toggle Relative Number" }):map("<leader>uL")
    Snacks.toggle.diagnostics():map("<leader>ud")
    Snacks.toggle.treesitter():map("<leader>uT")
    Snacks.toggle.inlay_hints():map("<leader>uh")
    Snacks.toggle.dim():map("<leader>uD")
  end,
}
