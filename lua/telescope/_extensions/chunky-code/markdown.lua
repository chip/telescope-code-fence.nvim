local has_curl, curl = pcall(require, "plenary.curl")
if not has_curl then error("This plugin requires nvim-lua/plenary.nvim") end

local M = {}

local SAMPLE_MARKDOWN_FOR_DEVELOPMENT = [[
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

function M.fetch(opts)
  opts = opts or {}
  if opts.development then
    return SAMPLE_MARKDOWN_FOR_DEVELOPMENT
  else
    local service = opts.service or 'https://raw.githubusercontent.com/'
    local file = opts.file or 'README.md'
    local branch = opts.branch or 'master'
    local url = service .. opts.repo .. '/' .. branch .. '/' .. file

    local res = curl.request({url = url, method = "get", accept = "text/plain"})
    return res.body
  end
end

return M
