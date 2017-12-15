" This is to be linked to ~/.config/nvim/init.vim
" Dependencies:
" * Solarized Palette in terminal (https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized).
" * NERD fonts in terminal (https://github.com/ryanoasis/nerd-fonts#font-installation).
" * Vim-plug (https://github.com/junegunn/vim-plug).
" * ctags (`brew install ctags`)
" * the_silver_searcher (`brew install the_silver_searcher`)
" * CMake (for YouCompleteMe)
" * nvim-python `:help provider-python`
" *             & https://github.com/neovim/neovim/wiki/FAQ#python-support-isnt-working
" * Manual installation for YouCompleteMe as well.

let g:python_host_prog = '/Users/vhong/.pyenv/versions/py2nvim/bin/python'
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
    set listchars=tab:\|\ ,trail:-,extends:>,precedes:<,nbsp:+
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
    " Use space to create fold in visual mode
    vnoremap <space> zf
    " Use Q to execute default register.
    nnoremap Q @q

    " Windows keys
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-h> <C-w>h
    nnoremap <C-l> <C-w>l

    " Window resize
    nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
    nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

    nnoremap <silent> <Leader>+v :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
    nnoremap <silent> <Leader>-v :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
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
                    \ :call <SID>StripTrailingWhitespaces()
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
    function! s:StripTrailingWhitespaces()
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
    Plug 'tpope/vim-surround'
    Plug 'scrooloose/nerdcommenter' " Auto comment for different file types

    Plug 'altercation/vim-colors-solarized'
    Plug 'vim-airline/vim-airline'

    Plug 'scrooloose/nerdtree'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " Plugin to color different file ext differently.
    Plug 'majutsushi/tagbar' " Shows tags for the currently edited file.
    Plug 'ludovicchabant/vim-gutentags' " Auto-generate tag files

    Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --bin'}
    Plug 'junegunn/fzf.vim'
    Plug 'Valloric/YouCompleteMe'
    Plug 'rking/ag.vim'
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
    set background=dark

    " Using solarized color scheme.
    " Note: also need to set the terminal's color pallete to Solarized color
    " scheme, check out https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized for instructions.
    colorscheme solarized
" }}}
" NERDtree {{{
    " open a NERDTree automatically when vim starts up if no files were specified
    augroup nerdtree
        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

        " open NERDTree automatically when vim starts up on opening a directory
        autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
    augroup END

    " Shortcut to start NERDTree
    nnoremap <F3> :NERDTreeToggle<CR>
    " Show current buffer in NERDTree
    nnoremap <leader>gn :NERDTreeFind<CR>

    " Ignore certain files in NERDTree
    let NERDTreeIgnore = ['\.pyc$', 'migrations[[dir]]']
" }}}
" FZF {{{
    " Search tags.
    nnoremap <leader>. :Tags<CR>
    " Search tags under cursor.
    nnoremap <leader>> :Tags '<C-r><C-w><CR>
    " Search tags in the current buffer.
    nnoremap <leader>b :Buffers<CR>
    " Search current buffer.
    nnoremap <leader>B :BTags<CR>
    " Search in all buffers.
    nnoremap <leader>l :Lines<CR>
    " Search for files
    nnoremap <leader>f :Files<CR>
" }}}
" Vim-Airline {{{
    let g:airline_powerline_fonts = 1 " Let vim-airline uses new fonts
" }}}
" YouCompleteMe {{{
    let g:ycm_python_binary_path = 'python' " Use the first python found in $PATH

    let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
    let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
    let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
    let g:ycm_complete_in_comments = 1 " Completion in comments
    let g:ycm_complete_in_strings = 1 " Completion in string

    " Shortcuts for ycm goto commands.
    nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>
    nnoremap <leader>gr :YcmCompleter GoToReferences<CR>
" }}}
" Tagbar {{{
    " Auto focus to Tagbar when open
    let g:tagbar_autofocus = 0
    " Auto close the tagbar when hitting <CR>
    let g:tagbar_autoclose = 0

    " Toggle tagbar
    nnoremap <F7> :TagbarToggle<CR>
    " Show method/class tagbar
    nnoremap <leader>gt :TagbarShowTag<CR>
" }}}
" ag.vim {{{
    " Open a larger quickfix window
    let g:ag_qhandler = "botright copen 20"
    " Search using Silver search
    nnoremap <leader>a :Ag --ignore "tests/" ""<left>
    nnoremap <leader>at :Ag ""<left>
    " Immediately search for the word under the cursor.
    nnoremap <leader>A :Ag --ignore "tests/" "<C-r><C-w>"<CR>
    nnoremap <leader>At :Ag "<C-r><C-w>"<CR>
" }}}
" Auto-folding when open this file
set modelines=1 " Run the line below for this file only
" vim:foldmethod=marker:foldlevel=0
