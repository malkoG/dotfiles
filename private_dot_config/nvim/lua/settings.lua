local cmd = vim.cmd       -- execute Vim commands
local exec = vim.api.nvim_exec  -- execute Vimscript
local fn = vim.fn         -- call Vim functions
local g = vim.g           -- global variables
local opt = vim.opt           -- global/buffer/windows-scoped options

opt.number = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.colorcolumn = "120"

-- git-gutter settings
g.gitgutter_set_sign_backgrounds = 1
