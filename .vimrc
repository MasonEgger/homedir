set cmdheight=2
set hlsearch
set number
colorscheme zellner
syntax on
execute pathogen#infect()
autocmd BufWritePost *.py call Flake8()
autocmd vimenter * NERDTree
autocmd FileType python set expandtab|set ts=4
autocmd FileType go set noexpandtab|set tabstop=4
let NERDTreeIgnore = ['\.pyc$']
