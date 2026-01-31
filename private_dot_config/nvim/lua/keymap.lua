
local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }
local opts = default_opts

local augroup = vim.api.nvim_create_augroup('user_cmds', {clear = true})

-- Clipboard
map('n', '<C-v>', '"+p', opts)
map('i', '<C-v>', '<esc>l"+p', opts)
map('v', '<C-c>', '"+y', opts)

-- Save
map('n', '<C-s>', ':w<CR>', opts)
map('i', '<C-s>', '<ESC>:w<CR>', opts)

-- terminal
map('n', '<C-w>V', ':vsplit term://zsh<CR>', opts)

-- Copilot
vim.g.copilot_no_tab_map = true
map('i', '<C-J>', '<Plug>copilot#Accept("\\<CR>")', default_opts)

-- Testing
map('n', '<leader>tt', ':TestNearest<CR>', default_opts)
map('n', '<leader>tf', ':TestFile -strategy=neovim<CR>', default_opts)

-- flutter-tools.nvim
map('n', '<space>fd', ':FlutterDevices<CR>', default_opts)
map('n', '<space>fe', ':FlutterEmulators<CR>', default_opts)
map('n', '<space>fq', ':FlutterQuit<CR>', default_opts)

-- Git
map('n', '<leader>g', ':Git<CR>', default_opts)

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'fugitive'},
  group = augroup,
  desc = 'Only works on gitcommit files',
  callback = function(event)
    map('n', '<leader>gp', ':Git push<CR>', default_opts)
  end
})

-- Tab
map('n', "<leader>=", ":tabnew<CR>", default_opts)
map('n', "<leader>-", ":tabclose<CR>", default_opts)
map('n', "<leader><", ":tabprevious<CR>", default_opts)
map('n', "<leader>>", ":tabnext<CR>", default_opts)

-- mini.files (Enables tree view)
map('n', '<C-n>', ":lua require('mini.files').open(vim.api.nvim_buf_get_name(0), false)<CR>", default_opts)

vim.keymap.set('n', '<leader>Ff', require('fzf-lua').files, {})
vim.keymap.set('n', '<leader>Fg', require('fzf-lua').live_grep, {})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'http'},
  group = augroup,
  desc = 'Only works on http files',
  callback = function(event)
	map('n', "<leader>t", "<Plug>RestNvim", default_opts)
	map('n', "<leader>tp", "<Plug>RestNvimPreview", default_opts)
	map('n', "<leader>tt", "<Plug>RestNvimLast", default_opts)
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

-- ror.nvim
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'ruby'},
  group = augroup,
  desc = 'Only works on ruby files',
  callback = function(event)
    map("n", "<Leader>rc", ":lua require('ror.commands').list_commands()<CR>", opts)
  end
})

-- Utility functions for Note taking
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'markdown'},
  group = augroup,
  desc = 'Only works on markdown files',
  callback = function(event)
    map("v", "<leader>th", ":lua require('utilities.note_taking').switch_to_hangeul()<CR>", opts)
  end
})

