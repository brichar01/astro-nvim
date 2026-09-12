require("config.lazy")

vim.opt.splitright = true
require("config.commands")
require("config.autocommands")
require("config.keymaps")
-- Polish this
vim.diagnostic.config({ virtual_text = true })
vim.g.clipboad = "wl-copy"

vim.opt.number = true
vim.opt.relativenumber = true
