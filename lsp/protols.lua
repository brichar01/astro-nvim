---@type vim.lsp.Config
return {
  cmd = { "protols" },
  filetypes = { "proto" },
  root_markers = { "protols.toml", "buf.yml" },
}
