set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize
set undolevels=1000
set undoreload=10000

if !exists('g:promiscuous_dir')
  " The directory to store all sessions and undo history
  let g:promiscuous_dir = $HOME . '/.vim/promiscuous'
endif

if !exists('g:promiscuous_load')
  " The callback used to load a session
  let g:promiscuous_load = 'promiscuous#session#load'
endif

if !exists('g:promiscuous_prefix')
  " The prefix prepended to all commit, stash, and log messages
  let g:promiscuous_prefix = '[Promiscuous]'
endif

if !exists('g:promiscuous_save')
  " The callback used to save a session
  let g:promiscuous_save = 'promiscuous#session#save'
endif

if !exists('g:promiscuous_verbose')
  " Log all executed commands with echom
  let g:promiscuous_verbose = 0
endif

command! -nargs=? Promiscuous :call Promiscuous(<f-args>)

function! Promiscuous(...)
  if a:0 > 0
    if type(a:1) == type([])
      let l:branch = a:1[-1]
    else
      let l:branch = a:1
    endif

    call promiscuous#helpers#clear()
    call promiscuous#git#stash()
    call promiscuous#git#commit()

    let l:branch_was = promiscuous#git#branch()
    call call(g:promiscuous_save, [l:branch_was], {})

    call promiscuous#session#clean()
    call promiscuous#git#checkout(l:branch)

    let l:branch = promiscuous#git#branch()
    call call(g:promiscuous_load, [l:branch], {})

    call promiscuous#git#commit_pop()
    call promiscuous#git#stash_pop()
    call promiscuous#tmux#refresh()

    call promiscuous#helpers#log(l:branch_was . ' to ' . l:branch)

    redraw!
  else
    call promiscuous#autocomplete#branches()
  endif
endfunction
