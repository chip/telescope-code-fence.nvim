local has_curl, curl = pcall(require, "plenary.curl")
if not has_curl then error("This plugin requires nvim-lua/plenary.nvim") end

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local previewers = require "telescope.previewers"
local putils = require('telescope.previewers.utils')
-- require telescope-code-fence specific modules
local tcf_url = require "telescope._extensions.telescope-code-fence.url"
local tcf_data = require "telescope._extensions.telescope-code-fence.parser"
local tcf_input = require("telescope._extensions.telescope-code-fence.input")
local utils = require("telescope._extensions.telescope-code-fence.utils")

local M = {}

M.find = function(telescope_opts)
  telescope_opts = vim.tbl_extend("keep", telescope_opts or {},
                                  require("telescope.themes").get_dropdown {})
  local repo, file, text, fences, err

  repo, err = tcf_input.ask_for_repo()
  if err then
    utils.error(err)
    return
  end

  if telescope_opts.file then
    file = telescope_opts.file
  else
    file, err = tcf_input.ask_for_file()
    if err then
      utils.error(err)
      return
    end
  end

  local opts = {repo = repo, file = file, fetch_service = curl}

  text, err = tcf_url.fetch(opts)
  if err then
    utils.error(err)
    return
  end
  fences, err = tcf_data.parse(text)

  if err then
    utils.error(err)
    return
  end

  pickers.new(telescope_opts, {
    prompt_title = "telescope-code-fence",
    finder = finders.new_table {
      results = fences,
      entry_maker = function(entry)
        return {value = entry, display = entry[1], ordinal = entry[1]}
      end
    },
    sorter = conf.generic_sorter(telescope_opts),
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
