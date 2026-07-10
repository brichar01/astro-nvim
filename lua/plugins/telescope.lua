---@type LazySpec
return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- optional but recommended
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = function()
    local builtin = require "telescope.builtin"
    return {
      {
        "<leader>ff",
        builtin.find_files,
        desc = "Telescope find files",
      },
      {
        "<leader>fw",
        builtin.live_grep,
        desc = "Telescope find word",
      },
      {
        "<leader>fb",
        builtin.buffers,
        desc = "Find buffers",
      },
      {
        "<leader>fh",
        builtin.help_tags,
        desc = "Help",
      },
    }
  end,
}
