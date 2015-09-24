function! promiscuous#helpers#dasherize(path)
  return substitute(a:path, '\W', '_', 'g')
endfunction

function! promiscuous#helpers#exec(cmd, ...)
  if a:0 > 0
    let s:command = a:cmd
  else
    let s:command = '!' . a:cmd
  endif

  call promiscuous#helpers#log(s:command)
  exec s:command
endfunction

function! promiscuous#helpers#log(message)
  echom g:promiscuous_prefix a:message
endfunction

function! promiscuous#helpers#mkdir(dir)
  if filewritable(a:dir) != 2
    call promiscuous#helpers#exec('mkdir -p ' . a:dir)
  endif
endfunction
