return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    sections = {
      lualine_x = {
        {
          function()
            return vim.b.md_block_lang or ""
          end,
          cond = function()
            return vim.b.md_block_lang ~= nil
          end,
        },
        "encoding",
        "fileformat",
        "filetype",
      },
    },
  },
}
