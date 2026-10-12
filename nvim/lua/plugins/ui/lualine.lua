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

    -- Flag the instance started from this repo's `nix develop` shell, which
    -- reads its config live from ./nvim instead of the nix store copy.
    local dev_mode = {
      function()
        return " [DEVELOPING]"
      end,
      cond = function()
        return vim.g.is_dev_shell
      end,
      color = { fg = "#FF5555" },
    }

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

    local function claude_state()
      local auto = package.loaded["claude-complete.auto"]
      local worker = package.loaded["claude-complete.worker"]
      if not auto or not worker then
        return "asleep"
      elseif not auto.is_enabled() then
        return "off"
      end

      local status = worker.status()
      if status.disabled then
        return "error"
      elseif worker._internal.state.inflight then
        return "waiting"
      elseif not status.running or not status.last_latency_ms then
        return "asleep"
      end

      return "ready"
    end

    local claude = {
      (function()
        local dots = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        local icons = { off = "󰚩 ", error = "󰚩 ", asleep = "󰚩 ", ready = "󰚩 " }
        local i = 1
        local was_waiting = false
        local timer = vim.uv.new_timer()

        timer:start(
          0,
          100,
          vim.schedule_wrap(function()
            local waiting = claude_state() == "waiting"
            if waiting or was_waiting then
              require("lualine").refresh({ place = { "statusline" } })
            end
            was_waiting = waiting
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
          local state = claude_state()
          if state == "waiting" then
            i = (i % #dots) + 1
            return dots[i] .. " "
          end

          return icons[state]
        end
      end)(),
      color = function()
        local state = claude_state()
        if state == "off" or state == "error" then
          return { fg = "#FF5555" }
        elseif state == "ready" then
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
          elseif current_theme == "matugen" then
            return "matugen"
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
          dev_mode,
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
          claude,
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
