local M = {}

local utils = require("telescope._extensions.telescope-code-fence.utils")

M.ask = function(prompt)
  local response = ''
  local on_confirm = function(input) response = input end
  vim.ui.input({prompt = prompt}, on_confirm)
  return response
end

M.prompt_user = function(opts)
  if not opts.repo then
    opts.repo = M.ask("Enter Github user/repo (example: ryanb/dotfiles): ")
    utils.pp("prompt_user repo = %s", opts.repo)
    if not opts.repo then
      error("Please run plugin again and enter a repo name when prompted.")
    end
  end

  if not opts.file then
    local response = M.ask(
                       "Enter file name (or press enter to use default README.md): ")
    opts.file = response or "README.md"
    utils.pp("opts.file = %s", opts.file)
  end

  return opts
end

return M
