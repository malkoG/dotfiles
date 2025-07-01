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

wezterm.on('user-var-changed', function(window, pane, name, value)
  wezterm.log_info(string.format('User var changed: %s = %s', name, value))
  if name == 'aider-task-complete' then
	local tab = pane:tab()

	-- tab 객체가 정상적으로 존재하는지 확인
    if tab ~= nil then
      -- tab이 존재할 경우: 원래대로 탭 정보를 포함하여 알림 생성
      local tab_title = tab:get_title()
      local tab_id = tab:tab_id()
      notification_title = string.format('🤖 [Aider] 작업 완료 (%d번 탭)', tab_id)
      notification_body = string.format('탭 "%s"의 작업이 끝났습니다.', tab_title)
    else
      -- tab이 존재하지 않는 예외적인 경우: 기본 알림 생성
      notification_title = '🤖 [Aider] 작업 완료'
      notification_body = '백그라운드 작업이 완료되었습니다.'
    end

	wezterm.log_info(notification_title)
	wezterm.log_info(notification_body)

    window:toast_notification(
	  notification_title,
	  notification_body,
	  nil,
	  5000 -- 5초
    )
  end
end)

wezterm.on("window-config-reloaded", function(window, pane)
  wezterm.log_info("Window configuration reloaded")
  window:toast_notification(
	"WezTerm",
	"Window configuration reloaded.",
	nil,
	5000 -- 5초
  )
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
