set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize
set undolevels=1000
set undoreload=10000

if !exists('g:promiscuous_dir')
  " The directory to store all sessions and undo history
  let g:promiscuous_dir = $HOME . '/.vim/promiscuous'
endif

if !exists('g:promiscuous_prefix')
  " The prefix prepended to all commit, stash, and log messages
  let g:promiscuous_prefix = '[Promiscuous]'
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
    call promiscuous#session#save()
    call promiscuous#session#clean()
    call promiscuous#git#checkout(l:branch)
    call promiscuous#session#load()
    call promiscuous#git#commit_pop()
    call promiscuous#git#stash_pop()

    redraw!

    let l:checkout = promiscuous#git#branch()
    call promiscuous#helpers#log('Checkout ' . l:checkout, 1)
  else
    call promiscuous#autocomplete#branches()
  endif
endfunction

silent! call promiscuous#session#save()
