return {
  "supermaven-inc/supermaven-nvim",
  enabled = false,
  config = function()
    vim.g.supermaven_status = false

    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<C-l>",
        clear_suggestion = "<C-c>",
        accept_word = "<M-p>",
      },
      color = {
        suggestion_color = "#808080",
        cterm = 244,
      },
      condition = function()
        return not vim.g.supermaven_status
      end,
    })

    -- Explicitly set mapping to ensure it takes precedence in insert mode
    local ok, preview = pcall(require, "supermaven-nvim.completion_preview")
    if ok then
      vim.keymap.set("i", "<C-l>", function()
        if vim.g.supermaven_status then
          preview.on_accept_suggestion()
        end
      end, { silent = true, desc = "Accept Supermaven suggestion" })

      -- Also allow accepting in normal mode if ghost text is present and API exists
      if preview.has_suggestion or preview.is_visible then
        local check = preview.has_suggestion or preview.is_visible
        vim.keymap.set("n", "<C-l>", function()
          if vim.g.supermaven_status and check() then
            preview.on_accept_suggestion()
          else
            vim.cmd("wincmd l")
          end
        end, { silent = true, desc = "Accept Supermaven suggestion or move right" })
      end
    end

    vim.keymap.set("n", "<leader>cs", function()
      vim.g.supermaven_status = not vim.g.supermaven_status
      if vim.g.supermaven_status then
        vim.cmd("SupermavenStart")
      else
        vim.cmd("SupermavenStop")
      end
    end, { desc = "Toggle Supermaven" })

    if not vim.g.supermaven_status then
      pcall(vim.cmd, "SupermavenStop")
    end
  end,
}
