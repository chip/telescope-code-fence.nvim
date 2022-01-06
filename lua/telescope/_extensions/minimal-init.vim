set rtp+=.

nnoremap ,,x :luafile %<CR>

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
