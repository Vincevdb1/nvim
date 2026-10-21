return {
  "GustavEikaas/easy-dotnet.nvim",
  ft = { "cs", "csproj", "sln", "slnx", "props" },
  cmd = "Dotnet",
  dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
  opts = {
    picker = "snacks",
    -- roslyn.nvim owns the LSP
    lsp = { enabled = false },
    test_runner = { viewmode = "float" },
  },
}
