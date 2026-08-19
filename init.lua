require("config.lazy")
require("config.keymaps")

-- Polish
vim.diagnostic.config({ virtual_text = true })
vim.g.clipboad = "wl-copy"

vim.opt.number = true
vim.opt.relativenumber = true

--- Mildly temporary, scratch file stuff
vim.api.nvim_create_user_command("Scratch", function()
  local filetype = vim.bo.buftype
  vim.cmd("enew")
  vim.bo.buftype = filetype
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false
end, {})

-- Example keymap to open it with leader + ns
vim.keymap.set("n", "<leader>ns", ":Scratch<CR>", { silent = true })
