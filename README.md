# [![Sean Huber](https://cloud.githubusercontent.com/assets/2419/6550752/832d9a64-c5ea-11e4-9717-6f9aa6e023b5.png)](https://github.com/shuber) vim-promiscuous

Powerful **context switching** using git and vim sessions.


## What does it do?

It basically takes a snapshot of the following:

* All of your vim tabs, buffers, splits, and folds along with their sizes and positions
* The location of your cursor for each buffer
* The actively selected tab/buffer
* Your undo history (each branch's undo history is saved separately)
* Your git stage with all tracked/untracked files and staged/unstaged hunks

When you switch to different branches using `:Promiscuous your-branch-name`, it takes a snapshot of the current branch and working directory, then checks out the new branch, and loads its corresponding snapshot if one exists.

If no snapshot exists, you are presented with a "fresh" vim instance that only has one tab and an empty buffer.

When `:Promiscuous` is called with no arguments, an `:FZF` fuzzy finder window is presented with a list of existing branches. From there we can either select an existing branch, or type out a new branch to checkout.


## Installation

Load `shuber/vim-promiscuous` using your favorite plugin manager e.g. [Vundle](https://github.com/VundleVim/Vundle.vim)

It currently depends on `:FZF`, but this dependency will be optional in the future.


## Usage

```vim
:Promiscuous [branch]
```

It's recommended to make a custom key binding for this. I've been using the following mapping:

```vim
nmap <leader>gb :Promiscuous<cr>
```

I also use an additional mapping to checkout the previous branch (usually `master`):

```vim
nmap <leader>gg :Promiscuous -<cr>
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


## How does it work?

```vim
call promiscuous#git#stash()
call promiscuous#git#commit()
call promiscuous#session#save()
call promiscuous#session#clean()
call promiscuous#git#checkout(l:branch)
call promiscuous#session#load()
call promiscuous#git#commit_pop()
call promiscuous#git#stash_pop()
```

The output below occurred when switching from `master` to `something-new` then back to `master`.

```
[Promiscuous] !clear
[Promiscuous] !(git diff --quiet && git diff --cached --quiet) || (git stash save Code_vim_promiscuous_master && git stash apply)
[Promiscuous] !git add . && git commit -am '[Promiscuous]'
[Promiscuous] mksession! /Users/Sean/.vim/promiscuous/Code_vim_promiscuous_master.vim
[Promiscuous] bufdo bd
[Promiscuous] !git checkout - || git checkout -b -
[Promiscuous] source /Users/Sean/.vim/promiscuous/Code_vim_promiscuous_something_new.vim
[Promiscuous] Checkout something-new

[Promiscuous] !clear
[Promiscuous] !(git diff --quiet && git diff --cached --quiet) || (git stash save Code_vim_promiscuous_something_new && git stash apply)
[Promiscuous] !git add . && git commit -am '[Promiscuous]'
[Promiscuous] mksession! /Users/Sean/.vim/promiscuous/Code_vim_promiscuous_something_new.vim
[Promiscuous] bufdo bd
[Promiscuous] !git checkout - || git checkout -b -
[Promiscuous] source /Users/Sean/.vim/promiscuous/Code_vim_promiscuous_master.vim
[Promiscuous] Checkout master
```


## Contributing

* Fork the project.
* Make your feature addition or bug fix.
* Commit, do not mess with the version or history.
* Send me a pull request. Bonus points for topic branches.


## License

[MIT](https://github.com/shuber/vim-promiscuous/blob/master/LICENSE) - Copyright © 2015 Sean Huber
