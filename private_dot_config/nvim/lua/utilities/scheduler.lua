local notifier = require("notify")

local M = {}

M.notify_schedule = function()
  -- This function runs timer and notifies on specified time
  --
  -- For example,
  --   13:00:00 (Alarm)
  --   13:00:01 (Doesn't alarm)
  --   13:59:59 (Doesn't alarm)
  --   14:00:00 (Alarm)
  --
  -- And We can manage schedules using tables
  -- For example,
  --   local schedules = {
  --     { message = "Starting phase 1", hour = 13, minute = 30 },
  --     { message = "Starting phase 2", hour = 16, minute = 30 },
  --     { message = "Starting phase 3", hour = 19, minute = 30 },
  --   }

  local schedules = vim.g.slotted_schedules or {}

  local function notify()
    local now = os.date("*t")
    for _, schedule in ipairs(schedules) do
      if now.hour == schedule.hour and now.min == schedule.minute and now.sec <= 2 then
        notifier.notify(schedule.message, vim.log.levels.INFO)
      end
    end

    vim.defer_fn(notify, 1500)
  end

  notify()
end

return M
