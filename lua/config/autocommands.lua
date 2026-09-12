local group = vim.api.nvim_create_augroup("MarkdownBlockLang", { clear = true })

-- Language of the fenced code block under the cursor, or "markdown" when the
-- cursor is outside a block or no parser is installed for the block's language.
local function block_lang(buf)
  local parser = vim.treesitter.get_parser(buf)
  if not parser then
    return "markdown"
  end
  parser:parse(true) -- `true` resolves injections; a plain parse() will not

  -- Anchor on the fence itself: prose is injected as `markdown_inline`, so the
  -- injection alone cannot tell prose from a code block.
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local node = vim.treesitter.get_node({ bufnr = buf, pos = { row - 1, col }, lang = "markdown" })
  while node and node:type() ~= "fenced_code_block" do
    node = node:parent()
  end
  if not node then
    return "markdown"
  end

  local lang = parser:language_for_range({ row - 1, col, row - 1, col }):lang()
  -- No parser installed for the fence's language => no injection => markdown.
  if lang == "markdown" or lang == "markdown_inline" then
    return "markdown"
  end
  return lang
end

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "markdown",
  callback = function(ev)
    vim.b[ev.buf].md_block_lang = "markdown"
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      buffer = ev.buf,
      callback = function()
        vim.b[ev.buf].md_block_lang = block_lang(ev.buf)
      end,
    })
  end,
})
