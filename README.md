# [![Sean Huber](https://cloud.githubusercontent.com/assets/2419/6550752/832d9a64-c5ea-11e4-9717-6f9aa6e023b5.png)](https://github.com/shuber) vim-promiscuous

Instant **context switching** using git and vim sessions.


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

If you're using [tmux](https://tmux.github.io/) then your status line will automatically refresh when `:Promiscuous` checks out a branch. This is very convenient when you display [git information in your status line](https://github.com/shuber/tmux-git).

By default, if calling `:Promiscuous new-branch-name` with a not
existing branch, Promiscuous will create that branch as if you executed
`git checkout new-branch-name`. An option allows you to execute instead
`git checkout -b new-branch-name origin/master` and even
`git fetch; git checkout -b new-branch-name origin/master`.

Similar projects:

* http://www.eclipse.org/mylyn/
* https://github.com/szw/vim-ctrlspace


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

" The callback used to load a session (receives branch name)
let g:promiscuous_load = 'promiscuous#session#load'

" The prefix prepended to all commit, stash, and log messages
let g:promiscuous_prefix = '[Promiscuous]'

" The callback used to save a session (receives branch name)
let g:promiscuous_save = 'promiscuous#session#save'

" Log all executed commands with echom
let g:promiscuous_verbose = 0

" The callback used to determine which base to create a new branch on
let g:promiscuous_base_branch = 'promiscuous#git#basebranchcurrentbranch'
" let g:promiscuous_base_branch = 'promiscuous#git#basebranchoriginmaster'
" let g:promiscuous_base_branch = 'promiscuous#git#basebranchlatestoriginmaster'
```

```vim
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize
set undolevels=1000
set undoreload=10000
```


## How does it work?

```vim
call promiscuous#helpers#clear()
call promiscuous#git#stash()
call promiscuous#git#commit()

let l:branch_was = promiscuous#git#branch()
call call(g:promiscuous_save, [l:branch_was], {})

call promiscuous#session#clean()
call promiscuous#git#checkout(l:branch)

let l:branch = promiscuous#git#branch()
call call(g:promiscuous_load, [l:branch], {})

call promiscuous#git#commit_pop()
call promiscuous#git#stash_pop()
call promiscuous#tmux#refresh()
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
