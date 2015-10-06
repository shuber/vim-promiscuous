function! promiscuous#undo#save()
  let l:undo_name = promiscuous#session#name()
  let l:undo_dir = g:promiscuous_dir . '/' . l:undo_name
  call promiscuous#helpers#mkdir(l:undo_dir)

  set noundofile
  let &undodir = l:undo_dir
  set undofile
endfunction
