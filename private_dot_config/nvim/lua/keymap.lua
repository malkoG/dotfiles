local telescope_builtin = require('telescope.builtin')

local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }
local opts = default_opts

local augroup = vim.api.nvim_create_augroup('user_cmds', {clear = true})

-- nvim-tree
map('n', '<C-n>', ':NvimTreeToggle<CR>', default_opts)       -- open/close
map('n', '<leader>r', ':NvimTreeRefresh<CR>', default_opts)  -- refresh
map('n', '<leader>n', ':NvimTreeFindFile<CR>', default_opts) -- search file

-- Testing
map('n', '<leader>t', ':TestNearest<CR>', default_opts)

-- Telescope
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})


-- Telekasten
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'markdown'},
  group = augroup,
  desc = 'Only works on markdown files',
  callback = function(event)
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

    -- custom tricky commands
    map('n', "<leader>Zt", ":lua require('telescope.builtin').live_grep(); vim.api.nvim_feedkeys('TODO', 'n', true);<CR>", default_opts)
  end
})

-- Barbar related keymaps

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
-- Sort automatically by...
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
-- Utility functions for Note taking
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'markdown'},
  group = augroup,
  desc = 'Only works on markdown files',
  callback = function(event)
    map("v", "<leader>th", ":lua require('utilities.note_taking').switch_to_hangeul()<CR>", opts)
  end
})
