function! promiscuous#git#checkout(unsanitized_branch)
  let l:branch = substitute(a:unsanitized_branch, '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:checkout = 'git checkout '
  let l:checkout_old = l:checkout . l:branch
  let l:checkout_new = l:checkout . '-b ' . l:branch
  let l:checkout_command = '!' . l:checkout_old . ' || ' . l:checkout_new
  silent! exec l:checkout_command
endfunction

function! promiscuous#git#commit(...)
  if a:0 > 0
    let l:message = g:promiscuous_prefix . ' ' . a:1
  else
    let l:message = g:promiscuous_prefix
  endif

  let l:commit = '!git commit -am ' . shellescape(l:message)
  silent! exec '!git add . && ' . l:commit
  call promiscuous#helpers#log('Commit: ' . l:message)
endfunction

function! promiscuous#git#commit_pop()
  let l:commit = systemlist('git log -1 --oneline')[0]
  let l:escaped = substitute(g:promiscuous_prefix, '[', '\\[', '')
  let l:regex = substitute(l:escaped, ']', '\\]', '')

  if l:commit =~ l:regex
    silent! execute '!git reset --soft HEAD~1 && git reset'
    call promiscuous#helpers#log('Commit pop: ' . l:commit)
  endif
endfunction

function! promiscuous#git#stash()
  let l:stash = promiscuous#undo#name()
  silent! exec '!git stash save ' . l:stash . ' && git stash apply'
  call promiscuous#helpers#log('Stash: ' . l:stash)
endfunction

function! promiscuous#git#stash_pop()
  let l:name = promiscuous#undo#name()
  let l:stash = systemlist('git stash list | grep ' . l:name . ' | cut -d ":" -f1')

  if type(l:stash) == type([]) && len(l:stash) > 0
    silent! exec '!git reset --hard && git stash pop --index ' . l:stash[0]
    call promiscuous#helpers#log('Stash pop: ' . l:stash[0])
  endif
endfunction
