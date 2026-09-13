return {
  "CRAG666/code_runner.nvim",
  event = "VeryLazy",
  config = function()
    require("code_runner").setup({
      mode = "float",
      focus = true,
      startinsert = true,
      float = {
        border = "rounded",
      },
      filetype = {
        python = "python3 -u",
        javascript = "node",
        typescript = "deno run",
        -- rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
        rust = "cargo run",
        go = "go run",
        java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
        cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
        c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
        sh = "bash",
        lua = "lua",
        php = "php",
        ruby = "ruby",
        dart = "dart run",
        raku = "raku",
        perl = "perl",
        swift = "swift",
        kotlin = "cd $dir && kotlinc $fileName -include-runtime -d $fileNameWithoutExt.jar && java -jar $fileNameWithoutExt.jar",
        scala = "scala",
        haskell = "runhaskell",
        elixir = "elixir",
        clojure = "clojure",
        ocaml = "ocaml",
        nim = "nim compile --run",
        vala = "valac --pkg gtk+-3.0 --pkg gio-2.0 --pkg glib-2.0 --pkg gdk-3.0 --pkg gobject-2.0 --pkg cairo --pkg pango --pkg atk --pkg gdk-pixbuf-2.0 --pkg libxml-2.0 --pkg sqlite3 --pkg gee-0.8 --pkg soup-2.4 --thread -o $fileNameWithoutExt $fileName && ./$fileNameWithoutExt",
      },
      project_path = vim.fn.expand('~/.config/nvim/project_manager.json')
    })

    local wk = require("which-key")
    wk.add({
      { "<leader>r", group = "Run/Code" },
    })

    vim.keymap.set("n", "<leader>rr", ":RunCode<CR>", { noremap = true, silent = false })
    vim.keymap.set("n", "<leader>rf", ":RunFile<CR>", { noremap = true, silent = false })
    -- vim.keymap.set("n", "<leader>rft", ":RunFile tab<CR>", { noremap = true, silent = false })
    vim.keymap.set("n", "<leader>rp", ":RunProject<CR>", { noremap = true, silent = false })
    vim.keymap.set("n", "<leader>rc", ":RunClose<CR>", { noremap = true, silent = false })
    vim.keymap.set("n", "<leader>crf", ":CRFiletype<CR>", { noremap = true, silent = false })
    vim.keymap.set("n", "<leader>crp", ":CRProjects<CR>", { noremap = true, silent = false })
  end,
}
