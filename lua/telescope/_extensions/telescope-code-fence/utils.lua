local M = {}

M.pp = function(format, s)
  local fmt = "\n" .. format .. "\n"
  return print(string.format(fmt, vim.inspect(s)))
end
M.format_msg = function(s) return "[ERROR telescope-code-fence.nvim] " .. s end
M.error = function(s)
  local msg = M.format_msg(s)
  vim.api.nvim_err_writeln(msg)
end

return M
