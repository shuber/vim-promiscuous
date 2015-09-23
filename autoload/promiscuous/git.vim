function! promiscuous#git#checkout(unsanitized_branch)
  let l:branch = substitute(a:unsanitized_branch, '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:checkout = 'git checkout '
  let l:checkout_old = l:checkout . l:branch
  let l:checkout_new = l:checkout . '-b ' . l:branch
  let l:checkout_command = '!' . l:checkout_old . ' || ' . l:checkout_new
  silent! exec l:checkout_command
  call promiscuous#helpers#log('Checkout: ' . l:branch)
endfunction

function! promiscuous#git#commit()
  let l:commit = 'git commit -am ' . shellescape(g:promiscuous_prefix)
  silent! exec '!git add . && ' . l:commit
  call promiscuous#helpers#log('Commit')
endfunction

function! promiscuous#git#commit_pop()
  let l:commit = systemlist('git log -1 --pretty=format:%s')[0]

  if l:commit == g:promiscuous_prefix
    silent! exec '!git reset --soft HEAD~1 && git reset'
    call promiscuous#helpers#log('Commit pop')
  endif
endfunction

function! promiscuous#git#stash()
  let l:name = promiscuous#session#name()
  silent! exec '!git stash save ' . l:name . ' && git stash apply'
  call promiscuous#helpers#log('Stash')
endfunction

function! promiscuous#git#stash_pop()
  let l:name = promiscuous#session#name()
  let l:stash = systemlist('git stash list | grep ' . l:name . ' | cut -d ":" -f1')

  if type(l:stash) == type([]) && len(l:stash) > 0
    silent! exec '!git reset --hard && git stash pop --index ' . l:stash[0]
    call promiscuous#helpers#log('Stash pop')
  endif
endfunction
