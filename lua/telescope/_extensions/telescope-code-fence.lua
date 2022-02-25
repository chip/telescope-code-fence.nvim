local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugin requires nvim-telescope/telescope.nvim")
end

local main = require("telescope._extensions.telescope-code-fence.main")
local health = require("telescope._extensions.telescope-code-fence.health")
return telescope.register_extension {
  exports = {find = main.find, health = health.check}
}
