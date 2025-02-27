require('telescope').setup {
  defaults = {
    layout_strategy = "vertical",
    mappings = {
      i = {
        ["<C-h>"] = "which_key"
      }
    },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
    }
  },
  extensions = {
  }
}

require("telescope").load_extension "file_browser"

require("project_nvim").setup {
  require("telescope").load_extension "projects"
}
