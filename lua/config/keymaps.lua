-- Extra keymaps that aren't associated with plugins
local km = vim.keymap

km.set("n", ";", ":")
km.set("n", "<Leader>w", "<Cmd>w<CR>", { desc = "Save, duh" })
km.set("n", "<Leader>qq", "<Cmd>confirm q<CR>", { desc = "Quit Window" })
km.set(
  "n",
  "<Leader>qb",
  function() require("mini.bufremove").delete(vim.api.nvim_get_current_buf(), false) end,
  { desc = "Close buffer" }
)
km.set("n", "<Leader>Q", "<Cmd>confirm qall<CR>", { desc = "Quit Nvim" })

km.set("n", "<Esc>", "<Cmd>noh<CR>", { desc = "Clear highlighting" })
km.set("t", "<Esc>", "<C-\\><C-N>", { desc = "", noremap = true })

-- Clip board integration
km.set({ "n" }, "<Leader>sr", '"+dd', { desc = "Cut line to system clipboard", noremap = true })
km.set({ "v" }, "<Leader>sr", '"+d', { desc = "Cut visual selection to system clipboard", noremap = true })

km.set("n", "<Leader>ss", '"+yy', { desc = "Copy line to system clipboard", noremap = true })
km.set("v", "<Leader>ss", '"+y', { desc = "Copy line to system clipboard", noremap = true })

km.set("n", "<Leader>st", '"+p', { desc = "Paste from system cipboard", noremap = true })
km.set("v", "<Leader>st", '"+p', { desc = "Replace selection from system clipboard", noremap = true })

km.set("n", "<Leader>tt", "<Cmd>bnext<CR>", { desc = "Next buffer" })
km.set("n", "<Leader>ts", "<Cmd>bprevious<CR>", { desc = "Previous Buffer" })

-- Window stuff
km.set("n", "<C-left>", "<C-W>h", { desc = "Focus left window", noremap = true })
km.set("n", "<C-right>", "<C-W>l", { desc = "Focus right window", noremap = true })
km.set("n", "<C-up>", "<C-W>j", { desc = "Focus above window", noremap = true })
km.set("n", "<C-down>", "<C-W>k", { desc = "Focus below window", noremap = true })

km.set("n", "<C-<>", "<C-W><", { desc = "Decrease window width", noremap = true })
km.set("n", "<C->>", "<C-W>>", { desc = "Increase window width", noremap = true })

km.set("n", "<Leader>nt", "<Cmd>vsplit | terminal<CR>", {})

-- Sneak
km.set({ "n", "x", "o" }, "f", "<Plug>(leap)")
km.set("n", "F", "<Plug>(leap-from-window)")

km.set(
  { "n", "x" },
  "<leader>re",
  function() return require("refactoring").extract_func() end,
  { desc = "Extract Function", expr = true }
)
-- `_` is the default textobject for "current line"
km.set(
  "n",
  "<leader>rer",
  function() return require("refactoring").extract_func() .. "_" end,
  { desc = "Extract Function (line)", expr = true }
)

km.set(
  { "n", "x" },
  "<leader>rE",
  function() return require("refactoring").extract_func_to_file() end,
  { desc = "Extract Function To File", expr = true }
)

km.set(
  { "n", "x" },
  "<leader>rv",
  function() return require("refactoring").extract_var() end,
  { desc = "Extract Variable", expr = true }
)

-- `_` is the default textobject for "current line"
km.set(
  "n",
  "<leader>rvr",
  function() return require("refactoring").extract_var() .. "_" end,
  { desc = "Extract Variable (line)", expr = true }
)

km.set(
  { "n", "x" },
  "<leader>ri",
  function() return require("refactoring").inline_var() end,
  { desc = "Inline Variable", expr = true }
)
km.set(
  { "n", "x" },
  "<leader>rI",
  function() return require("refactoring").inline_func() end,
  { desc = "Inline function", expr = true }
)

km.set(
  { "n", "x" },
  "<leader>rs",
  function() return require("refactoring").select_refactor() end,
  { desc = "Select refactor" }
)

--- Mildly experimental
vim.keymap.set("n", "<leader>ns", ":vsplit | Scratch<CR>", { silent = true })
vim.keymap.set("n", "<leader>nw", ":vsplit | Workbench<CR>", { silent = true })
vim.keymap.set("v", "<leader>nr", ":Run<CR>", { silent = true })
vim.keymap.set("n", "<leader>nr", "<Cmd>Run<CR>", { silent = true })
