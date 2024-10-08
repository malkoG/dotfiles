vim.opt.runtimepath:prepend("~/.config/nvim_common")

require('config.lazy')

require('plugins/oil')
require('plugins/packer')
require('settings')
require('plugins/telescope')
require('plugins/lualine')
require('plugins/blamer')


local scheduler = require('utilities.scheduler')

vim.g.slotted_schedules = {
	{ message = "Beginning Morning Routine", hour = 06, minute = 30 },
	{ message = "Finishing Morning Routine", hour = 08, minute = 00 },

  { message = "Beginning Slot 1", hour =  9, minute = 00 },
  { message = "Finishing Slot 1", hour = 12, minute = 30 },

  { message = "Beginning Slot 2", hour = 14, minute = 00 },
  { message = "Finishing Slot 2", hour = 17, minute = 30 },

  { message = "Beginning Slot 3", hour = 19, minute = 00 },
  { message = "Finishing Slot 3", hour = 22, minute = 30 },

  { message = "Beginning Streaming", hour = 00, minute = 00 },
  { message = "Finishing Streaming", hour = 01, minute = 30 },

	{ message = "Time to Bed!!!!", hour = 02, minute = 30 },
}

scheduler.notify_schedule()

require('keymap')
require('abbreviation')

require('zettelkasten')

vim.opt.termguicolors = true

