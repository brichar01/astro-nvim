-- Pyright registers textDocument/diagnostic after initialize, too late for Neovim,
-- which tests for it once at buffer attach. Withdrawing the client capability keeps
-- pyright on publishDiagnostics.
---@type vim.lsp.Config
return {
  before_init = function(params)
    params.capabilities.textDocument.diagnostic = nil
  end,
}
