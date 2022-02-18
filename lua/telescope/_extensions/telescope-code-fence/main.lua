local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local previewers = require "telescope.previewers"
local putils = require('telescope.previewers.utils')
-- require telescope-code-fence specific modules
local markdown = require "telescope._extensions.telescope-code-fence.markdown"
local parser = require "telescope._extensions.telescope-code-fence.parser"
local input = require("telescope._extensions.telescope-code-fence.input")
local utils = require("telescope._extensions.telescope-code-fence.utils")
require("telescope._extensions.telescope-code-fence.debug-put")

local M = {}

M.find = function(telescope_opts)
  utils.pp("find opts %s", telescope_opts)
  telescope_opts = vim.tbl_extend("keep", telescope_opts or {},
                                  require("telescope.themes").get_dropdown {})

  local opts = {}

  -- TODO decide repo data type. currently prompt_user returns an opts table
  local has_repo, repo = pcall(input.prompt_user, opts)
  print(string.format("has_repo %s", has_repo))
  print(string.format("repo %s", repo))
  if not has_repo then
    utils.error(repo)
    return
  end
  opts.repo = repo
  utils.pp("DEBUG opts %s", opts)

  -- local repo = input.prompt_user(opts)
  -- utils.pp("after prompt_user %s", repo)
  -- if not repo then return end

  -- local data = markdown.fetch(opts)
  -- utils.pp("after markdown.fetch %s", data)
  local has_data, data = pcall(markdown.fetch, opts)
  print(string.format("has_data %s", has_data))
  print(string.format("data %s", data))
  if not has_data then
    utils.error(data)
    return
  end
  opts.data = data

  -- if (not data) then
  --   utils.error("fetch returned no results.")
  --   return false
  -- end
  local results = parser.parse(opts)
  utils.pp("after parser.parse %s", results)

  if (not results) then
    utils.error("parser returned no results.")
    return false
  end

  if (type(results) ~= "table") then
    utils.error("parser results were unreadable." .. results)
    return false
  end

  pickers.new(telescope_opts, {
    prompt_title = "telescope-code-fence",
    finder = finders.new_table {
      results = results,
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
