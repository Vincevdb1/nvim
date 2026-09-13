 return {
  "akinsho/bufferline.nvim",
  dependencies = { "moll/vim-bbye", "nvim-tree/nvim-web-devicons" },
  config = function()
    -- vim.opt.linespace = 8

    require("bufferline").setup({
      options = {
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
        numbers = "ordinal", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
        -- buffer_close_icon = '󰅖',
        buffer_close_icon = "󰅙",
        -- buffer_close_icon = "✗",
        -- buffer_close_icon = '✕',
        close_icon = "",
        path_components = 1, -- Show only the file name without the directory
        modified_icon = "●",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 30,
        max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
        tab_size = 21,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          -- Show error or warning icon only (if error don't show warning)
          -- Give icons colors
          local s = " "
          if diagnostics_dict.error then
            s = " "
          elseif diagnostics_dict.warning then
            s = " "
          elseif diagnostics_dict.info then
            s = " "
          end
          return s
        end,
        diagnostics_update_in_insert = false,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        separator_style = { "│", "│" }, -- | "thick" | "thin" | { 'any', 'any' },
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        show_tab_indicators = false,
        indicator = {
          -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
          style = "none", -- Options: 'icon', 'underline', 'none'
        },
        icon_pinned = "󰐃",
        minimum_padding = 1,
        maximum_padding = 5,
        maximum_length = 15,
        sort_by = "insert_at_end",
      },
      highlights = {
        separator = {
          fg = "#434C5E",
        },
        buffer_selected = {
          bold = true,
          italic = true,
        },
        -- separator_selected = {},
        -- tab_selected = {},
        background = {
          bg = "None",
          fg = "None",
        },
        -- info_diagnostics = {
        --   bg = "#569CD6",
        -- },
        -- warning_diagnostics = {
        --   bg = "#DCDCAA",
        -- },
        -- error_diagnostics = {
        --   bg = "#F44747",
        -- },
        -- indicator_selected = {
        --
        -- },
        -- close_button_selected = {
        --   fg = "#F7768E",
        --   bg = "None",
        -- },
      },
    })

    local wk = require("which-key")
    wk.add({
      { "<leader>b", group = "Buffer" },
    })

    -- Keymaps
    local opts = {
      noremap = true,
      silent = true,
      desc = "Go to Buffer",
    }
    -- vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", {})
    -- vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", {})
    vim.keymap.set("n", "<leader>bd", "<cmd>lua require('bufferline').close_others()<CR>", {
      desc = "Buffer Close Other",
    })
    vim.keymap.set("n", "<leader>&", "<cmd>lua require('bufferline').go_to_buffer(1)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", "<leader>é", "<cmd>lua require('bufferline').go_to_buffer(2)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", '<leader>"', "<cmd>lua require('bufferline').go_to_buffer(3)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", "<leader>'", "<cmd>lua require('bufferline').go_to_buffer(4)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", "<leader>(", "<cmd>lua require('bufferline').go_to_buffer(5)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", "<leader>§", "<cmd>lua require('bufferline').go_to_buffer(6)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", "<leader>è", "<cmd>lua require('bufferline').go_to_buffer(7)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", "<leader>!", "<cmd>lua require('bufferline').go_to_buffer(8)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", "<leader>ç", "<cmd>lua require('bufferline').go_to_buffer(9)<CR>", {
      desc = "which_key_ignore",
    }, opts)

    vim.keymap.set("n", "<leader>1", "<cmd>lua require('bufferline').go_to_buffer(1)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", "<leader>2", "<cmd>lua require('bufferline').go_to_buffer(2)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", "<leader>3", "<cmd>lua require('bufferline').go_to_buffer(3)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", "<leader>4", "<cmd>lua require('bufferline').go_to_buffer(4)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", "<leader>5", "<cmd>lua require('bufferline').go_to_buffer(5)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", "<leader>6", "<cmd>lua require('bufferline').go_to_buffer(6)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", "<leader>7", "<cmd>lua require('bufferline').go_to_buffer(7)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", "<leader>8", "<cmd>lua require('bufferline').go_to_buffer(8)<CR>", {
      desc = "which_key_ignore",
    }, opts)
    vim.keymap.set("n", "<leader>9", "<cmd>lua require('bufferline').go_to_buffer(9)<CR>", {
      desc = "which_key_ignore",
    }, opts)
  end,
}
