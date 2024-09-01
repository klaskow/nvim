local cmd = vim.cmd
local g = vim.g
local opt = vim.opt

cmd("syntax off")
g.is_termux = vim.fn.has("unix") == 1 and vim.fn.isdirectory("/data/data/com.termux/files") == 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.mapleader = " "
g.maplocalleader = "\\"
g.netrw_nogx = 1
opt.breakindent = true
opt.clipboard = ""
opt.concealcursor = ""
opt.conceallevel = 0
opt.cursorcolumn = false
opt.cursorline = true
opt.expandtab = true
opt.foldmethod = "manual"
opt.ignorecase = true
opt.linebreak = true
opt.number = true
opt.relativenumber = true
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
opt.shiftwidth = 2
opt.showtabline = 2
opt.signcolumn = "yes"
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.synmaxcol = 240
opt.tabstop = 2
opt.termguicolors = true
opt.undofile = false
opt.wrap = true

