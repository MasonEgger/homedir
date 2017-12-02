set cmdheight=2
set hlsearch
set expandtab
set ts=4
set number
colorscheme zellner
syntax on
execute pathogen#infect()
autocmd BufWritePost *.py call Flake8()
autocmd vimenter * NERDTree
let NERDTreeIgnore = ['\.pyc$']
