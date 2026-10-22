return {
  "weirongxu/plantuml-previewer.vim",
  ft = "plantuml",
  dependencies = { "tyru/open-browser.vim", "aklt/plantuml-syntax" },
  init = function()
    -- Prefer the system plantuml.jar (e.g. from nix) over the bundled one
    local exe = vim.fn.exepath("plantuml")
    if exe ~= "" then
      local jar = vim.fn.fnamemodify(vim.fn.resolve(exe), ":h:h") .. "/lib/plantuml.jar"
      if vim.uv.fs_stat(jar) then
        vim.g["plantuml_previewer#plantuml_jar_path"] = jar
      end
    end
  end,
  keys = {
    { "<leader>tu", "<cmd>PlantumlToggle<cr>", ft = "plantuml", desc = "PlantUML Preview" },
  },
  cmd = { "PlantumlOpen", "PlantumlStart", "PlantumlStop", "PlantumlToggle", "PlantumlSave" },
}
