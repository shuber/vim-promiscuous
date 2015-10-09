function! promiscuous#git#branch()
  return systemlist('git symbolic-ref --short HEAD')[0]
endfunction

function! promiscuous#git#checkout(unsanitized_branch)
  let l:branch = substitute(a:unsanitized_branch, '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:checkout = 'git checkout '
  let l:checkout_old = l:checkout . l:branch
  let l:checkout_new = l:checkout . '-b ' . l:branch
  let l:checkout_command = '!' . l:checkout_old . ' || ' . l:checkout_new
  call promiscuous#helpers#exec(l:checkout_command)
endfunction

function! promiscuous#git#commit()
  let l:commit = 'git commit -am ' . shellescape(g:promiscuous_prefix)
  call promiscuous#helpers#exec('!git add . && ' . l:commit)
endfunction

function! promiscuous#git#commit_pop()
  let l:commit = systemlist('git log -1 --pretty=format:%s')[0]

  if l:commit == g:promiscuous_prefix
    call promiscuous#helpers#exec('!git reset --soft HEAD~1 && git reset')
  endif
endfunction

function! promiscuous#git#stash()
  let l:name = promiscuous#session#name()
  let l:clean = '(git diff --quiet && git diff --cached --quiet)'
  let l:stash = '(git stash save ' . l:name . ' && git stash apply)'
  call promiscuous#helpers#exec('!' . l:clean . ' || ' . l:stash)
endfunction

function! promiscuous#git#stash_pop()
  let l:name = promiscuous#session#name()
  let l:stash = systemlist('git stash list | grep ' . l:name . ' | cut -d ":" -f1')

  if type(l:stash) == type([]) && len(l:stash) > 0
    call promiscuous#helpers#exec('!git reset --hard && git stash pop --index ' . l:stash[0])
  endif
endfunction
