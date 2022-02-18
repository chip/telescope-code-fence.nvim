echo "lua/telescope/_extensions/plugin/telescope-code-fence.vim"
if exists('g:loaded_telescope_code_fence') | finish | endif " prevent loading file twice
let s:save_cpo = &cpo " save user coptions
set cpo&vim           " reset them to defaults
" command to run our plugin
command! TelescopeCodeFence lua require("telescope-code-fence.main").find()
let &cpo = s:save_cpo " and restore after
unlet s:save_cpo
let g:loaded_telescope_code_fence = 1
