return {
  {
    "nvim-mini/mini.animate",
    enabled = true,
    event = "VeryLazy",
    opts = function()
      -- don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "grug-far",
        callback = function()
          vim.b.minianimate_disable = true
        end,
      })

      local animate = require("mini.animate")
      return {
        resize = {
          enable = false,
          timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
        },
        scroll = {
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
          subscroll = animate.gen_subscroll.equal({
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          }),
        },
      }
    end,
  },
  {
    "sphamba/smear-cursor.nvim",
    enabled = os.getenv("TERM_PROGRAM") ~= "ghostty",
    opts = {},
  },
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    priority = 10,
    config = function()
      require("tiny-glimmer").setup({
        enabled = true,
        overwrite = {
          auto_map = true,

          yank = {
            enabled = true,
            default_animation = "fade",
          },

          search = {
            enabled = true,
            default_animation = "pulse",
            next_mapping = "n",
            prev_mapping = "N",
          },

          paste = {
            enabled = true,
            default_animation = "reverse_fade",
            paste_mapping = "p",
            Paste_mapping = "P",
          },

          undo = {
            enabled = true,
            default_animation = {
              name = "fade",
              settings = {
                from_color = "DiffDelete",
                max_duration = 500,
                min_duration = 500,
              },
            },
            undo_mapping = "u",
          },

          redo = {
            enabled = true,
            default_animation = {
              name = "fade",
              settings = {
                from_color = "DiffAdd",
                max_duration = 500,
                min_duration = 500,
              },
            },
            redo_mapping = "<c-r>",
          },
        },
      })
    end,
  },
}
