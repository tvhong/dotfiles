"Syntax check
syntax on

"indent and format
"set smartindent 
set expandtab 
set shiftwidth=4
set softtabstop=4
set number

"searching
set ignorecase
set smartcase
set hlsearch
set nocompatible               " be iMproved

"editing
set backspace=2

"nice command line stuff
"nmap ; q:

" Map moving inline
"nmap H ^
"nmap L $

filetype off                   " filetype recognition off

"Syntastic stuffs
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_always_populate_loc_list=1  " need this to update loclist
"let g:syntastic_auto_loc_list=1 "1 makes locator auto appear
let g:syntastic_loc_list_height=5

"YouCompleteMe stuffs
"let g:ycm_filetype_blacklist = {'text':0}
"
"Vundle commands here
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'Valloric/YouCompleteMe'
Bundle 'Lokaltog/vim-powerline'
Bundle 'tpope/vim-surround'
Bundle 'scrooloose/syntastic'

filetype plugin indent on     " required!

" Indent differently for html files
autocmd FileType html setlocal shiftwidth=2 tabstop=2
