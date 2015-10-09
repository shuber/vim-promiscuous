function! promiscuous#tmux#refresh()
  call promiscuous#helpers#exec('![ -n "$TMUX" ] && tmux refresh-client -S')
endfunction
