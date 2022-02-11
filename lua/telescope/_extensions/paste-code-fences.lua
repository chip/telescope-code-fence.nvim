local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugin requires nvim-telescope/telescope.nvim")
end

-- TODO local main = require('telescope._extensions.paste-code-fences.main')
local main = require("telescope._extensions.paste-code-fences.find")
return telescope.register_extension {
  exports = {paste-code-fences = main, find = main.find}
}
