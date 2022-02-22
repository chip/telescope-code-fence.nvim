" FOR DEVELOPMENT
" nvim --cmd "set rtp+=$(pwd)" -u lua/telescope/_extensions/plugin/dev.vim
set rtp+=$(pwd)

function! ReloadPlugin()
lua << EOF
  for k in pairs(package.loaded) do
    if k:match("telescope%-code%-fence") then
      package.loaded[k] = nil
    end
  end
EOF
endfunction

" Reload the plugin
nnoremap <Leader>rp :call ReloadPlugin()<CR>
" Test the plugin
nnoremap <Leader>rf :Telescope telescope-code-fence find<CR>
" Test the plugin in using file README.md on Github repository ryanb/dotfiles (as an example)
nnoremap <Leader>rd :Telescope telescope-code-fence find file=README.md repo=ryanb/dotfiles<CR>

" Inital load
lua <<EOF
require('telescope').load_extension('telescope-code-fence')
EOF
