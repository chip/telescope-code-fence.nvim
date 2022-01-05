local README = [[
# telescope.nvim

### Installation

Using [vim-plug](https://github.com/junegunn/vim-plug)

```viml
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
```

Using [dein](https://github.com/Shougo/dein.vim)

```viml
call dein#add('nvim-lua/plenary.nvim')
call dein#add('nvim-telescope/telescope.nvim')
```
Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'nvim-telescope/telescope.nvim',
  requires = { {'nvim-lua/plenary.nvim'} }
}
```
]]

local home = os.getenv("HOME")
-- TODO implement extends lib
package.path = home .. "/.luarocks/share/lua/5.1/?.lua;" .. package.path
package.cpath = home .. "/.luarocks/lib/lua/5.1/?.so;" .. package.cpath

local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugin requires nvim-telescope/telescope.nvim")
end

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- TODO use pcall for require?
local inspect = require("inspect")
local curl = require("plenary.curl")
local lunamark = require("lunamark")

-- TODO add filename in opts
--   "/README.md",
--   "/README.markdown",
--   "/readme.md",
--   "/Readme.md",

--local res = curl.request({
--  url = 'https://raw.githubusercontent.com/puremourning/vimspector/master/README.md',
--  method = "get",
--  accept = "text/plain"
--})

function string:split(sep)
   local sep, fields = sep or ":", {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

local fences = {}
local writer = lunamark.writer.generic.new()
writer.newline = "\n"
function writer.fenced_code(s, i)
  -- TODO remove newline after sep default is set in function above 
  local lines = s:split("\n")
  local fence = { lines[1], lines }
  table.insert(fences, fence)
  return s
end
local parse = lunamark.reader.markdown.new(writer, {
  smart = true,
  fenced_code_blocks = true
})
--local result, metadata = parse(res.body)
local result, metadata = parse(README)

-- our picker function: chunks
local chunks = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "CHUNKY CODE!",
    finder = finders.new_table {
      results = fences,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry[1],
          ordinal = entry[1],
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        --print(vim.inspect(selection))
        vim.api.nvim_put(selection.value[2], "l", false, true)
      end)
      return true
    end,
  }):find()
end

-- to execute the function
chunks(require("telescope.themes").get_dropdown{})

