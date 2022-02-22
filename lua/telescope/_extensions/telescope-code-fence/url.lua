local utils = require("telescope._extensions.telescope-code-fence.utils")
local M = {}

M.build = function(opts)
  if not opts or opts.repo == '' or opts.repo == nil then
    return nil, "Please run plugin again and enter a repo name when prompted."
  end
  local service = opts.service or "https://raw.githubusercontent.com"
  local file = opts.file or "README.md"
  local branch = opts.branch or "master"
  local url = service .. "/" .. opts.repo .. "/" .. branch .. "/" .. file
  return url, nil
end

-- opts = {
--   repo = "chip/dotfiles"
--   file = "README"
--   fetch_service = inject curl as dependency
-- }
M.fetch = function(opts)
  local url, err = M.build(opts)
  if err then return nil, err end

  opts = opts or {}
  if opts.development then
    local pwd = os.getenv('PWD')
    package.path = pwd .. "/../../tests/fixtures/?.lua;" .. package.path
    local README = require("tests.fixtures.TELESCOPE_PLUGIN_README")
    return README
  else
    local res = opts.fetch_service.request({
      url = url,
      method = "get",
      accept = "text/plain"
    })
    if res.status ~= 200 then
      local msg = string.format("Fetch failed for Github repo %s with %s",
                                opts.repo, res.body)
      err = utils.format_msg(msg)
      return nil, err
    end
    return res.body, nil
  end
end

return M
