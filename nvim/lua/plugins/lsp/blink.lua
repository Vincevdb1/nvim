return {
  { -- Autocompletion
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "1.*",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        -- jsregexp is needed for regex support in snippets
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        opts = {},
      },
      "folke/lazydev.nvim",
      -- used by 99's completion source
      { "saghen/blink.compat", version = "2.*" },
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = "default",
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
      },

      appearance = {
        nerd_font_variant = "normal",
      },

      completion = {
        documentation = {
          window = { border = "none" },
          auto_show = true,
          auto_show_delay_ms = 500,
        },
        list = {
          selection = {
            preselect = false,
          },
        },
      },

      sources = {
        default = { "lsp", "path", "snippets", "lazydev", "buffer" },
        providers = {
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },

      snippets = { preset = "luasnip" },

      fuzzy = { implementation = "prefer_rust_with_warning" },

      signature = { enabled = true },
    },
  },
}
