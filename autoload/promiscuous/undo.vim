function! promiscuous#undo#name()
  let l:session_file = promiscuous#session#file()
  return promiscuous#helpers#dasherize(l:session_file)
endfunction

function! promiscuous#undo#save()
  let l:undo_name = promiscuous#undo#name()
  let l:undo_dir = g:promiscuous_dir . '/' . l:undo_name
  call promiscuous#helpers#mkdir(l:undo_dir)
  let &undodir = l:undo_dir
  set undofile
endfunction
