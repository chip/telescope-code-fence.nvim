
# Installation

```lua
local telescope = require('telescope')
telescope.setup {
  -- opts...
}
telescope.load_extension('telescope-code-fence')
```

# Development

```zsh
$ git clone git@github.com:chip/telescope-code-fence.nvim.git
$ cd telescope-code-fence/lua/telescope/_extensions
$ nvim --cmd "set rtp+=$(pwd)" -u plugin/dev.vim
```
