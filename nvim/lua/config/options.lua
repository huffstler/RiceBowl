-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false
vim.go.background = "light"
vim.g.snacks_animate = false

local opt = vim.opt
-- Use tabs, not spaces
opt.expandtab = false
-- 4 spaces for tab, not 2
opt.tabstop = 4
