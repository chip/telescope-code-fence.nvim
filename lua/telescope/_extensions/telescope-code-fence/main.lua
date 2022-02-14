local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local previewers = require "telescope.previewers"
local putils = require('telescope.previewers.utils')

local markdown = require "telescope._extensions.telescope-code-fence.markdown"
local parser = require "telescope._extensions.telescope-code-fence.parser"
require("telescope._extensions.telescope-code-fence.debug-put")

local format_msg =
  function(s) return "[ERROR telescope-code-fence.nvim] " .. s end

local function error(s) vim.api.nvim_err_writeln(format_msg(s)) end

local function ask(prompt)
  if not prompt then
    error("Please enter a string when prompted")
    return false
  end
  local response = ''
  local on_confirm = function(input) response = input end
  vim.ui.input({prompt = prompt}, on_confirm)
  return response
end

local M = {}

M.find = function(opts)
  opts = vim.tbl_extend("keep", opts or {},
                        require("telescope.themes").get_dropdown {})
  if not opts.repo then
    opts.repo = ask("Enter Github user/repo (example: ryanb/dotfiles): ")
    if not opts.repo then
      error("Please run plugin again and enter a repo name when prompted.")
      return false
    end
  end

  if not opts.file then
    local response = ask(
                       "Enter file name (or press enter to use default README.md): ")
    opts.file = response or "README.md"
  end
  opts.data = markdown.fetch(opts)

  if (not opts.data) then
    error("fetch returned no results.")
    return false
  end
  local results = parser.parse(opts)

  if (not results) then
    error("parser returned no results.")
    return false
  end

  if (type(results) ~= "table") then
    error("parser results were unreadable." .. results)
    return false
  end

  pickers.new(opts, {
    prompt_title = "telescope-code-fence",
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {value = entry, display = entry[1], ordinal = entry[1]}
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.api.nvim_put(selection.value[2], "l", false, true)
      end)
      return true
    end,
    previewer = previewers.new_buffer_previewer({
      define_preview = function(self, entry)
        local output = entry.value[2]
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, output)
        putils.highlighter(self.state.bufnr, entry.value[3])
      end
    })
  }):find()
end

return M
