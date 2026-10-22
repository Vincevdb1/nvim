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

      vim.lsp.config("rust_analyzer", {
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
      })

      vim.lsp.enable("rust_analyzer")

      vim.lsp.enable("lua_ls")
      vim.lsp.config("nil_ls", {
        on_init = function(client)
          client.server_capabilities.inlayHintProvider = nil
        end,
      })

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

          opts.desc = "LSP rename"
          vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)
        end,
      })

      vim.lsp.inlay_hint.enable(true)
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
