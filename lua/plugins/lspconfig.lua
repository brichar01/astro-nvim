-- nvim-lspconfig ships its own lsp/clangd.lua, and a file of that name in the
-- config directory merges before it rather than over it, so cmd set there is
-- discarded. An explicit vim.lsp.config call is what survives.
---@type LazySpec
return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.lsp.config("clangd", {
      -- clangd carries no newlib headers. Querying arm-none-eabi-gcc for its
      -- include paths is what resolves assert.h and everything under it.
      cmd = { "clangd", "--query-driver=/usr/bin/arm-none-eabi-*" },
    })
  end,
}
