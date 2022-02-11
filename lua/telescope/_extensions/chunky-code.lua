local home = os.getenv("HOME")
local pwd = os.getenv("PWD")
package.path = pwd .. "/?.lua;" .. home .. "/.luarocks/share/lua/5.1/?.lua;" ..
                 package.path
package.cpath = home .. "/.luarocks/lib/lua/5.1/?.so;" .. package.cpath

local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugin requires nvim-telescope/telescope.nvim")
end

-- TODO local main = require('telescope._extensions.chunky-code.main')
local main = require("telescope._extensions.chunky-code.find")
return telescope.register_extension {
  exports = {chunky_code = main, find = main.find}
}
