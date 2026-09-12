local M = {}

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

M.actions = {
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

return M
