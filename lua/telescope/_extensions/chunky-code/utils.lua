-- Source: https://github.com/alpha2phi/alpha.nvim/blob/main/lua/alpha/init.lua
-- Debugging dump
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end
