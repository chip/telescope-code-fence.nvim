" FOR DEVELOPMENT
" Run from /path/to/telescope-code-fence/lua/telescope/_extensions directory:
" TODO is plugin/ the proper path or lua/telescope/_extensions/plugin?
" nvim --cmd "set rtp+=$(pwd)" -u plugin/dev.vim

function! ReloadPlugin()
lua << EOF
  for k in pairs(package.loaded) do
    if k:match("telescope%-code%-fence.main") then
      package.loaded[k] = nil
    end
  end
EOF
endfunction

" Reload the plugin
nnoremap <Leader>rp :call ReloadPlugin()<CR>
" Test the plugin using Github repository ryanb/dotfiles as an example
nnoremap <Leader>rf :Telescope telescope-code-fence find
nnoremap <Leader>rd :Telescope telescope-code-fence find development=true file=README.md repo=ryanb/dotfiles

" Inital load
lua <<EOF
require('telescope').load_extension('telescope-code-fence')
EOF
