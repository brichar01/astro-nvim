return {
  "hive.nvim",
  dir = "/home/benri/src/hive.nvim",
  main = "hive",
  lazy = false,
  opts = {
    base_url = "https://api.mistral.ai",
    model = "codestral-latest",
    api_key_env = "MISTRAL_API_KEY",
    api_key = function()
      if vim.fn.executable("secret-tool") ~= 1 then return nil end

      local out = vim
        .system({ "secret-tool", "lookup", "service", "mistral", "key", "api" }, { text = true, timeout = 10000 })
        :wait()
      if out.code ~= 0 then return nil end

      local key = vim.trim(out.stdout or "")
      return key ~= "" and key or nil
    end,
  },
  keys = {
    {
      "<leader>rb",
      "<cmd>Lazy reload hive.nvim<cr>",
      desc = "Reload hive.nvim",
      mode = { "n", "v" },
    },
  },
}
