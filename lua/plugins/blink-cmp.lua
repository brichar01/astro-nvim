-- `.sh`, `.bash` and a `#!` shebang all detect as `sh`; `.zsh` as `zsh`.
local shell_filetypes = { sh = true, bash = true, zsh = true }

return {
  "saghen/blink.cmp",
  version = "1.*",
  -- lazy.nvim runs `init` during startup even though the plugin itself is lazy,
  -- so the pty is warm (~700ms, in the background) long before the first request.
  init = function()
    vim.schedule(function()
      require("utils.zsh-complete").start()
    end)
  end,
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    completion = { menu = { auto_show = true } },
    keymap = { preset = "default", ["Up"] = {}, ["Down"] = {} },
    sources = {
      -- A shell buffer, or a bash/zsh fenced block in markdown. `md_block_lang`
      -- is maintained by the MarkdownBlockLang autocmds in
      -- lua/config/autocommands.lua.
      default = function()
        local sources = { "lsp", "path", "buffer" }
        local lang = vim.b.md_block_lang
        if shell_filetypes[vim.bo.filetype] or lang == "bash" or lang == "zsh" then
          table.insert(sources, "zsh")
        end
        return sources
      end,
      providers = {
        zsh = {
          name = "Zsh",
          module = "utils.blink-cmp-zsh",
          async = true,
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
