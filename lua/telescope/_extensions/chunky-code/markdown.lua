-- TODO use pcall for require?
local curl = require("plenary.curl")

local M = {}

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

-- TODO add filename in opts
--   "/README.md",
--   "/README.markdown",
--   "/readme.md",
--   "/Readme.md",

--[[
-- TODO Telescope chunky-code repo=chip/dotfiles
--]]
--

function M.fetch(opts)
  -- print("fetch opts")
  -- print(inspect(opts))
  opts = opts or {}
  -- local url = 'https://raw.githubusercontent.com/' .. opts.repo ..
  --               '/master/README.md'
  --
  -- local res = curl.request({url = url, method = "get", accept = "text/plain"})
  --
  -- return res.body
  return README
end

return M
