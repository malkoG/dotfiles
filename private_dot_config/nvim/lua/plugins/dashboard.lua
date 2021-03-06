local db = require('dashboard')
-- linux
db.custom_center = {
  {
    icon = '  ',
    desc = 'Recent projects                         ',
    action ='Telescope projects'
    -- shortcut = 'SPC s l',
  },
  {
    icon = '  ',
    desc = 'Recently opened files                   ',
    action =  'DashboardFindHistory'
    -- shortcut = 'SPC f h',
  },

  {
    icon = '  ',
    desc = 'Find  File                              ',
    action = 'Telescope find_files find_command=rg,--hidden,--files',
    -- shortcut = 'SPC f f',
  },
  {
    icon = '  ',
    desc ='File Browser                            ',
    action =  'Telescope file_browser',
    -- shortcut = 'SPC f b',
  },
  {
    icon = '  ',
    desc = 'Find  word                              ',
    action = 'Telescope live_grep',
    -- shortcut = 'SPC f w',
  }
}
