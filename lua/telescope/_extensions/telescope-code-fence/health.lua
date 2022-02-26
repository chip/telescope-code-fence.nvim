local health = require("health")
local M = {}

local vim_installed = function()
  local vim_version = vim.version()
  local version = tonumber(string.format("%s.%s", vim_version.major,
                                         vim_version.minor))
  if version >= 0.6 then
    return true
  else
    return false
  end
end

M.check = function()
  health.report_start("Start health check for telescope-code-fence.nvim")
  health.report_info(string.format("Current time: %s", os.clock()))
  if vim_installed() then
    health.report_ok("nvim version >= 0.6 installed")
  else
    health.report_error("please install nvim > 0.6")
  end

  local packages = {"telescope", "plenary.curl", "lunamark"}
  for _, package in pairs(packages) do
    local has_package, _ = pcall(require, package)
    if has_package then
      health.report_ok(string.format("%s is installed", package))
    else
      health.report_error(string.format("This plugin requires %s", package))
    end
  end
end

return M
