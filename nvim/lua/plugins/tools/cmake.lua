return {
  "Civitasv/cmake-tools.nvim",
  ft = { "cpp", "cmake" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    cmake_compile_commands_options = { action = "copy" },
  },
}
