set rtp+=.

nnoremap ,,x :luafile %<CR>
nnoremap ,,c :Telescope chunky-code find<CR>
nnoremap ,,r :Telescope chunky-code find repo=

lua <<EOF
return require('packer').startup(function(use)
  use 'chunky-code.nvim'

  local telescope = require('telescope')
  telescope.setup {
    -- opts...
  }
  telescope.load_extension('chunky-code')
end)
EOF
