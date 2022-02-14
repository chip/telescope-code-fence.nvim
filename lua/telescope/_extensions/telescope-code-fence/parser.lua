local home = os.getenv("HOME")
package.path = home .. "/.luarocks/share/lua/5.1/?.lua;" .. package.path
package.cpath = home .. "/.luarocks/lib/lua/5.1/?.so;" .. package.cpath

local has_lunamark, lunamark = pcall(require, "lunamark")
if not has_lunamark then
  local msg = [[
    This plugin requires http://jgm.github.io/lunamark.

    Run from project root directory:
      make install

    Or install manually to ~/.luarocks:
      luarocks --lua-dir=/usr/local/opt/lua@5.1 --lua-version=5.1 --local lunamark
  ]]
  error(msg)
end

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

  function writer.fenced_code(s, i)
    local lines = s:split()
    local fence = {lines[1], lines, i}
    table.insert(fences, fence)
    return s
  end

  local reader = lunamark.reader.markdown.new(writer, {
    smart = true,
    fenced_code_blocks = true
  })
  local _, _ = reader(opts.data)

  if next(fences) == nil and opts.data then
    local lines = opts.data:split()
    local fence = {"unknown text", lines, ""}
    table.insert(fences, fence)
  end

  return fences
end

return M
