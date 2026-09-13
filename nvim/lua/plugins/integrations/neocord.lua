return {
  "IogaMaster/neocord",
  enabled = true,
  event = "VeryLazy",
  config = function()
    -- The setup config table shows all available config options with their default values:
    require("neocord").setup({
      -- General options
      -- logo = "https://preview.redd.it/i-made-a-neovim-icon-for-macos-download-link-in-comments-v0-lxoizaenvoxa1.png?width=640&crop=smart&auto=webp&s=8ab85a2f539a6c8a87dba2621773b7d85044011a", -- "auto" or url
      logo = "https://repository-images.githubusercontent.com/296702877/d4cd236e-7ca3-4e92-a7c5-533f3a8a9c7b",
      logo_tooltip = nil, -- nil or string
      main_image = "language", -- "language" or "logo"
      client_id = "1157438221865717891", -- Use your own Discord application client id (not recommended)
      log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
      debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
      blacklist = {
        "dotfiles",
        "obsidian"
      }, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
      file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
      show_time = true, -- Show the timer
      global_timer = false, -- if set true, timer won't update when any event are triggered

      -- Rich Presence text options
      editing_text = "Editing %s", -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
      file_explorer_text = "Browsing %s", -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
      git_commit_text = "Committing changes", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
      plugin_manager_text = "Managing plugins", -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
      reading_text = "Reading %s", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
      workspace_text = "Working on %s", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
      line_number_text = "Line %s out of %s", -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
      terminal_text = "Using Terminal", -- Format string rendered when in terminal mode.
    })
  end,
}
