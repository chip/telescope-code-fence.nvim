local home = os.getenv("HOME")
-- TODO implement extends lib
package.path = home .. "/.luarocks/share/lua/5.1/?.lua;" .. package.path
package.cpath = home .. "/.luarocks/lib/lua/5.1/?.so;" .. package.cpath

-- TODO use pcall for require?
local inspect = require("inspect")
local curl = require("plenary.curl")

local res = curl.request({
  url = 'https://raw.githubusercontent.com/puremourning/vimspector/master/README.md',
  method = "get",
  accept = "text/plain"
})
-- print('res:', inspect(res))
print("body:\n", inspect(res.body))

local lunamark = require("lunamark")
local fences = {}
local writer = lunamark.writer.generic.new()
function writer.fenced_code(s, i)
  local fence = {infostring = i, fenced_code = s}
  table.insert(fences, fence)
  return s
end
local parse = lunamark.reader.markdown.new(writer, {
  smart = true,
  fenced_code_blocks = true
})
local result, metadata = parse(res.body)
-- print("\n-----------------\n")
-- print("result")
-- print(result)
-- print("\n-----------------\n")
-- print("metadata")
print(inspect(fences))
-- print(inspect(metadata))
