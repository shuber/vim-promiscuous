function! promiscuous#branch#clean()
  silent! exec 'bufdo bd'
endfunction

function! promiscuous#branch#search()
  call promiscuous#helpers#log('Search')
  " call fzf#run({
  " \ 'options': '--print-query',
  " \ 'sink*': function('Promiscuous'),
  " \ 'source': 'git branch -a'
  " \ })
endfunction
