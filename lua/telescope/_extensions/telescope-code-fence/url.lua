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

return M
