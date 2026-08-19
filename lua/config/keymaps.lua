-- Extra keymaps that aren't associated with plugins
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "<Leader>w", "<Cmd>w<CR>", { desc = "Save, duh" })
vim.keymap.set("n", "<Leader>qq", "<Cmd>confirm q<CR>", { desc = "Quit Window" })
vim.keymap.set(
  "n",
  "<Leader>qb",
  function() require("mini.bufremove").delete(vim.api.nvim_get_current_buf(), false) end,
  { desc = "Close buffer" }
)
vim.keymap.set("n", "<Leader>Q", "<Cmd>confirm qall<CR>", { desc = "Quit Nvim" })

vim.keymap.set("n", "<Esc>", "<Cmd>noh<CR>", { desc = "Clear highlighting" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>", { desc = "" })

-- Clip board integration
vim.keymap.set({ "n" }, "<Leader>sr", '"+dd', { desc = "Cut line to system clipboard" })
vim.keymap.set({ "v" }, "<Leader>sr", '"+d', { desc = "Cut visual selection to system clipboard" })

vim.keymap.set("n", "<Leader>ss", '"+yy', { desc = "Copy line to system clipboard" })
vim.keymap.set("v", "<Leader>ss", '"+y', { desc = "Copy line to system clipboard" })

vim.keymap.set("n", "<Leader>st", '"+p', { desc = "Paste from system cipboard" })
vim.keymap.set("v", "<Leader>st", '"+p', { desc = "Replace selection from system clipboard" })

vim.keymap.set("n", "<Leader>tt", "<Cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<Leader>ts", "<Cmd>bprevious<CR>", { desc = "Previous Buffer" })

-- Window stuff
vim.keymap.set("n", "<C-left>", "<C-W>h", { desc = "Focus left window" })
vim.keymap.set("n", "<C-right>", "<C-W>l", { desc = "Focus right window" })
vim.keymap.set("n", "<C-up>", "<C-W>j", { desc = "Focus above window" })
vim.keymap.set("n", "<C-down>", "<C-W>k", { desc = "Focus below window" })

vim.keymap.set("n", "<C-<>", "<C-W><", { desc = "Decrease window width" })
vim.keymap.set("n", "<C->>", "<C-W>>", { desc = "Increase window width" })

-- Sneak
vim.keymap.set({ "n", "x", "o" }, "f", "<Plug>(leap)")
vim.keymap.set("n", "F", "<Plug>(leap-from-window)")
