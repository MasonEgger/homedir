set cmdheight=2
set backspace=2
set hlsearch
set number
set ruler
set cc=80
set expandtab
set ts=4
colorscheme zellner
syntax on
execute pathogen#infect()
autocmd BufWritePost *.py call Flake8()
filetype plugin on
autocmd vimenter * NERDTree
let NERDTreeIgnore = ['\.pyc$']
