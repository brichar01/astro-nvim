--- Client for the long-lived zsh completion server (scripts/zsh-complete-server.zsh).
--- One pty'd `zsh -i` is warmed once per nvim session and reused for every request.

local M = {}

local server = vim.fn.stdpath("config") .. "/scripts/zsh-complete-server.zsh"

local job, ready, carry = nil, false, ""
local next_id, pending, queued = 0, {}, {}

local function handle(line)
  if line == "@@READY@@" then
    ready = true
    for _, msg in ipairs(queued) do
      vim.fn.chansend(job, msg)
    end
    queued = {}
    return
  end

  local id, rest = line:match("^(%d+)\t(.*)$")
  local req = id and pending[id]
  if not req then
    return -- unknown or cancelled request
  end

  if rest == "@@END@@" then
    pending[id] = nil
    req.cb(req.items)
    return
  end

  local n, insert, label, desc = rest:match("^(%d+)\t([^\t]*)\t([^\t]*)\t(.*)$")
  if not n then
    return
  end
  -- `_path_files` walks each path segment, so one request yields several groups
  -- with different replacement lengths. Only the longest is the real word.
  n = tonumber(n)
  if n > req.best then
    req.best, req.items = n, {}
  end
  if n == req.best then
    req.items[#req.items + 1] = { replace = n, insert = insert, label = label, desc = desc }
  end
end

function M.start()
  if job then
    return
  end
  job = vim.fn.jobstart({ "zsh", server }, {
    on_stdout = function(_, data)
      data[1] = carry .. data[1]
      carry = table.remove(data)
      for _, line in ipairs(data) do
        if line ~= "" then
          handle(line)
        end
      end
    end,
    on_exit = function()
      job, ready, carry, pending, queued = nil, false, "", {}, {}
    end,
  })
end

--- @return string id  pass to M.cancel to drop a request still in flight
function M.complete(line, cwd, cb)
  M.start()
  next_id = next_id + 1
  local id = tostring(next_id)
  pending[id] = { items = {}, best = -1, cb = cb }

  local msg = id .. "\t" .. cwd .. "\t" .. line .. "\n"
  if ready then
    vim.fn.chansend(job, msg)
  else
    queued[#queued + 1] = msg
  end
  return id
end

function M.cancel(id)
  pending[id] = nil
end

return M
