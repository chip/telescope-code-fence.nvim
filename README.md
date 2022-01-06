
# Installation

```lua
local telescope = require('telescope')
telescope.setup {
  -- opts...
}
telescope.load_extension('chunky-code')
```

# Development

```zsh
$ git clone git@github.com:chip/chunky-code.nvim.git
$ cd chunky-code
$ nvim --cmd "set rtp+=$(pwd)"
```
