local M = {}

M.ask = function(prompt)
  local response = ''
  local on_confirm = function(input) response = input end
  vim.ui.input({prompt = prompt}, on_confirm)
  return response
end

M.ask_for_repo = function()
  local repo = M.ask("Enter Github user/repo (example: ryanb/dotfiles): ")
  if repo == nil or repo == '' then
    return nil, "Please run plugin again and enter a repo name when prompted."
  end
  return repo
end

M.ask_for_file = function()
  local file = M.ask(
                 "Enter file name (or press enter to use default README.md): ")
  if file == nil or file == '' then
    return "README.md"
  else
    return file
  end
end

return M
