local has_curl, curl = pcall(require, "plenary.curl")
if not has_curl then error("This plugin requires nvim-lua/plenary.nvim") end

local utils = require("telescope._extensions.telescope-code-fence.utils")

local M = {}

function M.fetch(opts)
  utils.pp("inside fetch opts", opts)
  if opts == nil or opts.repo == nil then
    utils.error("woops")
    return
  end

  opts = opts or {}
  if opts.development then
    local pwd = os.getenv('PWD')
    package.path = pwd .. "/../../tests/fixtures/?.lua;" .. package.path
    local README = require("tests.fixtures.TELESCOPE_PLUGIN_README")
    return README
  else
    local service = opts.service or 'https://raw.githubusercontent.com/'
    local file = opts.file or 'README.md'
    local branch = opts.branch or 'master'
    local url = service .. opts.repo .. '/' .. branch .. '/' .. file

    local res = curl.request({url = url, method = "get", accept = "text/plain"})
    utils.pp("M.fetch res = %s", res)
    if res.status ~= 200 then
      utils.error(string.format("Fetch failed with status: %s. Error: %s",
                                res.status, res.body))
      return
    end
    return res.body
  end
end

return M
