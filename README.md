# [![Sean Huber](https://cloud.githubusercontent.com/assets/2419/6550752/832d9a64-c5ea-11e4-9717-6f9aa6e023b5.png)](https://github.com/shuber) vim-promiscuous

Powerful **context switching** using git and vim sessions.


## Installation

Load `shuber/vim-promiscuous` using your favorite plugin manager e.g. [Vundle](https://github.com/VundleVim/Vundle.vim)


## Usage

```vim
:Promiscuous [branch]
```


## How does it work?

```vim
call promiscuous#git#stash()
call promiscuous#git#commit()
call promiscuous#session#save()
call promiscuous#branch#clean()
call promiscuous#git#checkout(l:branch)
call promiscuous#session#load()
call promiscuous#git#commit_pop()
call promiscuous#git#stash_pop()
```


## Configuration

These are the defaults. Feel free to override them.

```vim
" The directory to store all sessions and undo history
let g:promiscuous_dir = $HOME . '/.vim/promiscuous'

" The prefix prepended to all commit, stash, and log messages
let g:promiscuous_prefix = '[Promiscuous]'

" Log all executed commands with echom
let g:promiscuous_verbose = 0
```

```vim
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize
set undolevels=1000
set undoreload=10000
```


## Contributing

* Fork the project.
* Make your feature addition or bug fix.
* Commit, do not mess with the version or history.
* Send me a pull request. Bonus points for topic branches.


## License

[MIT](https://github.com/shuber/vim-promiscuous/blob/master/LICENSE) - Copyright © 2015 Sean Huber
