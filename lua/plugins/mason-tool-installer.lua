---@type LazySpec
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = {
    ensure_installed = {
      "lua_ls",
      "stylua",
      "black",
      "clangd",
      "clang-format",
    },
  },
}
