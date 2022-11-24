local g = vim.g

require('nvim-tree').setup {
  open_on_setup = true,
  open_on_setup_file = true,
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true
  },
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
    icons = {
      glyphs = {
        default = "‣ "
      },
      show = {
        file = true,
        folder = true,
        git = true
      }
    }
  },
  filters = {
    dotfiles = true,
    custom = { '.git', 'node_modules', '.cache', '.bin' },
  },
}
