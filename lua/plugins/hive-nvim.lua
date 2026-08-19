-- Install and configure your plugin during development
return {
  "hive.nvim",
  dir = "/home/benri/src/hive.nvim", -- So we are using the local version of the plugin
  branch = "main", -- Select the branch of the plugin to use
  lazy = false,
  opts = {},
  keys = {
    {
      "<leader>rb", -- Choose a key binding for reloading the plugin
      "<cmd>Lazy reload hive.nvim<cr>",
      desc = "Reload your-plugin.nvim",
      mode = { "n", "v" },
    },
  },
}
