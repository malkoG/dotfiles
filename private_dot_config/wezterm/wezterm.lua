local wezterm = require("wezterm")
local actions = require("actions")
local keymaps = require("keymaps")

local os = require('os')
local home_path = os.getenv('HOME')

return {
	-- font = wezterm.font_with_fallback({'셈틀체', 'NanumBarunGothic'}),
	-- font = wezterm.font_with_fallback({'JetBrains Mono', 'NanumBarunGothic'}),
	font = wezterm.font_with_fallback({'CascadiaCodeNF', 'NanumBarunGothic'}),
	font_size = 12.0,
	line_height = 1.2,
	window_background_opacity = 0.9,
	keys = keymaps,
	window_background_gradient = {
		-- Can be "Vertical" or "Horizontal".  Specifies the direction
	  -- in which the color gradient varies.  The default is "Horizontal",
	  -- with the gradient going from left-to-right.
	  -- Linear and Radial gradients are also supported; see the other
	  -- examples below

	  -- Specifies the set of colors that are interpolated in the gradient.
	  -- Accepts CSS style color specs, from named colors, through rgb
	  -- strings and more
	  colors = { '#000', '#002' },
	  orientation = { Linear = { angle = -45.0 } },

	  -- Instead of specifying `colors`, you can use one of a number of
	  -- predefined, preset gradients.
	  -- A list of presets is shown in a section below.
	  -- preset = "RdGy",

	  -- Specifies the interpolation style to be used.
	  -- "Linear", "Basis" and "CatmullRom" as supported.
	  -- The default is "Linear".
	  interpolation = 'Linear',

	  -- How the colors are blended in the gradient.
	  -- "Rgb", "LinearRgb", "Hsv" and "Oklab" are supported.
	  -- The default is "Rgb".
	  blend = 'Rgb',

	  -- To avoid vertical color banding for horizontal gradients, the
	  -- gradient position is randomly shifted by up to the `noise` value
	  -- for each pixel.
	  -- Smaller values, or 0, will make bands more prominent.
	  -- The default value is 64 which gives decent looking results
	  -- on a retina macbook pro display.
	  -- noise = 64,

	  -- By default, the gradient smoothly transitions between the colors.
	  -- You can adjust the sharpness by specifying the segment_size and
	  -- segment_smoothness parameters.
	  -- segment_size configures how many segments are present.
	  -- segment_smoothness is how hard the edge is; 0.0 is a hard edge,
	  -- 1.0 is a soft edge.

	  -- segment_size = 11,
	  -- segment_smoothness = 0.0,
	},
	background = {
		{
			source = {
				File = home_path .. "/.config/wezterm/assets/NeovimShadowed.png"
			},
			width = 240,
			height = 180,
			hsb = { brightness = 0.025 },
			repeat_x = 'NoRepeat',
			repeat_y = 'NoRepeat',
			vertical_align = 'Top',
			vertical_offset = '80',
			horizontal_align = 'Right',
			horizontal_offset = '-20'
		}
	}
}
