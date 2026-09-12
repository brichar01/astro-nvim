local M = {}

-- Run `cmd` through the shell and insert its output (stdout+stderr) below line `after`.
function M.cmd_output(cmd, stdin, after)
  local result = vim.system({ vim.o.shell, "-c", cmd }, { text = true, stdin = stdin }):wait()

  local out = ((result.stdout or "") .. (result.stderr or "")):gsub("\n$", "")
  if out == "" then return end

  vim.api.nvim_buf_set_lines(0, after, after, false, vim.split(out, "\n", { plain = true }))
end

return M
