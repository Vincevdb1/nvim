return {
  "vinnymeller/swagger-preview.nvim",
  build = "npm i",
  cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
  keys = {
    { "<leader>tw", "<cmd>SwaggerPreviewToggle<cr>", ft = { "yaml", "json" }, desc = "Swagger Preview" },
  },
  opts = {
    port = 8000,
    host = "localhost",
  },
}
