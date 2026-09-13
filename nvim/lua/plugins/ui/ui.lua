return {
    {
      "rcarriga/nvim-notify",
      config = function()
        require("notify").setup({
          stages = "fade_in_slide_out",
          timeout = 5000,
          top_down = false,
          max_height = function()
            return math.floor(vim.o.lines * 0.50)
          end,
          max_width = function()
            return math.floor(vim.o.columns * 0.50)
          end,
          on_open = function(win)
            vim.api.nvim_win_set_config(win, { zindex = 100 })
          end,
        background_colour = "#000000",
        })
      end,
    },
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      opts = {
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            -- ["cmp.entry.get_documentation"] = true,
          },
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              any = {
                { find = "%d+L, %d+B" },
                { find = "; after #%d+" },
                { find = "; before #%d+" },
              },
            },
            view = "mini",
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
        },
      },
      -- stylua: ignore
      keys = {
        { "<leader>un", "", desc = "Notifications Menu"},
        { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
        { "<leader>unl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
        { "<leader>unh", function() require("noice").cmd("history") end, desc = "Noice History" },
        { "<leader>una", function() require("noice").cmd("all") end, desc = "Noice All" },
        { "<leader>und", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
        { "<leader>unf", function() require("noice").cmd("pick") end, desc = "Noice Picker" },
        { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
        { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
      },
      config = function(_, opts)
        -- HACK: noice shows messages from before it was enabled,
        -- but this is not ideal when Lazy is installing plugins,
        -- so clear the messages in this case.
        if vim.o.filetype == "lazy" then
          vim.cmd([[messages clear]])
        end
        require("noice").setup(opts)
      end,
    },
    {
      "folke/todo-comments.nvim",
      cmd = { "TodoTrouble", "TodoTelescope" },
      event = { "BufReadPost", "BufWritePost", "BufNewFile" },
      opts = {},
      -- stylua: ignore
      keys = {
        { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
        { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
        { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
        { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      },
    },
}
