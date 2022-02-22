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

  local res = opts.fetch_service.request({
    url = url,
    method = "get",
    accept = "text/plain"
  })
  if res.status ~= 200 then
    err = string.format("Fetch failed for Github repo %s with %s", opts.repo,
                        res.body)
    return nil, err
  end
  return res.body, nil
end

return M
