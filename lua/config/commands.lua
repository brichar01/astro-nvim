vim.api.nvim_create_user_command("Scratch", function()
  vim.cmd("enew")
  vim.bo.filetype = "markdown"
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false
end, {})

vim.api.nvim_create_user_command("Workbench", function()
  local home = vim.uv.os_homedir()
  local cwd = vim.uv.cwd()

  if not cwd or not home then error("a path is not set") end

  -- Project dir relative to $HOME (falls back to the absolute path if outside).
  local rel = cwd
  if cwd == home or vim.startswith(cwd, home .. "/") then rel = cwd:sub(#home + 2) end
  rel = rel:gsub("^/+", "")
  if rel == "" then rel = "home" end

  -- sanitise path
  local slug = (rel:gsub("[^%w%.%-_]", "%%"))

  local dir = vim.fs.joinpath(vim.fn.stdpath("cache"), "workbenches")
  vim.fn.mkdir(dir, "p")

  vim.cmd.edit(vim.fn.fnameescape(vim.fs.joinpath(dir, slug .. ".wb")))
  vim.bo.swapfile = false
  vim.bo.filetype = "markdown"
end, {})

vim.api.nvim_create_user_command("LuaOut", function(opts)
  local result = loadstring(opts.args)()
  if result then vim.api.nvim_buf_set_lines(0, -1, -1, false, { tostring(result) }) end
end, { nargs = "+" })

-- Run `cmd` through the shell and insert its output (stdout+stderr) below line `after`.
local function insert_output(cmd, stdin, after)
  local result = vim.system({ vim.o.shell, "-c", cmd }, { text = true, stdin = stdin }):wait()

  local out = ((result.stdout or "") .. (result.stderr or "")):gsub("\n$", "")
  if out == "" then return end

  vim.api.nvim_buf_set_lines(0, after, after, false, vim.split(out, "\n", { plain = true }))
end

vim.api.nvim_create_user_command("Run", function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)

  insert_output(table.concat(lines, "\n"), nil, opts.line2)
end, { range = true })

vim.api.nvim_create_user_command("Pipe", function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)

  insert_output(opts.args, lines, opts.line2)
end, { range = true, nargs = "+", complete = "shellcmd" })
