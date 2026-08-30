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
