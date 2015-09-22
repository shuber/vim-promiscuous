set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize
set undolevels=1000
set undoreload=10000

let g:promiscuous_dir = $HOME . '/.vim/promiscuous'

function! promiscuous#dasherize(path)
  return substitute(a:path, '\W', '_', 'g')
endfunction

function! promiscuous#log(message)
  echom '[Promiscuous] ' a:message
endfunction

function! promiscuous#mkdir(dir)
  if (filewritable(a:dir) != 2)
    exec 'silent !mkdir -p ' a:dir
    redraw!
  endif
endfunction

function! promiscuous#persist_undo(session_file)
  let l:undo_dir = promiscuous#dasherize(a:session_file)
  let l:undo_path = g:promiscuous_dir . '/' . l:undo_dir
  call promiscuous#mkdir(l:undo_path)
  let &undodir = l:undo_path
  set undofile
endfunction

function! promiscuous#session_file()
  let l:git_branch = systemlist('git symbolic-ref --short HEAD')[0]
  let l:session_name = getcwd() . '/' . l:git_branch
  let l:session_path = promiscuous#dasherize(l:session_name) . '.vim'
  let l:session_file = g:promiscuous_dir . '/' . l:session_path
  return l:session_file
endfunction

function! promiscuous#session_load()
  let l:session_file = promiscuous#session_file()

  if (filereadable(l:session_file))
    exec 'source ' l:session_file
  else
    call promiscuous#session_save()
  endif

  call promiscuous#log('Loaded session ' l:session_file)
endfunction

function! promiscuous#session_save()
  let l:session_file = promiscuous#session_file()
  call promiscuous#mkdir(g:promiscuous_dir)
  call promiscuous#persist_undo(l:session_file)
  exec 'mksession! ' . l:session_file
  call promiscuous#log('Saved session ' . l:session_file)
endfunction
