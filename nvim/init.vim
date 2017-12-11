" this is to be linked to ~/.config/nvim/init.vim
set mouse=a " enable mouse usage


" UI Layout {{{
set lazyredraw " redraw only when we need to.

set splitright " Vertical split to right of current
set splitbelow " Horizontal split below current

set number relativenumber " show number on left
set cursorline " highlight current line

set showmatch " Show matching brackets
set wildmenu " visual autocomplete for command menu.

if !&scrolloff
    set scrolloff=3 " show next 3 lines when scrolling
endif
if !&sidescrolloff
    set sidescrolloff=5 " show next 5 columns while side-scrolling
endif

" Tell Vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines.
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
set list " Show problematic characters
" }}}


" Spaces & Tabs {{{
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set shiftwidth=4 " spaces per tab when >>
set expandtab
" }}}


" Searching {{{
set ignorecase " Make searching case insensitive
set smartcase " insensitive search unless has a capital char
set gdefault " Use 'g' flag by default with :s/foo/bar/.
" }}}


" Key Maps {{{
" move down on long lines
nnoremap j gj
nnoremap k gk

" highlight last inserted text
nnoremap gV `[v`]

" Press <CR> to save file.
nnoremap <CR> :w!<CR>
" Use Q to execute default register.
nnoremap Q @q
" }}}


" Leader Maps {{{
let mapleader = "," " set <leader> key.

" clear the highlighting of :set hlsearch
nnoremap <leader><space> :nohlsearch<CR>

" change between relative and absolute numbering
nnoremap <leader>r :call ToggleNumber()<cr>

" save session
nnoremap <leader>s :mksession!<CR>

" edit vimrc
nnoremap <leader>ev :e $MYVIMRC<CR>
" }}}


" AutoGroups {{{
augroup my_nvimrc_hook
    autocmd!
    " Auto reload vimrc whne it changes
    autocmd BufWritePost init.vim,.nvimrc source $MYVIMRC
    " Remove whitespaces before write
    autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
                \:call <SID>StripTrailingWhitespaces()
augroup END

augroup filetype_javascript
    autocmd!
    autocmd FileType javascript nnoremap <buffer> <leader>c I//<esc>
augroup END

augroup filetype_python
    autocmd!
    autocmd FileType python nnoremap <buffer> <leader>c I#<esc>
augroup END

augroup filetype_html
    autocmd!
    autocmd FileType html setlocal nowrap
    autocmd FileType html nnoremap <buffer> <leader>f Vatzf
augroup END

" }}}


" Backups {{{
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp " set the backup directory
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp " set the swap directory
set backupskip=/tmp/*,/private/tmp/* " skip these directories for backup
set writebackup
" }}}


" Custom Functions {{{


" Toggle between number and relative number
function! ToggleNumber()
    if (&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction

" strips trailing whitespace.
function! StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction
" }}}


" Plugins {{{
" Auto install vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'scrooloose/nerdtree'
Plug 'altercation/vim-colors-solarized'
call plug#end()
" }}}


" Colorscheme {{{
syntax enable " enable syntax processing
set background=light

" Using solarized color scheme.
" Note: also need to set the terminal's color pallete to Solarized color
" scheme, check out https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized for instructions.
colorscheme solarized
" }}}


" NERDtree {{{
augroup nerdtree_configs
    autocmd vimenter * NERDTree
augroup END

nnoremap <C-n> :NERDTreeToggle<CR>
" }}}


" Auto-folding when open this file
set modelines=1 " Run the line below for this file only
" vim:foldmethod=marker:foldlevel=0
