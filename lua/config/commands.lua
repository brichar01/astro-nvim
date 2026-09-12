--- Custom Commands

vim.api.nvim_create_user_command("Scratch", require("utils.scratch").scratch, {})
vim.api.nvim_create_user_command("Workbench", function(opts)
  local actions = require("utils.workbench").actions
  if not actions[opts.args] then error("unknown Workbench action: " .. opts.args) end

  actions[opts.args]()
end, {
  nargs = 1,
  complete = function() return vim.tbl_keys(require("utils.workbench").actions) end,
})

-- Run and append
vim.api.nvim_create_user_command("Run", function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)

  require("utils.insert").cmd_output(table.concat(lines, "\n"), nil, opts.line2)
end, { range = true })

-- Pipe into command
vim.api.nvim_create_user_command("Pipe", function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)

  require("utils.insert").cmd_output(opts.args, lines, opts.line2)
end, { range = true, nargs = "+", complete = "shellcmd" })

-- Copy `<path>:<line>` (or `<path>:<line1>-<line2>`) relative to the project root.
vim.api.nvim_create_user_command("CopyRef", function(opts)
  local ref = require("utils.path").relative_with_line(opts.line1, opts.line2)
  vim.fn.setreg("+", ref)
  vim.notify(ref)
end, { range = true })

-- just the relative file path
vim.api.nvim_create_user_command("CopyRel", function()
  local ref = require("utils.path").relative()
  vim.fn.setreg("+", ref)
  vim.notify(ref)
end, { range = true })

-- Copy full path of current file
vim.api.nvim_create_user_command("CopyFile", function()
  local path = require("utils.path").full()
  vim.fn.setreg("+", path)
  vim.notify("Copied" .. path)
end, { range = true })
