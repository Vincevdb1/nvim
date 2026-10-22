return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})

      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
          require("nvim-treesitter.parsers").templ = {
            install_info = {
              url = "https://github.com/vrischmann/tree-sitter-templ",
              branch = "master",
            },
          }
        end,
      })

      vim.treesitter.language.register("templ", "templ")
      vim.treesitter.language.register("xml", "xaml")

      local available = nil

      local function start(buf, lang)
        if not pcall(vim.treesitter.start, buf, lang) then
          return
        end
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        -- Regex highlighting alongside treesitter
        if lang == "markdown" then
          vim.bo[buf].syntax = "on"
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then
            return
          end

          if vim.treesitter.language.add(lang) then
            start(buf, lang)
            return
          end

          -- Automatically install missing parsers
          available = available or require("nvim-treesitter").get_available()
          if vim.tbl_contains(available, lang) then
            require("nvim-treesitter").install(lang):await(function()
              if vim.api.nvim_buf_is_valid(buf) then
                start(buf, lang)
              end
            end)
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    config = function()
      require("treesitter-context").setup({
        enable = true,
        separator = "-"
      })

      vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { fg = "#222222" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        move = {
          set_jumps = true,
        },
      })

      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
      end, { desc = "prev function" })

      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
      end, { desc = "next function" })

      vim.keymap.set({ "n", "x", "o" }, "[F", function()
        require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
      end, { desc = "prev function end" })

      vim.keymap.set({ "n", "x", "o" }, "]F", function()
        require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
      end, { desc = "next function end" })

      -- Movement between parameters
      vim.keymap.set({ "n", "x", "o" }, "[a", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.outer", "textobjects")
      end, { desc = "prev argument" })

      vim.keymap.set({ "n", "x", "o" }, "]a", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.outer", "textobjects")
      end, { desc = "next argument" })

      vim.keymap.set({ "n", "x", "o" }, "[A", function()
        require("nvim-treesitter-textobjects.move").goto_previous_end("@parameter.outer", "textobjects")
      end, { desc = "prev argument end" })

      vim.keymap.set({ "n", "x", "o" }, "]A", function()
        require("nvim-treesitter-textobjects.move").goto_next_end("@parameter.outer", "textobjects")
      end, { desc = "next argument end" })

      -- Movement between blocks
      vim.keymap.set({ "n", "x", "o" }, "[s", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@block.outer", "textobjects")
      end, { desc = "prev block" })

      vim.keymap.set({ "n", "x", "o" }, "]s", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@block.outer", "textobjects")
      end, { desc = "next block" })

      vim.keymap.set({ "n", "x", "o" }, "[S", function()
        require("nvim-treesitter-textobjects.move").goto_previous_end("@block.outer", "textobjects")
      end, { desc = "prev block end" })

      vim.keymap.set({ "n", "x", "o" }, "]S", function()
        require("nvim-treesitter-textobjects.move").goto_next_end("@block.outer", "textobjects")
      end, { desc = "next block end" })

      -- Swapping parameters
      vim.keymap.set("n", "gan", function()
        require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
      end, { desc = "swap next argument" })

      vim.keymap.set("n", "gap", function()
        require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
      end, { desc = "swap prev argument" })
    end,
  },
}
