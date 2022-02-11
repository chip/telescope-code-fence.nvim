local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugin requires nvim-telescope/telescope.nvim")
end

-- TODO local main = require('telescope._extensions.chunky-code.main')
local main = require("telescope._extensions.chunky-code.find")
return telescope.register_extension {
  exports = {chunky_code = main, find = main.find}
}
