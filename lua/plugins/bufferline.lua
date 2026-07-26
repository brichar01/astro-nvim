---@type LazySpec
return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      close_command = "lua MiniBufremove.delete()",
    },
  },
}
