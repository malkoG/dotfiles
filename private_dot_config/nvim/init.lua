require('plugins/packer')
require('settings')
require('plugins/nvim-tree')
require('plugins/telescope')
require('plugins/lualine')
require('plugins/blamer')

require('ftplugins.purescript')

local scheduler = require('utilities.scheduler')

vim.g.slotted_schedules = {
  { message = "Beginning Slot 1", hour = 10, minute = 00 },
  { message = "Finishing Slot 1", hour = 13, minute = 30 },

  { message = "Beginning Slot 2", hour = 15, minute = 00 },
  { message = "Finishing Slot 2", hour = 18, minute = 00 },

  { message = "Beginning Slot 3", hour = 19, minute = 30 },
  { message = "Finishing Slot 3", hour = 23, minute = 00 },
}

scheduler.notify_schedule()

require('coc/init')
require('keymap')

require('zettelkasten')

vim.opt.termguicolors = true
vim.cmd("colorscheme melange")
