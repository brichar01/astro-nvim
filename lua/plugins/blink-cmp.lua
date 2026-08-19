return {
  "saghen/blink.cmp",
  version = "1.*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    completion = { menu = { auto_show = true } },
    keymap = { preset = "default", ["Up"] = {}, ["Down"] = {} },
    sources = {
      default = { "lsp", "path" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
