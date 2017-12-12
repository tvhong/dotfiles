" This is to be linked to ~/.config/nvim/init.vim
" Dependencies:
" * Solarized Palette in terminal (https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized).
" * NERD fonts in terminal (https://github.com/ryanoasis/nerd-fonts#font-installation).
" * Vim-plug (https://github.com/junegunn/vim-plug).
" * ctags (`brew install ctags`)
" * the_silver_searcher (`brew install the_silver_searcher`)

" UI Layout {{{
    set mouse=a " enable mouse usage
    set lazyredraw " redraw only when we need to.
    set encoding=utf8
    set guifont=FuraCode_Nerd_Font:h11 " install font from https://github.com/ryanoasis/nerd-fonts & enable in iTerm

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
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
    set list " Show problematic characters
" }}}
" Spaces & Tabs {{{
    set softtabstop=4 " number of spaces when TAB is typed
    set shiftwidth=4 " spaces per tab when >>
    set tabstop=4 " number of visual spaces per TAB
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

    " Use space to trigger folding
    nnoremap <space> za

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
        " Auto reload vimrc when it changes
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
    Plug 'vim-airline/vim-airline'
    Plug 'scrooloose/nerdtree'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " Plugin to color different file ext differently.
    Plug 'altercation/vim-colors-solarized'
    Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --bin'}
    Plug 'junegunn/fzf.vim'
    Plug 'tmhedberg/simpylfold'
    " Plug "LustyExplorer"
    " Plug 'vim-syntastic/syntastic'
    " virtualenv
    " YCM
    " silver search
    " Snippet
    " Note: Has dependency on ryanoasis/nerd-fonts
    Plug 'ryanoasis/vim-devicons' " Should stay at the end for other plugins to use
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
    nnoremap <C-n> :NERDTreeToggle<CR>

    " open a NERDTree automatically when vim starts up if no files were specified
    augroup nerdtree
        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

        " open NERDTree automatically when vim starts up on opening a directory
        autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
    augroup END
" }}}
" FZF {{{
    " Search tags.
    nnoremap <leader>. :Tags<CR>
    " Search tags under cursor.
    nnoremap <leader>> :Tags <C-r><C-w><CR>
    " Search tags in the current buffer.
    nnoremap <leader>B :BTags<CR>
    " Search current buffer.
    nnoremap <leader>b :BLines<CR>
    " Search in all buffers.
    nnoremap <leader>l :Lines<CR>
    " Search for files
    nnoremap <leader>f :Files<CR>

    " Search using Silver search
    nnoremap <leader>a :Ag 
    " Immediately search for the word under the cursor.
    nnoremap <leader>A :Ag <C-r><C-w><CR>
" }}}
" Vim-Airline {{{
    let g:airline_powerline_fonts = 1 " Let vim-airline uses new fonts
" }}}
" Auto-folding when open this file
set modelines=1 " Run the line below for this file only
" vim:foldmethod=marker:foldlevel=0
