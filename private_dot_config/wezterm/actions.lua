local wezterm = require 'wezterm'

local default_opacity = 0.9

wezterm.on('increase-opacity', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local opacity = overrides.window_background_opacity
  if opacity == nil then
	  opacity = default_opacity
  end

  opacity = opacity + 0.1
  if opacity > 1.0 then
	  opacity = 1.0
  end
  overrides.window_background_opacity = opacity

  window:set_config_overrides(overrides)
end)

wezterm.on('decrease-opacity', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local opacity = overrides.window_background_opacity

  if opacity == nil then
	  opacity = default_opacity
  end

  opacity = opacity - 0.1
  if opacity < 0.3 then
	  opacity = 0.3
  end
  overrides.window_background_opacity = opacity

  window:set_config_overrides(overrides)
end)
