local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

-- nvim-tree
map('n', '<C-n>', ':NvimTreeToggle<CR>', default_opts)       -- open/close
map('n', '<leader>r', ':NvimTreeRefresh<CR>', default_opts)  -- refresh
map('n', '<leader>n', ':NvimTreeFindFile<CR>', default_opts) -- search file

-- Testing
map('n', '<leader>t', ':TestNearest<CR>', default_opts)

-- Telekasten
map('n', "<leader>zf", ":lua require('telekasten').find_notes()<CR>", default_opts)
map('n', "<leader>zd", ":lua require('telekasten').find_daily_notes()<CR>", default_opts)
map('n', "<leader>zz", ":lua require('telekasten').follow_link()<CR>", default_opts)
map('n', "<leader>zT", ":lua require('telekasten').goto_today()<CR>", default_opts)
map('n', "<leader>zW", ":lua require('telekasten').goto_thisweek()<CR>", default_opts)
map('n', "<leader>zn", ":lua require('telekasten').new_note()<CR>", default_opts)
map('n', "<leader>zc", ":lua require('telekasten').show_calendar()<CR>", default_opts)
map('n', "<leader>zC", ":CalendarT<CR>", default_opts)
map('n', "<leader>zt", ":lua require('telekasten').toggle_todo()<CR>", default_opts)
map('n', "<leader>zb", ":lua require('telekasten').show_backlinks()<CR>", default_opts)

map('n', "<leader>z", ":lua require('telekasten').panel()<CR>", default_opts)

map('i', "<leader>[", "<cmd>:lua require('telekasten').insert_link({ i=true })<CR>", default_opts)
map('i', "<leader>zt", "<cmd>:lua require('telekasten').toggle_todo({ i=true })<CR>", default_opts)
map('i', "<leader>#", "<cmd>lua require('telekasten').show_tags({i = true})<CR>", default_opts)

