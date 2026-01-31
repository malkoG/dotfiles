vim.opt.runtimepath:prepend("~/.config/nvim_common")

require('config.lazy')

require('plugins/oil')
require('plugins/packer')
require('settings')
require('plugins/lualine')
require('plugins/blamer')
require('plugins/conform')

require("lsp/init")
require("lsp/language_server")


local scheduler = require('utilities.scheduler')

vim.g.slotted_schedules = {
	{ message = "Beginning Morning Routine", hour = 06, minute = 30 },
	{ message = "Finishing Morning Routine", hour = 08, minute = 00 },

	{ message = "Time to prepare go out", hour = 07, minute = 45 },
	{ message = "Time to go out", hour = 08, minute = 30 },

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

local defaualt_theme = "tokyonight"
if current_theme == nil then
	vim.cmd.colorscheme(defaualt_theme)
elseif available_themes[current_theme] ~= nil then
	vim.cmd.colorscheme(current_theme)
else
	vim.cmd.colorscheme(defaualt_theme)
end
--
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function(args)
-- 		print(args)
--     require("conform").format({ bufnr = args.buf })
--   end,
-- })

vim.opt.termguicolors = true

