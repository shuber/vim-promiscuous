function! promiscuous#autocomplete#branches()
  call fzf#run({
  \ 'options': '--print-query',
  \ 'sink*': function('Promiscuous'),
  \ 'source': 'git branch -a'
  \ })
endfunction
