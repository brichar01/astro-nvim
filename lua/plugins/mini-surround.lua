---@type LazySpec
return {
  "nvim-mini/mini.surround",
  version = "*",
  config = function()
    require("mini.surround").setup({
      mappings = {
        add = "<Leader>an", -- Add surrounding in Normal and Visual modes
        delete = "<Leader>ad", -- Delete surrounding
        find = "<Leader>af", -- Find surrounding (to the right)
        find_left = "<Leader>aF", -- Find surrounding (to the left)
        highlight = "<Leader>ah", -- Highlight surrounding
        replace = "<Leader>ar", -- Replace surrounding

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    })
  end,
}
