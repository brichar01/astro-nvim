---@type LazySpec
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = {
    ensure_installed = {
      "lua_ls",
      "stylua",
      "pyright",
      "clangd",
      "clang-format",
      "prettier",
      "tsgo",
      "bash-language-server",
    },
  },
}
