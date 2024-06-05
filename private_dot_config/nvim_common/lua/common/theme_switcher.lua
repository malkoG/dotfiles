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

