return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "saghen/blink.cmp" },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("ra", {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        settings = {
          ["rust-analyzer"] = {
            files = { watcher = "server" },
            cargo = { targetDir = true },
            check = { command = "clippy" },
            inlayHints = {
              bindingModeHints = { enabled = true },
              closureCaptureHints = { enabled = true },
              closureReturnTypeHints = { enable = "always" },
              maxLength = 100,
            },
            rustc = { source = "discover" },
          },
        },
        root_markers = { { "Cargo.toml" }, ".git" },
      })

      vim.lsp.enable("ra")

      vim.lsp.enable("lua_ls")
      vim.lsp.enable("nixd")
      vim.lsp.enable("nil_ls")
      vim.lsp.enable("clangd")
      vim.lsp.enable("sourcekit")
      vim.lsp.enable("hyprls")
      vim.lsp.enable("pyright")
      vim.lsp.enable("bashls")
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("angularls")
      vim.lsp.enable("vue_ls")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(event)
          local opts = { buffer = event.buf, silent = true }

          opts.desc = "Show LSP references"
          vim.keymap.set("n", "grr", Snacks.picker.lsp_references, opts)

          opts.desc = "Go to declaration"
          vim.keymap.set("n", "grD", vim.lsp.buf.declaration, opts)

          opts.desc = "Show LSP definition"
          vim.keymap.set("n", "grd", vim.lsp.buf.definition, opts)

          opts.desc = "Show LSP implementations"
          vim.keymap.set("n", "gri", Snacks.picker.lsp_implementations, opts)

          opts.desc = "Show LSP type definitions"
          vim.keymap.set("n", "grt", Snacks.picker.lsp_type_definitions, opts)

          opts.desc = "See available code actions"
          vim.keymap.set({ "n", "v" }, "<leader>gra", vim.lsp.buf.code_action, opts)

          opts.desc = "LSP rename"
          vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)

          opts.desc = "Show documentation for what is under cursor"
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        end,
      })

      vim.lsp.inlay_hint.enable(true)

      local severity = vim.diagnostic.severity

      vim.diagnostic.config({
        signs = {
          text = {
            [severity.ERROR] = " ",
            [severity.WARN] = " ",
            [severity.HINT] = "󰠠 ",
            [severity.INFO] = " ",
          },
        },
      })
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
