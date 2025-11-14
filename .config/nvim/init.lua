require "options"
require "mappings"
require "commands"
print("hi")

-- bootstrap plugins & lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim" -- path where its going to be installed

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

local plugins = require "plugins"

require("lazy").setup(plugins, require "lazy_config")
vim.o.background = "dark" -- or "light" for light mode
-- Default options:
require("gruvbox").setup({
  transparent_mode = true,
})
vim.cmd("colorscheme gruvbox")
-- Default options:
