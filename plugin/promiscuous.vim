set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize
set undolevels=1000
set undoreload=10000

let g:promiscuous_dir = $HOME . '/.vim/promiscuous'

command! -nargs=? Promiscuous :call Promiscuous(<f-args>)

function! Promiscuous(...)
  if a:0 > 0
    if type(a:1) == type([])
      let l:branch = a:1[-1]
    else
      let l:branch = a:1
    endif

    call promiscuous#session_save()

    if promiscuous#git_checkout(l:branch)
      exec 'bufdo bd'
      call promiscuous#session_load()
    endif

    redraw!
  else
    call promiscuous#search()
  endif
endfunction

function! promiscuous#git_checkout(unsanitized_branch)
  let l:branch = substitute(a:unsanitized_branch, '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:checkout = 'git checkout '
  let l:checkout_old = l:checkout . l:branch
  let l:checkout_new = l:checkout . '-b ' . l:branch
  let l:checkout_command = '!' . l:checkout_old . ' || ' . l:checkout_new
  silent! exec l:checkout_command
endfunction

function! promiscuous#persist_undo(session_file)
  let l:undo_dir = promiscuous#helpers#dasherize(a:session_file)
  let l:undo_path = g:promiscuous_dir . '/' . l:undo_dir
  call promiscuous#helpers#mkdir(l:undo_path)
  let &undodir = l:undo_path
  set undofile
endfunction

function! promiscuous#search()
  call fzf#run({
  \ 'options': '--print-query',
  \ 'sink*': function('Promiscuous'),
  \ 'source': 'git branch -a'
  \ })
endfunction

function! promiscuous#session_file()
  let l:git_branch = systemlist('git symbolic-ref --short HEAD')[0]
  let l:session_name = getcwd() . '/' . l:git_branch
  let l:session_path = promiscuous#helpers#dasherize(l:session_name) . '.vim'
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
  call promiscuous#helpers#mkdir(g:promiscuous_dir)
  call promiscuous#persist_undo(l:session_file)
  exec 'mksession! ' . l:session_file
  call promiscuous#log('Saved session ' . l:session_file)
endfunction

function! promiscuous#helpers#dasherize(path)
  return substitute(a:path, '\W', '_', 'g')
endfunction

function! promiscuous#helpers#log(message)
  echom '[Promiscuous] ' a:message
endfunction

function! promiscuous#helpers#mkdir(dir)
  if (filewritable(a:dir) != 2)
    exec 'silent !mkdir -p ' a:dir
    redraw!
  endif
endfunction
