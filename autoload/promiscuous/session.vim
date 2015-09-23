function! promiscuous#session#file()
  let l:git_branch = systemlist('git symbolic-ref --short HEAD')[0]
  let l:session_name = getcwd() . '/' . l:git_branch
  let l:session_path = promiscuous#helpers#dasherize(l:session_name) . '.vim'
  let l:session_file = g:promiscuous_dir . '/' . l:session_path
  return l:session_file
endfunction

function! promiscuous#session#load()
  let l:session_file = promiscuous#session#file()

  if (filereadable(l:session_file))
    silent! exec 'source ' . l:session_file
  else
    call promiscuous#session#save()
  endif

  call promiscuous#helpers#log('Loaded session ' . l:session_file)
endfunction

function! promiscuous#session#save()
  let l:session_file = promiscuous#session#file()
  call promiscuous#helpers#mkdir(g:promiscuous_dir)
  call promiscuous#undo#save()
  silent! exec 'mksession! ' . l:session_file
  call promiscuous#helpers#log('Saved session ' . l:session_file)
endfunction
