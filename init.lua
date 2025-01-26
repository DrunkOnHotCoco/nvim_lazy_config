require("config.lazy")
require("lazy").setup("plugins")

local oldinit = vim.fn.stdpath("config") .. "/old.init.vim"
vim.cmd('source' .. oldinit)
