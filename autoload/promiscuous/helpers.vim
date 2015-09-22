function! promiscuous#helpers#dasherize(path)
  return substitute(a:path, '\W', '_', 'g')
endfunction

function! promiscuous#helpers#log(message)
  echom g:promiscuous_prefix a:message
endfunction

function! promiscuous#helpers#mkdir(dir)
  if (filewritable(a:dir) != 2)
    silent! exec '!mkdir -p ' . a:dir
  endif
endfunction
