return {
  "nvim-mini/mini.ai",
  event = "VeryLazy",
  config = function()
    local ai = require("mini.ai")

    ai.setup({
      n_lines = 500,
      custom_textobjects = {
        ["%"] = "",
        s = ai.gen_spec.treesitter({ -- code block
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
        c = ai.gen_spec.treesitter({ a = "@call.outer", i = "@call.inner" }),
      },
      search_method = "cover_or_next",
    })
  end,
}
