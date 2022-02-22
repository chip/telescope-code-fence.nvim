# telescope-code-fence.nvim

This [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
extension will fetch and parse text files from [Github](https://github.com)
and provide a list of **[Markdown Code
Fences](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-and-highlighting-code-blocks)**
that you can paste into an nvim buffer. It will fetch a **README.md** file by
default, but this can be changed when prompted by the plugin.
(see **Commands** section below for details.)

## Requirements

- Neovim (v0.6.0)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) (required)
- *Only tested on MacOS 11.6.1*

## Install

You can install the extension by using
[packer.nvim](https://github.com/wbthomason/packer.nvim) or by cloning this
repository somewhere on your filepath, and then adding the following somewhere
after telescope in your configuration file (`init.vim` or `init.lua`).

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use 'nvim-lua/plenary.nvim'
use 'nvim-telescope/telescope.nvim'
use {
  "chip/telescope-code-fence.nvim",
  run = 'cd telescope-code-fence.nvim && make install'
}
require('telescope').load_extension('telescope-code-fence')
```
## Setup

### Commands

```vim
" Prompts user for Github user/repo
" Prompts for file argument, but uses README.md as default
:Telescope telescope-code-fence
```

### Bind to Keys:

```vim
" Replace <Leader>cf with whatever you prefer
nnoremap <Leader>cf <cmd>Telescope telescope-code-fence
```

### Development

```zsh
$ git clone git@github.com:chip/telescope-code-fence.nvim.git
$ cd telescope-code-fence/lua/telescope/_extensions
$ nvim --cmd "set rtp+=$(pwd)" -u plugin/dev.vim
```
## TODO

* Run `make install` hook for Packer
* Add animated gif to demonstrate plugin use
* Add social template per Github Pages
* Add working healthcheck
