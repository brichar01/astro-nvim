--- blink.cmp source: real zsh completion, via the pty'd shell in utils.zsh-complete.

local zsh = require("utils.zsh-complete")

local source = {}

---@class blink-cmp-zsh.Options
---@field filetypes? string[]  restrict to these filetypes (default: all)

function source.new(opts)
  opts = opts or {}
  return setmetatable({ filetypes = opts.filetypes }, { __index = source })
end

function source:enabled()
  if not self.filetypes then return true end
  return vim.tbl_contains(self.filetypes, vim.bo.filetype)
end

function source:get_completions(ctx, callback)
  local kind = require("blink.cmp.types").CompletionItemKind
  local row, col = ctx.cursor[1] - 1, ctx.cursor[2]
  local line = ctx.line:sub(1, col)

  local id = zsh.complete(line, vim.fn.getcwd(), function(matches)
    local seen, items = {}, {}
    for _, m in ipairs(matches) do
      -- zsh emits each match twice: once bare, once with a description.
      local item = seen[m.insert]
      if item then
        if #m.desc > #(item.documentation or "") then item.documentation = m.desc end
      else
        item = {
          label = m.label,
          filterText = m.label,
          kind = kind.Text,
          documentation = m.desc ~= "" and m.desc or nil,
          textEdit = {
            newText = m.insert,
            range = {
              start = { line = row, character = math.max(col - m.replace, 0) },
              ["end"] = { line = row, character = col },
            },
          },
        }
        seen[m.insert] = item
        items[#items + 1] = item
      end
    end

    callback({
      -- The whole line decides the answer, not the word under the cursor, so
      -- blink must re-ask zsh on every keystroke instead of refiltering.
      is_incomplete_forward = true,
      is_incomplete_backward = true,
      items = items,
    })
  end)

  return function() zsh.cancel(id) end
end

return source
