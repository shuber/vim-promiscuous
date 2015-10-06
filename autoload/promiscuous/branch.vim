function! promiscuous#branch#clean()
  call promiscuous#helpers#exec('bufdo bd')
endfunction

function! promiscuous#branch#search()
  call fzf#run({
  \ 'options': '--print-query',
  \ 'sink*': function('Promiscuous'),
  \ 'source': 'git branch -a'
  \ })
endfunction
