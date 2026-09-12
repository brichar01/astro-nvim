--- blink.cmp source: executables on $PATH
--- Install as e.g.  ~/.config/nvim/lua/blink-cmp-shellcmd.lua

local source = {}

---@class blink-cmp-shellcmd.Options
---@field filetypes? string[]  restrict to these filetypes (default: all)
---@field pattern? string      only complete when the line before the cursor matches

function source.new(opts)
  opts = opts or {}
  return setmetatable({
    filetypes = opts.filetypes,
    pattern = opts.pattern,
  }, { __index = source })
end

function source:enabled()
  if not self.filetypes then return true end
  return vim.tbl_contains(self.filetypes, vim.bo.filetype)
end

local function to_items(names)
  local kind = require("blink.cmp.types").CompletionItemKind.Function
  local items = {}
  for i = 1, #names do
    items[i] = {
      label = names[i],
      kind = kind,
      insertText = names[i],
    }
  end
  return items
end

function source:get_completions(ctx, callback)
  -- Optional context gate, e.g. pattern = '!%S*$' for :!cmd
  local gated = self.pattern and not ctx.line:sub(1, ctx.cursor[2]):match(self.pattern)

  callback({
    is_incomplete_forward = false,
    is_incomplete_backward = false,
    items = gated and {} or to_items(vim.fn.getcompletion("", "shellcmd")),
  })

  return function() end
end

-- Show the resolved executable path in the detail pane.
function source:resolve(item, callback)
  local resolved = vim.deepcopy(item)
  resolved.detail = vim.fn.exepath(item.label)
  callback(resolved)
end

return source
