function! promiscuous#helpers#clear()
  call promiscuous#helpers#exec('!clear')
endfunction

function! promiscuous#helpers#dasherize(path)
  return substitute(a:path, '\W', '_', 'g')
endfunction

function! promiscuous#helpers#exec(command, ...)
  if a:0 > 0
    let s:verbose = a:1
  else
    let s:verbose = g:promiscuous_verbose
  endif

  if s:verbose
    call promiscuous#helpers#log(a:command)
  endif

  silent exec a:command
endfunction

function! promiscuous#helpers#log(message)
  echom g:promiscuous_prefix a:message
endfunction

function! promiscuous#helpers#mkdir(dir)
  if filewritable(a:dir) != 2
    call promiscuous#helpers#exec('!mkdir -p ' . a:dir)
  endif
endfunction
