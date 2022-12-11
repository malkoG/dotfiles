local wezterm = require("wezterm")
local keymaps = {}

local numbers = {0, 1, 2, 3, 4, 5, 6, 7}

-- Tab navigation
for _, number in ipairs(numbers) do
	table.insert(
		keymaps,
		{
			key = tostring(number + 1),
			mods = "ALT",
			action = wezterm.action.ActivateTab(number)
		}
	)
end

for _, key in ipairs({'[', '{'}) do
	table.insert(
		keymaps,
		{
			key = key,
			mods = "ALT",
			action = wezterm.action.ActivateTabRelative(-1),
		}
	)
end

for _, key in ipairs({']', '}'}) do
	table.insert(
		keymaps,
		{
			key = key,
			mods = "ALT",
			action = wezterm.action.ActivateTabRelative(1),
		}
	)
end

-- Copy & Paste
table.insert(
	keymaps,
	{
    	key = 'C',
    	mods = 'SHIFT|CTRL',
    	action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection',
	}
)

table.insert(
	keymaps,
	{
		key = 'V',
		mods = 'SHIFT|CTRL',
		action = wezterm.action.PasteFrom 'Clipboard',
	}
)

table.insert(
	keymaps,
	{
		key = 'V',
		mods = 'SHIFT|CTRL',
		action = wezterm.action.PasteFrom 'PrimarySelection',
	}
)

return keymaps
