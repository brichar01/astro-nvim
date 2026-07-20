-- Extra keymaps that aren't associated with plugins

vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "<Leader>w", "<Cmd>w<CR>", { desc = "Save, duh" })
vim.keymap.set("n", "<Leader>qq", "<Cmd>confirm q<CR>", { desc = "Quit Window" })
vim.keymap.set("n", "<Leader>qb", "<Cmd>bdelete<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<Leader>Q", "<Cmd>confirm qall<CR>", { desc = "Quit Nvim" })

-- Clip board integration
vim.keymap.set({ "n" }, "<Leader>sr", '"+dd', { desc = "Cut line to system clipboard" })
vim.keymap.set({ "v" }, "<Leader>sr", '"+d', { desc = "Cut visual selection to system clipboard" })

vim.keymap.set("n", "<Leader>ss", '"+yy', { desc = "Copy line to system clipboard" })
vim.keymap.set("v", "<Leader>ss", '"+y', { desc = "Copy line to system clipboard" })

vim.keymap.set("n", "<Leader>st", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("v", "<Leader>st", '"+p', { desc = "Replace selection from system clipboard" })

vim.keymap.set("n", "<Leader>tt", "<Cmd>bNext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<Leader>ts", "<Cmd>bNext<CR>", { desc = "Next tab" })

-- Window stuff
vim.keymap.set("n", "<C-left>", "<C-W>h", { desc = "Focus left window" })
vim.keymap.set("n", "<C-right>", "<C-W>l", { desc = "Focus right window" })
vim.keymap.set("n", "<C-up>", "<C-W>j", { desc = "Focus above window" })
vim.keymap.set("n", "<C-down>", "<C-W>k", { desc = "Focus below window" })

vim.keymap.set("n", "<C-<>", "<C-W><", { desc = "Decrease window width" })
vim.keymap.set("n", "<C->>", "<C-W>>", { desc = "Increase window width" })
