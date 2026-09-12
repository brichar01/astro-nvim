local M = {}

function M.scratch()
  vim.cmd("enew")
  vim.bo.filetype = "markdown"
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false
end

return M
