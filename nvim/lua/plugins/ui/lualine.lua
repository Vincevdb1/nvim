return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local has_lualine, lualine = pcall(require, "lualine")
    if not has_lualine then
      return
    end

    local has_neopywal, neopywal_lualine = pcall(require, "neopywal.theme.plugins.lualine")
    if has_neopywal then
      neopywal_lualine.setup()
    end

    local mode = {
      "mode",
      fmt = function(str)
        -- return ' ' .. str:sub(1, 1) -- displays only the first character of the mode
        return " " .. str
      end,
    }

    local filename = {
      "filename",
      file_status = true, -- displays file status (readonly status, modified status)
      path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
      
    }

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 100
    end

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn", "info", "hint" },
      symbols = {
        error = " ",
        warn = " ",
        info = " ",
        hint = " ",
      },
      colored = true,
      -- WARN: Doesn't work
      -- diagnostics_color = {
      --   error = '#F7768E',
      --   warn  = '#E0AF68',
      --   info  = '#7AA2F7',
      -- },
      update_in_insert = false,
      always_visible = false,
    }

    local diff = {
      "diff",
      colored = true,
      symbols = {
        added = " ",
        modified = " ",
        removed = " ",
      },
      cond = hide_in_width,
    }

    local formatter = {
      "formatter",
      fmt = function()
        if vim.g.disable_autoformat then
          return "󰉥"
        else
          return "󰗴"
        end
      end,
      cond = hide_in_width,
      color = function()
        if vim.g.disable_autoformat then
          return { fg = "#FF5555" }
        end
      end,
    }

    local codeium = {
      "codeium",
      fmt = (function()
        local dots = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        local i = 1
        local timer = vim.loop.new_timer()

        timer:start(
          0,
          100,
          vim.schedule_wrap(function()
            require("lualine").refresh({ place = { "statusline" } })
          end)
        )

        vim.api.nvim_create_autocmd("VimLeavePre", {
          callback = function()
            if timer:is_active() then
              timer:stop()
              timer:close()
            end
          end,
        })

        return function()
          local status = require("codeium.virtual_text").status()

          if not vim.g.codeium_status then
            return "󰬊 "
          elseif status.state == "idle" then
            return "󰒲 "
          elseif status.state == "waiting" then
            i = (i % #dots) + 1
            return dots[i]
          elseif status.state == "completions" and status.total > 0 then
            return string.format(" %d/%d", status.current, status.total)
          end

          return status.state
        end
      end)(),
      color = function()
        local status = require("codeium.virtual_text").status()

        if not vim.g.codeium_status then
          return { fg = "#FF5555" }
        elseif status.state == "idle" then
          return { fg = "#AEB7D0" }
        elseif status.state == "waiting" then
          return { fg = "#AEB7D0" }
        elseif status.state == "completions" and status.total > 0 then
          return { fg = "#699854" }
        end

        return { fg = "#AEB7D0" }
      end,
    }

    local supermaven = {
      function()
        return " "
      end,
      color = function()
        if not vim.g.supermaven_status then
          return { fg = "#FF5555" }
        end
        local ok, api = pcall(require, "supermaven-nvim.api")
        if ok and api.is_running() then
          return { fg = "#699854" }
        end
        return { fg = "#AEB7D0" }
      end,
    }

    require("lualine").setup({
      options = {
        theme = function()
          local current_theme = vim.g.colors_name

          if current_theme == "neopywal-dark" then
            return "neopywal"
          elseif current_theme == "vscode" then
            return "vscode"
          else
            return "auto"
          end
        end,
        icons_enabled = true,
        -- Some useful glyphs:
        -- https://www.nerdfonts.com/cheat-sheet
        --        
        section_separators = {
          left = "",
          right = "",
        },
        component_separators = {
          left = "",
          right = "",
        },
        disabled_filetypes = { "snacks_dashboard", "atone" },
        always_divide_middle = true,
      },
      -- winbar = {
      --   lualine_c = {
      --     {
      --     },
      --   },
      -- },
      sections = {
        lualine_a = { mode },
        lualine_b = {
          {
            "branch",
            icon = "",
            color = { fg = "#FFA500", bg = "None" },
          },
        },
        lualine_c = {
          diff,
          diagnostics,
          {
            function()
              return require("screenkey").get_keys()
            end,
            color = { fg = "#5A5A5A" },
            cond = hide_in_width,
          },
        },
        lualine_x = {
          {
            "lsp_status",
            icon = " ",
            symbols = {
              spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
              done = "✔ ",
              separator = " ",
            },
            ignore_lsp = {
              "copilot",
            },
            color = { fg = "#5A5A5A" },
            cond = hide_in_width,
          },
          formatter,
          {
            "copilot",
            symbols = {
              status = {
                icons = {
                  unknown = " ",
                },
              },
            },
            show_colors = true,
          },
          codeium,
          supermaven,
          {
            "encoding",
            cond = hide_in_width,
          },
          {
            "filetype",
            cond = hide_in_width,
          },
        },
        lualine_y = { 
          {
            "location",
          }
        },
        lualine_z = { "progress" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { {
          "filename",
          path = 1,
        } },
        lualine_x = { {
          "location",
          padding = 0,
        } },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { "fugitive" },
    })
  end,
}
