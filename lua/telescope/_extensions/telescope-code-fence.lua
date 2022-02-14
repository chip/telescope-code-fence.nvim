local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugin requires nvim-telescope/telescope.nvim")
end

local main = require("telescope._extensions.telescope-code-fence.main")
return telescope.register_extension {exports = {find = main.find}}