require('plugins/packer')
require('settings')
require('plugins/nvim-tree')
require('plugins/telescope')
require('plugins/lualine')
require('plugins/dashboard')
require('plugins/blamer')

require('ftplugins.purescript')

require('coc/init')
require('keymap')

require('zettelkasten')

vim.opt.termguicolors = true
vim.cmd("colorscheme melange")
