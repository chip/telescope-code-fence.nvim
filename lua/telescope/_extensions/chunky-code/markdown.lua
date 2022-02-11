local has_curl, curl = pcall(require, "plenary.curl")
if not has_curl then error("This plugin requires nvim-lua/plenary.nvim") end

local M = {}

function M.fetch(opts)
  opts = opts or {}
  if opts.development then
    local pwd = os.getenv('PWD')
    package.path = pwd .. "/../../tests/fixtures/?.lua;" .. package.path
    local README = require('TELESCOPE_PLUGIN_README')
    return README
  else
    local service = opts.service or 'https://raw.githubusercontent.com/'
    local file = opts.file or 'README.md'
    local branch = opts.branch or 'master'
    local url = service .. opts.repo .. '/' .. branch .. '/' .. file

    local res = curl.request({url = url, method = "get", accept = "text/plain"})
    return res.body
  end
end

return M
