
# Installation

```lua
local telescope = require('telescope')
telescope.setup {
  -- opts...
}
telescope.load_extension('paste-code-fences')
```

# Development

```zsh
$ git clone git@github.com:chip/paste-code-fences.nvim.git
$ cd paste-code-fences/lua/telescope/_extensions
$ nvim --cmd "set rtp+=$(pwd)" -u plugin/dev.vim
```
