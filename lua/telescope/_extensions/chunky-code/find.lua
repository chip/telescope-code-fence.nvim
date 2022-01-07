local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local popup = require "plenary/popup"
local chunky_code_markdown = require "chunky-code/markdown"
local chunky_code_parser = require "chunky-code/parser"

local M = {}

M.find = function(opts)
  opts = vim.tbl_extend('keep', opts or {},
                        require("telescope.themes").get_dropdown {})

  opts.data = chunky_code_markdown.fetch(opts)
  local results = chunky_code_parser.parse(opts)

  if (not next(results)) then
    popup.create("Error: chunky-code.nvim received no results from parsing.", {})
  end

  if (type(results) ~= "table") then
    popup.create("Error: chunky-code.nvim was unable to display results: \n" ..
                   results, {})
  end

  pickers.new(opts, {
    prompt_title = "CHUNKY CODE!",
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
        -- print(vim.inspect(selection))
        vim.api.nvim_put(selection.value[2], "l", false, true)
      end)
      return true
    end
  }):find()
end

return M
