return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "saghen/blink.cmp" },
      { "b0o/SchemaStore.nvim", version = false },
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
      vim.lsp.enable("nixd")
      vim.lsp.enable("clangd")
      vim.lsp.enable("sourcekit")
      vim.lsp.enable("hyprls")
      -- ruff handles imports and linting, basedpyright types and hover
      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = { disableOrganizeImports = true },
        },
      })
      vim.lsp.config("ruff", {
        on_init = function(client)
          client.server_capabilities.hoverProvider = false
        end,
      })
      vim.lsp.enable("basedpyright")
      vim.lsp.enable("ruff")
      vim.lsp.enable("bashls")

      -- vue_ls relies on vtsls running @vue/typescript-plugin for TS in .vue files
      local vue_ls_bin = vim.fn.exepath("vue-language-server")
      local vue_plugin_paths = {
        -- nixpkgs wraps the binary, the package lives next to bin/
        vim.fs.joinpath(vim.fs.dirname(vim.fs.dirname(vue_ls_bin)), "lib/language-tools/packages/language-server"),
        vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
      }
      local vue_plugin_path = vim.iter(vue_plugin_paths):find(function(path)
        return vue_ls_bin ~= "" and vim.uv.fs_stat(path) ~= nil
      end)

      vim.lsp.config("vtsls", {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = vue_plugin_path and {
                {
                  name = "@vue/typescript-plugin",
                  location = vue_plugin_path,
                  languages = { "vue" },
                  configNamespace = "typescript",
                },
              } or {},
            },
          },
        },
      })
      vim.lsp.enable("vtsls")
      vim.lsp.enable("angularls")
      vim.lsp.enable("vue_ls")
      vim.lsp.enable("html")
      vim.lsp.enable("cssls")

      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            -- disable the built-in store so SchemaStore.nvim's list is used
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })
      vim.lsp.enable("jsonls")
      vim.lsp.enable("yamlls")
      vim.lsp.enable("taplo")

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      })
      vim.lsp.enable("gopls")
      vim.lsp.enable("templ")

      vim.lsp.enable("neocmake")
      vim.lsp.enable("sqruff")
      vim.lsp.enable("texlab")
      vim.lsp.enable("marksman")
      vim.lsp.enable("dockerls")

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
