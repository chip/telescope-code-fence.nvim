print("inside chunky-code.lua")

local home = os.getenv("HOME")
local pwd = os.getenv("PWD")
print("pwd:", pwd)
package.path = home .. "/.luarocks/share/lua/5.1/?.lua;" .. package.path
package.cpath = home .. "/.luarocks/lib/lua/5.1/?.so;" .. package.cpath

local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugin requires nvim-telescope/telescope.nvim")
end

-- local main = require('telescope._extensions.chunky-code.main')
local chunky_code = require("lua/telescope/_extensions/chunky-code/find")
print('chunky_code', chunky_code)
-- return telescope.register_extension({exports = chunky_code})
return telescope.register_extension {
  -- setup = chunky_code.setup,
  exports = {find = chunky_code.find}
}
