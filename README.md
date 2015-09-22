# [![Sean Huber](https://cloud.githubusercontent.com/assets/2419/6550752/832d9a64-c5ea-11e4-9717-6f9aa6e023b5.png)](https://github.com/shuber) vim-promiscuous

Powerful **context switching** using git and vim sessions.


## Installation

Load `shuber/vim-promiscuous` using your favorite plugin manager e.g. [Vundle](https://github.com/VundleVim/Vundle.vim)


## Usage

```vim
:Promiscuous [branch]
```


## Configuration

These are the defaults. Feel free to override them.

```vim
let g:promiscuous_dir = $HOME . '/.vim/promiscuous'
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
