function! promiscuous#branch#clean()
  silent! exec 'bufdo bd'
  call promiscuous#helpers#log('Clean')
endfunction

function! promiscuous#branch#search()
  call fzf#run({
  \ 'options': '--print-query',
  \ 'sink*': function('Promiscuous'),
  \ 'source': 'git branch -a'
  \ })
endfunction
