# telescope-code-fence.nvim

This [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
extension will fetch and parse Markdown files from [Github](https://github.com)
and provide a list of **[Code
Fences](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-and-highlighting-code-blocks)**
that you can paste into an nvim buffer. It will fetch a **README.md** file by
default, but this can be changed by calling the function using a `file=` option
(see **Commands** section below for details.)

## Requirements

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) (required)

## Install

You can install the extension by cloning this repository somewhere on your
filepath, and then adding the following somewhere after your
`require('telescope').setup()` call in your configuration file (`init.vim` or
`init.lua`) :

```lua
require('telescope').load_extension('telescope-code-fence')
```
## Setup

### Commands

```vim
" Uses README.md as the default Markdown file to fetch and parse
:Telescope telescope-code-fence repo=nvim-telescope/telescope.nvim

" Replace file option
:Telescope telescope-code-fence file=readme.md repo=nvim-telescope/telescope.nvim
```

### Bind to Keys:

```vim
" Replace <Leader>cf with whatever you prefer. Modify string after repo= to whatever github user/repo you prefer.
nnoremap <Leader>cf <cmd>Telescope telescope-code-fence file=readme.md repo=nvim-telescope/telescope.nvim
```

### Available Functions

```lua
require'telescope'.extensions.telescope-code-fence.find{}
```
### Development

```zsh
$ git clone git@github.com:chip/telescope-code-fence.nvim.git
$ cd telescope-code-fence/lua/telescope/_extensions
$ nvim --cmd "set rtp+=$(pwd)" -u plugin/dev.vim
```

