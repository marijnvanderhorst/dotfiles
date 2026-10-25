-- NeoVim configuration

vim.g.mapleader = " "

-- Bootstrap lazy.nvim when it has not been installed yet.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins" },
})

-- Basic settings
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- Show line numbers
vim.opt.number = true

-- Use 2 spaces for indentation (common in Nix files)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Enable mouse support
vim.opt.mouse = "a"

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Status line
vim.opt.laststatus = 2
vim.opt.ruler = true
