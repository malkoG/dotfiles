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

-- Moving cursor within prompt
local cursor_related_keymaps = {
	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ key = "LeftArrow", mods = "OPT", action = wezterm.action { SendString = "\x1bb" } },
	-- Make Option-Right equivalent to Alt-f; forward-word
	{ key = "RightArrow", mods = "OPT", action = wezterm.action { SendString= "\x1bf" } },
}

for _, keymap in ipairs(cursor_related_keymaps) do
	table.insert(
		keymaps,
		{
			key = keymap.key,
			mods = keymap.mods,
			action = keymap.action
		}
	)
end

return keymaps
