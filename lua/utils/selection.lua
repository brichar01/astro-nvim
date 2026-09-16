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

--- Node types for a named construct, keyed by filetype.
---
--- A filetype with no entry for a kind has no such construct, so the command
--- that asks for it does nothing. `container` is not a command: it holds the
--- roots and declarations that complete a filetype's `parent_types` list.
M.node_types = {
  call = {
    python = { "call" },
    c = { "call_expression" },
    rust = { "call_expression", "macro_invocation" },
    lua = { "function_call" },
    typescript = { "call_expression", "new_expression" },
  },
  method = {
    python = { "function_definition", "decorated_definition" },
    c = { "function_definition" },
    rust = { "function_item" },
    lua = { "function_declaration", "function_definition" },
    typescript = {
      "method_definition",
      "function_declaration",
      "function_expression",
      "generator_function_declaration",
      "arrow_function",
    },
  },
  class = {
    python = { "class_definition" },
    rust = { "impl_item", "trait_item", "struct_item", "enum_item" },
    typescript = { "class_declaration", "interface_declaration" },
  },
  container = {
    python = { "module" },
    c = {
      "preproc_function_def",
      "struct_specifier",
      "union_specifier",
      "enum_specifier",
      "type_definition",
      "translation_unit",
    },
    rust = { "union_item", "macro_definition", "mod_item", "source_file" },
    lua = { "table_constructor", "chunk" },
    typescript = {
      "type_alias_declaration",
      "enum_declaration",
      "internal_module",
      "export_statement",
      "program",
    },
  },
}

--- Kinds that make up `parent_types`. A call is asked for by name, never
--- expanded into.
local parent_kinds = { "method", "class", "container" }

--- @param kind string key of `M.node_types`
---
--- @param ft string? filetype to look up (default: current buffer)
---
--- @return table types for `parent_by_type`, empty where the language has no such construct
function M.types_for_kind(kind, ft) return M.node_types[kind][ft or vim.bo.filetype] or {} end

--- Parent node types worth selecting, keyed by filetype.
---
--- Parsers name the same construct differently, so a shared list picks the wrong
--- node in half the languages.
M.parent_types = {}
for _, kind in ipairs(parent_kinds) do
  for ft, types in pairs(M.node_types[kind]) do
    M.parent_types[ft] = vim.list_extend(M.parent_types[ft] or {}, types)
  end
end

--- Types for a filetype with no `node_types` entry.
M.parent_fallback = {
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
}

--- @param ft string? filetype to look up (default: current buffer)
---
--- @return table types for `parent_by_type`
function M.types_for(ft) return M.parent_types[ft or vim.bo.filetype] or M.parent_fallback end

--- Select a node, leaving the cursor at its end.
---
--- @param node TSNode
---
--- @param visual string? `V` linewise or `v` charwise (default: `V`)
function M.select_node(node, visual)
  visual = visual or "V"
  local start_r, start_c, end_r, end_c = node:range()
  if end_c == 0 then
    end_r = end_r - 1
    end_c = #vim.api.nvim_buf_get_lines(0, end_r, end_r + 1, false)[1]
  end

  if vim.fn.mode():match("[vV\22]") then vim.cmd("normal! \27") end
  vim.api.nvim_win_set_cursor(0, { start_r + 1, start_c })
  vim.cmd("normal! " .. visual)
  vim.api.nvim_win_set_cursor(0, { end_r + 1, visual == "V" and 0 or math.max(end_c - 1, 0) })
end

return M
