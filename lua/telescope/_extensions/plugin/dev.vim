" FOR DEVELOPMENT
" Run from /path/to/paste-code-fences/lua/telescope/_extensions directory:
" nvim --cmd "set rtp+=$(pwd)" -u plugin/dev.vim

function! ReloadPlugin()
lua << EOF
  for k in pairs(package.loaded) do 
    if k:match("^chunky") then
      package.loaded[k] = nil
    end
  end
EOF
endfunction

" Reload the plugin
nnoremap <Leader>rp :call ReloadPlugin()<CR>
" Test the plugin using Github repository ryanb/dotfiles as an example
nnoremap <Leader>rr :Telescope chunky-code find development=true file=README.md repo=ryanb/dotfiles 

" Inital load
lua <<EOF
require('telescope').load_extension('chunky-code')
EOF
