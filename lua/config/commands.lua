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

vim.api.nvim_create_user_command("Reload", function(opts)
  local module_name = opts.args
  package.loaded[module_name] = nil
  require(module_name)
end, { nargs = 1 })

-- Selection by treesitter node
local function select_command(kind, visual)
  return function(opts)
    local selection = require("utils.selection")
    local pos = opts.range > 0 and { opts.line1, 0 } or vim.api.nvim_win_get_cursor(0)
    local node = selection.parent_by_type(selection.types_for_kind(kind), pos)
    if node then selection.select_node(node, visual) end
  end
end

vim.api.nvim_create_user_command("SelectionExpand", function(opts)
  local selection = require("utils.selection")
  local node = selection.parent_by_type(selection.types_for(), { opts.line1, 0 })
  if not node then error("no parent") end

  selection.select_node(node)
end, { range = true })

vim.api.nvim_create_user_command("SelectCall", select_command("call", "v"), { range = true })
vim.api.nvim_create_user_command("SelectMethod", select_command("method"), { range = true })
vim.api.nvim_create_user_command("SelectClass", select_command("class"), { range = true })

-- Append the nearest function to the workbench, split at the cursor as a FIM prompt.
local fim_markers = { prefix = "<|fim_prefix|>", suffix = "<|fim_suffix|>" }

vim.api.nvim_create_user_command("WorkbenchFim", function()
  local selection = require("utils.selection")
  local pos = vim.api.nvim_win_get_cursor(0)
  local node = selection.parent_by_type(selection.types_for_kind("method"), pos)
  if not node then error("no function at the cursor") end

  local prefix, suffix = require("utils.formatting").split_at_cursor(pos, node, 0, fim_markers)
  if not prefix then error("cursor outside the function") end

  local start_r, _, end_r, end_c = node:range()
  if end_c == 0 then end_r = end_r - 1 end
  local lines = { require("utils.path").relative_with_line(start_r + 1, end_r + 1) }
  vim.list_extend(lines, suffix or {})
  vim.list_extend(lines, prefix)

  vim.fn.writefile(lines, require("utils.workbench").current(), "a")
  vim.cmd.checktime()
end, {})

vim.api.nvim_create_user_command("HiveFim", function(opts)
  local max_tokens = tonumber(opts.args) or 128
  if max_tokens < 1 or max_tokens % 1 ~= 0 then error("max tokens must be a positive integer") end

  local selection = require("utils.selection")
  local pos = vim.api.nvim_win_get_cursor(0)
  local node = selection.parent_by_type(selection.types_for_kind("method"), pos)
  if not node then error("no function at the cursor") end

  local prefix, suffix = require("utils.formatting").split_at_cursor(pos, node, 0)
  if not prefix or not suffix then error("cursor outside the function") end

  local before = table.concat(prefix, "\n")
  local after = table.concat(suffix, "\n")

  local start_r, _, end_r, end_c = node:range()
  if end_c == 0 then end_r = end_r - 1 end
  local ref = require("utils.path").relative_with_line(start_r + 1, end_r + 1)
  local at = ("%d:%d"):format(pos[1], pos[2])
  local workbench = require("utils.workbench").current()

  vim.notify(("hive: %s at %s, %d tokens"):format(ref, at, max_tokens))
  require("hive").completions(before, after, max_tokens, function(err, completion)
    if err or completion == nil then return vim.notify("hive: " .. (err or "No completion"), vim.log.levels.ERROR) end

    local filled = before .. completion.text .. after

    local lines = { ("%s @ %s -- %s"):format(ref, at, completion.finish_reason or "?") }
    vim.list_extend(lines, vim.split(filled, "\n", { plain = true }))

    vim.fn.writefile(lines, workbench, "a")
    vim.cmd.checktime()
  end)
end, { nargs = "?" })
