" FOR DEVELOPMENT 
" nvim --cmd "set rtp+=$(pwd)" -u plugin/dev.vim

lua <<EOF
return require('packer').startup(function(use)
  print('inside packer startup')
-- TODO required?
-- use 'wbthomason/packer.nvim'

	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'
	use "~/code/chunky-code.nvim"
  print('before require telescope')
  local telescope = require('telescope')
  print('before load_extension')
  print(vim.inspect(telescope))
  telescope.load_extension('chunky-code')

-- use {
--   'chip/chunky-code.nvim',
--   requires = {
--     'nvim-lua/plenary.nvim',
--     'nvim-telescope/telescope.nvim',
--   },
--   config = function ()
-- 	print('inside config func')
--     require"chunky-code"
-- 	print('inside config func before setup()')
--     require"chunky-code".setup()
--   end
-- }
end)
EOF

function! ReloadAlpha()
lua << EOF
    for k in pairs(package.loaded) do 
          print("k", k)

        if k:match("^chunky-code") then
          print("MATCH", k)
            package.loaded[k] = nil
        end
    end
EOF
endfunction
" Reload the plugin
nnoremap <Leader>rp :call ReloadAlpha()<CR>
" Test the plugin
" nnoremap <Leader>ptt :lua require("hello").sayHelloWorld()<CR>
nnoremap ,,r :Telescope chunky-code find repo=ryanb/dotfiles file=README.md
