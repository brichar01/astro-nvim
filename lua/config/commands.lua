vim.api.nvim_create_user_command("Scratch", function()
  vim.cmd("enew")
  vim.bo.filetype = "markdown"
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false
end, {})

local function workbench_slug()
  local home = vim.uv.os_homedir()
  local cwd = vim.uv.cwd()

  if not cwd or not home then error("a path is not set") end

  -- Project dir relative to $HOME (falls back to the absolute path if outside).
  local rel = cwd
  if cwd == home or vim.startswith(cwd, home .. "/") then rel = cwd:sub(#home + 2) end
  rel = rel:gsub("^/+", "")
  if rel == "" then rel = "home" end

  -- sanitise path
  return (rel:gsub("[^%w%.%-_]", "%%"))
end

local function workbench_dir()
  local dir = vim.fs.joinpath(vim.fn.stdpath("cache"), "workbenches")
  vim.fn.mkdir(dir, "p")
  return dir
end

local function open_workbench(path)
  vim.cmd.edit(vim.fn.fnameescape(path))
  vim.bo.swapfile = false
  vim.bo.filetype = "markdown"
end

local function new_workbench()
  local name = workbench_slug() .. "-" .. os.date("%Y%m%d%H%M%S") .. ".wb"

  open_workbench(vim.fs.joinpath(workbench_dir(), name))
end

local function latest_workbench()
  local existing = vim.fn.glob(vim.fs.joinpath(workbench_dir(), workbench_slug() .. "-*.wb"), false, true)
  table.sort(existing)

  return existing[#existing]
end

local workbench_actions = {
  open = function()
    local latest = latest_workbench()
    if latest then
      open_workbench(latest)
    else
      new_workbench()
    end
  end,
  new = new_workbench,
}

vim.api.nvim_create_user_command("Workbench", function(opts)
  local action = workbench_actions[opts.args]
  if not action then error("unknown Workbench action: " .. opts.args) end

  action()
end, {
  nargs = 1,
  complete = function() return vim.tbl_keys(workbench_actions) end,
})

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

-- Run and append
vim.api.nvim_create_user_command("Run", function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)

  insert_output(table.concat(lines, "\n"), nil, opts.line2)
end, { range = true })

-- Pipe into command
vim.api.nvim_create_user_command("Pipe", function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)

  insert_output(opts.args, lines, opts.line2)
end, { range = true, nargs = "+", complete = "shellcmd" })

-- Copy `<path>:<line>` (or `<path>:<line1>-<line2>`) relative to the project root.
vim.api.nvim_create_user_command("CopyRef", function(opts)
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then error("buffer has no file") end

  local root = vim.uv.cwd()
  if root == nil then error("no root") end
  local path = vim.fs.relpath(root, file) or file

  local ref = path .. ":" .. opts.line1
  if opts.line2 > opts.line1 then ref = ref .. "-" .. opts.line2 end

  vim.fn.setreg("+", ref)
  vim.notify(ref)
end, { range = true })

-- just the relative file path
vim.api.nvim_create_user_command("CopyRel", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then error("buffer has no file") end

  local root = vim.uv.cwd()
  if root == nil then error("no root") end
  local path = vim.fs.relpath(root, file) or file

  local ref = path

  vim.fn.setreg("+", ref)
  vim.notify(ref)
end, { range = true })

-- Copy full path of current file
vim.api.nvim_create_user_command("CopyFile", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then error("buffer has no file") end

  local path = vim.fs.path(file)

  vim.fn.setreg("+", path)
  vim.notify("Copied" .. path)
end, { range = true })
