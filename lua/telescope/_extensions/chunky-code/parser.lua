local lunamark = require("lunamark")

local M = {}

function string:split(sep)
  sep = sep or "\n"
  local fields = {}
  local pattern = string.format("([^%s]+)", sep)
  for match, _ in self:gmatch(pattern) do table.insert(fields, match) end
  return fields
end

M.parse = function(opts)
  local fences = {}

  local writer = lunamark.writer.generic.new()
  writer.newline = "\n"

  function writer.fenced_code(s, _)
    local lines = s:split()
    local fence = {lines[1], lines}
    table.insert(fences, fence)
    return s
  end

  local reader = lunamark.reader.markdown.new(writer, {
    smart = true,
    fenced_code_blocks = true
  })
  local _, _ = reader(opts.data)

  return fences
end

return M
