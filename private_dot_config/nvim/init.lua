require('plugins/packer')
require('settings')
require('plugins/nvim-tree')
require('plugins/telescope')
require('plugins/lualine')
require('plugins/blamer')

require('ftplugins.purescript')

local scheduler = require('utilities.scheduler')

vim.g.slotted_schedules = {
	{ message = "Beginning Morning Routine", hour = 07, minute = 30 },
	{ message = "Finishing Morning Routine", hour = 09, minute = 30 },

  { message = "Beginning Slot 1", hour = 10, minute = 00 },
  { message = "Finishing Slot 1", hour = 13, minute = 30 },

  { message = "Beginning Slot 2", hour = 15, minute = 00 },
  { message = "Finishing Slot 2", hour = 18, minute = 00 },

  { message = "Beginning Slot 3", hour = 19, minute = 30 },
  { message = "Finishing Slot 3", hour = 23, minute = 00 },

  { message = "Beginning Streaming", hour = 22, minute = 30 },
  { message = "Finishing Streaming", hour = 23, minute = 45 },

	{ message = "Time to Bed!!!!", hour = 00, minute = 30 },
}

scheduler.notify_schedule()

require('coc/init')
require('keymap')
require('abbreviation')

require('zettelkasten')

vim.opt.termguicolors = true

local current_theme = os.getenv("NEOVIM_THEME")

local available_themes = {}
for _, theme in ipairs({
	"melange",
	"catppuccin",
	"tokyonight",
	"nordic",
}) do
	available_themes[theme] = true
end

if current_theme == nil then 
	vim.cmd.colorscheme("melange")
elseif available_themes[current_theme] ~= nil then
	vim.cmd.colorscheme(current_theme)
else
	vim.cmd.colorscheme("melange")
end

