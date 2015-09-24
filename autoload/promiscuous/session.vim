function! promiscuous#session#file()
  let l:session_name = promiscuous#session#name()
  return g:promiscuous_dir . '/' . l:session_name . '.vim'
endfunction

function! promiscuous#session#load()
  let l:session_file = promiscuous#session#file()

  if filereadable(l:session_file)
    call promiscuous#helpers#exec('source ' . l:session_file, 0)
  else
    call promiscuous#session#save()
  endif
endfunction

function! promiscuous#session#name()
  let l:git_branch = systemlist('git symbolic-ref --short HEAD')[0]
  let l:session_name = getcwd() . '/' . l:git_branch
  let l:stripped = substitute(l:session_name, $HOME . '/', '', '')
  return promiscuous#helpers#dasherize(l:stripped)
endfunction

function! promiscuous#session#save()
  let l:session_file = promiscuous#session#file()
  call promiscuous#helpers#mkdir(g:promiscuous_dir)
  call promiscuous#undo#save()
  call promiscuous#helpers#exec('mksession! ' . l:session_file, 0)
endfunction
