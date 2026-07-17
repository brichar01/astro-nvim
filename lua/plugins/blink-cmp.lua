return {
  "saghen/blink.cmp",
  version = "1.*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "default" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    -- providers = {
    --   name = "LazyDev",
    --   module = "lazyev.integrations.blink",
    --   score_offset = 100,
    -- },
  },
}
