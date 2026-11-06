---@diagnostic disable: undefined-global
vim.g.mapleader = " "

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system { "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath }
end
vim.opt.rtp:prepend(lazypath)

require "options"
require "configs.filetype"

require("lazy").setup({ { import = "plugins" } }, {
  defaults = { lazy = true },
  install = { colorscheme = { "catppuccin" } },
  performance = {
    rtp = { disabled_plugins = { "gzip", "tarPlugin", "zipPlugin", "tohtml", "tutor" } },
  },
})

require "mappings"
