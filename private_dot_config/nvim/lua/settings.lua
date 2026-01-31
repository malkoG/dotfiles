local cmd = vim.cmd       -- execute Vim commands
local exec = vim.api.nvim_exec  -- execute Vimscript
local fn = vim.fn         -- call Vim functions
local g = vim.g           -- global variables
local opt = vim.opt           -- global/buffer/windows-scoped options

opt.number = true
opt.relativenumber = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.colorcolumn = { 79, 99, 119 }
opt.langmap = "ㅁa,ㅠb,ㅊc,ㅇd,ㄷe,ㄹf,ㅎg,ㅗh,ㅑi,ㅓj,ㅏk,ㅣl,ㅡm,ㅜn,ㅐo,ㅔp,ㅂq,ㄱr,ㄴs,ㅅt,ㅕu,ㅍv,ㅈw,ㅌx,ㅛy,ㅋz"
opt.splitright = true

-- Treating dash(-) and underscore(_) as a separator, not words
--
-- ex. rub|y_on_rails -- (typing ciw) --> *_on_rails
opt.iskeyword:remove("-")
opt.iskeyword:remove("_")
opt.autoread = true

-- git-gutter settings
g.gitgutter_set_sign_backgrounds = 1

vim.cmd [[ source ~/.config/nvim/lua/copilot.vim ]]
