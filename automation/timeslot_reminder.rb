require 'terminal-notifier'

now = Time.now

reminders = [
  # Slot 1
  { type: 'begin', message: "Beginning Slot 1", hour: 10, minute: 0 },
  { type: 'finish', message: "Finishing Slot 1", hour: 13, minute: 30 },

  # Slot 2
  { type: 'begin', message: "Beginning Slot 2", hour: 15, minute: 0 },
  { type: 'finish', message: "Finishing Slot 2", hour: 18, minute: 00 },

  # Slot 3
  { type: 'begin', message: "Beginning Slot 3", hour: 19, minute: 30 },
  { type: 'finish', message: "Finishing Slot 3", hour: 23, minute: 00 },
]

reminders.each do |reminder|
  if reminder[:hour] == now.hour && reminder[:minute] == now.minute 
    TerminalNotifier.notify(
      'Timeslot Reminder',
      title: reminder[:message],
      subtitle: reminder[:type],
      appIcon: 'http://vjeantet.fr/images/logo.png'
    )
    break
  end
end


