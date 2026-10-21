return {
  "seblyng/roslyn.nvim",
  -- last commit before the bump to nvim >= 0.12
  commit = "f2ec6ee",
  ft = "cs",
  -- in init: the plugin enables "roslyn" as soon as it loads, before config runs
  init = function()
    vim.lsp.config("roslyn", {
      -- roslyn-ls from nixpkgs, mason's "roslyn" binary isn't available.
      -- Dev shells put their own openssl on LD_LIBRARY_PATH, which crashes the
      -- server's runtime ("No usable version of libssl was found").
      cmd = {
        "env",
        "-u",
        "LD_LIBRARY_PATH",
        "Microsoft.CodeAnalysis.LanguageServer",
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--stdio",
      },
      settings = {
        ["csharp|inlay_hints"] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_parameters = true,
        },
        ["csharp|code_lens"] = {
          dotnet_enable_references_code_lens = true,
        },
      },
    })
  end,
  opts = {},
}
