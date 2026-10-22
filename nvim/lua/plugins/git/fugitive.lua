return {
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Gedit", "GMove", "GRename", "GDelete", "GBrowse" },
    dependencies = {
      -- GitHub integration for vim-fugitive
      "tpope/vim-rhubarb",
    },
  },
}
