" this is to be linked to ~/.config/nvim/init.vim

let mapleader = "," " set <leader> key.
set mouse=a " enable mouse usage

set showmatch " Show matching brackets
set number  relativenumber " show number on left

set splitright " Vertical split to right of current
set splitbelow " Horizontal split below current

syntax enable " enable syntax processing
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set shiftwidth=4 " spaces per tab when >>
set expandtab

set cursorline " highlight current line
"filetype indent on      " load filetype-specific indent files
set wildmenu " visual autocomplete for command menu.
set lazyredraw          " redraw only when we need to.

if !&scrolloff
    set scrolloff=3 " show next 3 lines when scrolling
endif
if !&sidescrolloff
    set sidescrolloff=5 " show next 5 columns while side-scrolling
endif

" Tell Vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
set list                " Show problematic characters
" Highlight all tabs and trailing white spaces
" highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" match ExtraWhitespace /\s\+$/

set ignorecase " Make searching case insensitive
set smartcase " insensitive search unless has a capital char
set gdefault            " Use 'g' flag by default with :s/foo/bar/.

" clear the highlighting of :set hlsearch
nnoremap <leader><space> :nohlsearch<CR>
" set backup
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp " set the backup directory
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp " set the swap directory
set backupskip=/tmp/*,/private/tmp/* " skip these directories for backup
set writebackup

" Toggle between number and relative number
function! ToggleNumber()
    if (&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

nnoremap <leader>r :call ToggleNumber()<cr>

" move down on long lines
nnoremap j gj
nnoremap k gk
" Press <CR> to save file.
nnoremap <CR> :w!<CR>
" Use Q to execute default register.
nnoremap Q @q

" highlight last inserted text
nnoremap gV `[v`]
" edit vimrc shortcut
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
" save session
nnoremap <leader>s :mksession!<CR>

augroup mynvimrchook
    autocmd!
    " Auto reload vimrc whne it changes
    autocmd BufWritePost init.vim,.nvimrc source $MYVIMRC
    " Remove whitespaces before write
    autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
                \:call <SID>StripTrailingWhitespaces()
augroup END

" strips trailing whitespace. this
" is called on buffer write in the autogroup above.
function! StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

" Commenting
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

" Vim-Plugins
" Auto install vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'scrooloose/nerdtree'
call plug#end()

" Nerdtree config
