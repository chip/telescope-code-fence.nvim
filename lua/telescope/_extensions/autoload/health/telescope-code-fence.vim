function! health#telescope-code-fence#check()
  " call health#report_start('sanity checks')
  if !has('nvim-0.6')
    call health#report_error("please install nvim > 0.6")
  else
    call health#report_ok("nvim 0.6 installed")
  endif
endfunction
