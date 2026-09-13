local M = {}

--- @param types table target types, traverse until one is found
---
--- 0-indexed (row, col) tuple.
--- (default: window-local cursor)
--- @param pos [integer, integer]
---
--- @param buf integer?
--- Buffer number (nil or 0 for current buffer)
---
---@return TSNode? Node found, or nil if none are found
function M.parent_by_type(types, pos, buf)
  local row, col = unpack(pos)
  local parser = vim.treesitter.get_parser(buf or 0)
  if not parser then return nil end
  parser:parse(true)

  local node = vim.treesitter.get_node({ bufnr = buf or 0, pos = { row - 1, col } })

  while node do
    node = node:parent()
    if node then
      for _, type in ipairs(types) do
        if type == node:type() then return node end
      end
    end
  end
  return nil
end

--- 0-indexed (row, col) tuple.
--- (default: window-local cursor)
--- @param pos [integer, integer]?
---
--- @param buf integer?
--- Buffer number (nil or 0 for current buffer)
function M._walk_up_tree(pos, buf)
  if not pos then pos = vim.api.nvim_win_get_cursor(0) end
  local row, col = unpack(pos)
  local parser = vim.treesitter.get_parser(buf or 0)
  if not parser then return {} end
  parser:parse(true)

  local node = vim.treesitter.get_node({ bufnr = buf or 0, pos = { row - 1, col } })

  local tree = {}
  while node do
    table.insert(tree, node:type())
    node = node:parent()
  end
  return tree
end

return M
