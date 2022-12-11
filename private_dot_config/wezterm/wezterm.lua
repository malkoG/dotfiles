local wezterm = require("wezterm")
local keymaps = require("keymaps")

return {
	font = wezterm.font_with_fallback({'JetBrains Mono', 'NanumBarunGothic'}),
	font_size = 14.0,
	window_background_opacity = 0.9,
	keys = keymaps,
}
