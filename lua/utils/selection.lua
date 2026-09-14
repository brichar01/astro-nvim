local M = {}

--- @param types table target types, traverse until one is found
---
--- @param pos [integer, integer] (0, 0) indexed cursor position (eg. from vim.api.nvim_win_get_cursor(0))
---
--- @param buf integer? buffer index, 0 for current buffer
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

--- Parent node types worth selecting, keyed by filetype.
---
--- Parsers name the same construct differently, so a shared list picks the wrong
--- node in half the languages. `fallback` covers a filetype with no entry.
M.parent_types = {
  python = {
    "function_definition",
    "decorated_definition",
    "class_definition",
    "module",
  },
  c = {
    "function_definition",
    "preproc_function_def",
    "struct_specifier",
    "union_specifier",
    "enum_specifier",
    "type_definition",
    "translation_unit",
  },
  rust = {
    "function_item",
    "impl_item",
    "trait_item",
    "struct_item",
    "enum_item",
    "union_item",
    "macro_definition",
    "mod_item",
    "source_file",
  },
  lua = {
    "function_declaration",
    "function_definition",
    "table_constructor",
    "chunk",
  },
  typescript = {
    "method_definition",
    "function_declaration",
    "function_expression",
    "generator_function_declaration",
    "arrow_function",
    "class_declaration",
    "interface_declaration",
    "type_alias_declaration",
    "enum_declaration",
    "internal_module",
    "export_statement",
    "program",
  },
  fallback = {
    "function_definition",
    "function_declaration",
    "function_item",
    "method_definition",
    "class_definition",
    "class_declaration",
    "struct_item",
    "impl_item",
    "table_constructor",
    "chunk",
    "module",
    "program",
    "source_file",
    "translation_unit",
  },
}

--- @param ft string? filetype to look up (default: current buffer)
---
--- @return table types for `parent_by_type`
function M.types_for(ft) return M.parent_types[ft or vim.bo.filetype] or M.parent_types.fallback end

return M
