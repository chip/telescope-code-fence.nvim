local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local previewers = require "telescope.previewers"
local putils = require('telescope.previewers.utils')
local chunky_code_markdown = require "chunky-code.markdown"
local chunky_code_parser = require "chunky-code.parser"

local M = {}

M.find = function(opts)
  opts = vim.tbl_extend("keep", opts or {},
                        require("telescope.themes").get_dropdown {})
  opts.data = chunky_code_markdown.fetch(opts)

  if (not opts.data) then
    vim.api.nvim_err_writeln(
      "[ERROR chunky-code.nvim] fetch returned no results. Try a different file or repo.")
    return false
  end
  local results = chunky_code_parser.parse(opts)

  if (not results) then
    vim.api.nvim_err_writeln(
      "[ERROR chunky-code.nvim] parser returned no results. Try a different file or repo.")
    return false
  end

  if (type(results) ~= "table") then
    vim.api.nvim_err_writeln(
      "[ERROR chunky-code.nvim] parser results were unreadable. Try a different file or repo." ..
        results)
    return false
  end

  pickers.new(opts, {
    prompt_title = "--[[ CHUNKY CODE ]]--",
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
