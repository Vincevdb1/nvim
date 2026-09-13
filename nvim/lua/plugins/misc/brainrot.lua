return {
  "sahaj-b/brainrot.nvim",
  keys = {
    {
      "<leader>ub",
      function()
        if vim.g.brainrot_enabled == nil then
          vim.g.brainrot_enabled = false
        end

        vim.g.brainrot_enabled = not vim.g.brainrot_enabled
        local brainrot = require("brainrot")

        if vim.g.brainrot_enabled then
          brainrot.setup({
            phonk_time = 2.5,
            disable_phonk = false,
            sound_enabled = true,
            image_enabled = true,
            volume = 50,
          })
          vim.notify("🧠 Brainrot enabled", vim.log.levels.INFO)
        else
          brainrot.setup({
            disable_phonk = true,
            sound_enabled = false,
            image_enabled = false,
          })
          vim.notify("🚫 Brainrot disabled", vim.log.levels.INFO)
        end
      end,
      desc = "Toggle Brainrot",
    },
  },
}
