require("config.lazy")
require("config.keymaps")

-- Polish this
vim.diagnostic.config({ virtual_text = true })
vim.g.clipboad = "wl-copy"

vim.opt.number = true
vim.opt.relativenumber = true

vim.api.nvim_create_autocmd("BufEnter", {
  command = "setlocal spell spelllang=en_au",
})

--- Mildly temporary, scratch file stuff
vim.api.nvim_create_user_command("Scratch", function()
  vim.cmd("vsplit")
  vim.cmd("enew")
  vim.bo.filetype = "markdown"
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false
end, {})

-- Example keymap to open it with leader + ns
vim.keymap.set("n", "<leader>ns", ":Scratch<CR>", { silent = true })
