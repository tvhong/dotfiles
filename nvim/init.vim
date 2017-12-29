" This is to be linked to ~/.config/nvim/init.vim
" Dependencies:
" * Solarized Palette in terminal (https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized).
" * NERD fonts in terminal (https://github.com/ryanoasis/nerd-fonts#font-installation).
" * Vim-plug (https://github.com/junegunn/vim-plug).
" * Universal ctags
" * the_silver_searcher (`brew install the_silver_searcher`)
" * Manual installation for YouCompleteMe as well.
    " * CMake (for YouCompleteMe)
    " * nvim-python `:help provider-python`
    " *             & https://github.com/neovim/neovim/wiki/FAQ#python-support-isnt-working
" * Prospector for linting (`pip install prospector`)
" * Isort for python sorting.

" Assume that python 2 host prog is installed by `pyenv virtualenv 2.7.14 py2nvim`
let g:python_host_prog = join([$HOME, '.pyenv/versions/py2nvim/bin/python'], '/')
" UI Layout {{{
    set mouse=a " enable mouse usage
    set lazyredraw " redraw only when we need to.
    set encoding=utf8
    set guifont=FuraCode_Nerd_Font:h11 " install font from https://github.com/ryanoasis/nerd-fonts & enable in iTerm

    set splitright " Vertical split to right of current
    set splitbelow " Horizontal split below current

    set number " show number on left
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
    set noexpandtab
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

    " Shortcut for :
    nnoremap ; :

    " Delete buffer
    nnoremap <leader>q :bd<CR>

    " Map Y to copy till EOL (like D & C)
    nnoremap Y y$
    " Yank all to clipboard
    nnoremap <Leader>ya :%y+<CR>

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
    nnoremap <silent> <Leader>w+ :exe "resize " . (winheight(0) * 3/2)<CR>
    nnoremap <silent> <Leader>w- :exe "resize " . (winheight(0) * 2/3)<CR>

    nnoremap <silent> <Leader>w> :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
    nnoremap <silent> <Leader>w< :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
" }}}
" Leader Maps {{{
    let mapleader = "," " set <leader> key.

    " Remap goto start and goto end
    nnoremap B ^
    nnoremap E $

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
    " General editing plugins
    Plug 'tpope/vim-surround'
    Plug 'scrooloose/nerdcommenter' " Auto comment for different file types

    " Layout plugins
    Plug 'altercation/vim-colors-solarized'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes', {'do': ':AirlineTheme solarized'}
    Plug 'ap/vim-css-color'

    Plug 'scrooloose/nerdtree'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " Plugin to color different file ext differently.
    Plug 'majutsushi/tagbar' " Shows tags for the currently edited file.
    Plug 'ludovicchabant/vim-gutentags' " Auto-generate tag files

    Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --bin'}
    Plug 'junegunn/fzf.vim'  " Fuzzy search for files, tags, buffer, e.t.c
    Plug 'Valloric/YouCompleteMe'
    Plug 'w0rp/ale' " Linting engine.
    Plug 'rking/ag.vim'
    Plug 'qpkorr/vim-bufkill'
    Plug 'yuttie/comfortable-motion.vim' " For a smoother scrolling experience.

    " Plugins for Javascript
    Plug 'pangloss/vim-javascript'
    Plug 'docunext/closetag.vim' " Use <C-_> to close HTML/XML tags
    Plug 'gregsexton/matchtag' " Highlight matching HTML/XML tag

    " Plugins for Ember
    Plug 'joukevandermaas/vim-ember-hbs'

    " Snippet?
    " Git integration
    " Note: Has dependency on ryanoasis/nerd-fonts
    Plug 'ryanoasis/vim-devicons' " Should stay at the end for other plugins to use
    call plug#end()
" }}}
" Solarized colorscheme {{{
    syntax enable " enable syntax processing
    set background=dark

    " Using solarized color scheme.
    " Note: also need to set the terminal's color pallete to Solarized color
    " scheme, check out https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized for instructions.
    colorscheme solarized
" }}}
" NERDtree {{{
    augroup nerdtree
        " open a NERDTree automatically when vim starts up if no files were specified
        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

        " open NERDTree automatically when vim starts up on opening a directory
        autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
    augroup END

    " Remap NERDTree menu key so we can still use marking.
    let NERDTreeMapMenu = 'M'
    " Remap NERDTree next/prev sibling keys
    let NERDTreeMapJumpNextSibling = '<C-n>'
    let NERDTreeMapJumpPrevSibling = '<C-p>'
    " Remap NERDTree split keys
    let NERDTreeMapOpenSplit = '<C-h>'
    let NERDTreeMapPreviewSplit = 'gh'
    let NERDTreeMapOpenVSplit = '<C-v>'
    let NERDTreeMapPreviewVSplit = 'gv'
    " Remap help key
    let NERDTreeMapHelp = 'H'

    " Ignore certain files in NERDTree.
    let NERDTreeIgnore=['\~$', '\.swp$', '\.pyc$', '\.lock', 'migrations[[dir]]', 'node_modules[[dir]]', 'bower_components[[dir]]']
    " List py files before directories.
    let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\~$']
    " Show bookmarks don't list by default.
    let NERDTreeShowBookmarks=0

    " Shortcut to start NERDTree
    nnoremap <leader>wn :NERDTreeToggle<CR>
    " Show current buffer in NERDTree
    nnoremap <leader>gn :NERDTreeFind<CR>
    " Bookmark to NERDTree
    nnoremap <leader>bn :Bookmark<CR>
" }}}
" FZF {{{
    " Search tags.
    nnoremap <leader>. :Tags<CR>
    " Search tags under cursor.
    nnoremap <leader>> :Tags '<C-r><C-w> <CR>
    " Search tags in the current buffer.
    nnoremap <leader>bb :Buffers<CR>
    " Search current buffer.
    nnoremap <leader>bt :BTags<CR>
    " Search in all buffers.
    nnoremap <leader>bl :Lines<CR>
    " Search for files in git repo (ignore .gitignores)
    nnoremap <leader>f :GFiles<CR>
    " Normal file search
    nnoremap <leader>F :Files<CR>
    " Remap splitting key bindings
    let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-h': 'split',
      \ 'ctrl-v': 'vsplit' }
" }}}
" Vim-Airline {{{
    " Note, if ever need to customize airline's section, see
    " :help airline-section
    let g:airline_powerline_fonts = 1 " Let vim-airline uses new fonts
    " Set solarized theme (Need :AirlineTheme solarized) before this has effect.
    let g:airline_solarized_bg='dark'

    " Enable tabline when there's no window
    let g:airline#extensions#tabline#enabled = 1

    augroup vim_airline_config
        autocmd!
        autocmd VimEnter * AirlineTheme solarized
    augroup END
" }}}
" YouCompleteMe {{{
    " Remember to add the project dir to PYTHONPATH so that jedi can find the
    " definition.
    let g:ycm_python_binary_path = 'python' " Use the first python found in $PATH

    let g:ycm_auto_trigger = 1 " Make sure auto trigger is on
    " Control threshold for ID-based suggestion.
    " Use high number (e.g. 99) to turn off ID-based suggestion and leave semantic completion
    let g:ycm_min_num_of_chars_for_completion = 99
    " let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
    let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
    let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
    let g:ycm_complete_in_comments = 1 " Completion in comments
    let g:ycm_complete_in_strings = 1 " Completion in string
    let g:ycm_max_num_candidates = 50 " Limit the # of candidates from semantic completion suggestion

    " Shortcuts for ycm goto commands.
    nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>
    nnoremap <leader>gr :YcmCompleter GoToReferences<CR>
    nnoremap <leader>gp :YcmCompleter GetDoc<CR> " go peek
" }}}
" Tagbar {{{
    " Whether to auto focus to Tagbar when open
    let g:tagbar_autofocus = 1
    " Whether to auto close the tagbar when hitting <CR>
    let g:tagbar_autoclose = 0
    " Disable tag sorting
    let g:tagbar_sort = 0

    " Toggle tagbar
    nnoremap <leader>wt :TagbarToggle<CR>
    " Show method/class tagbar
    nnoremap <leader>gt :TagbarShowTag<CR>
" }}}
" ag.vim {{{
    " Open a larger quickfix window
    let g:ag_qhandler = "botright copen 20"
    " Highlight result (not working!)
    let g:ag_highlight = 1
    " Specify the default ag options
    let g:ag_prg = "ag --column --nogroup --noheading --ignore '*.pyc'"

    " Search using Silver search
    nnoremap <leader>a :Ag! --ignore "tests*.py" --ignore "tags" 
    nnoremap <leader>at :Ag! --ignore "tags" 
    " Immediately search for the word under the cursor.
    nnoremap <leader>A :Ag! --ignore "test*.py" --ignore "tags" --word "<C-r><C-w>"<CR>
    nnoremap <leader>At :Ag! --ignore "tags" --word "<C-r><C-w>"<CR>
" }}}
" ALE {{{
    let g:ale_linters = {
                \   'python': ['pyflakes', 'prospector'],
                \}
    " Go to previous error and next error. Can't use nnoremap.
    nmap <silent> <C-p> <Plug>(ale_previous_wrap)
    nmap <silent> <C-n> <Plug>(ale_next_wrap)

    " ALEFix configurations. See :ALEFixSuggest.
    let g:ale_fixers = {
                \   'python': [
                \       'isort',
                \       'yapf',
                \   ],
                \}
    " Auto-run ALEFix on save.
    let g:ale_fix_on_save = 1

    " Don't run linters when coding
    let g:ale_lint_on_text_changed = 'never'
    " Don't run linters on opening a file
    let g:ale_lint_on_enter = 0
" }}}
" BufKill {{{
    " Kill buffer without removing the window
    nnoremap <leader>d :BD<CR>
" }}}
" TODO: Make braces matching and autoclosing working for hbs files
" Auto-folding when open this file
set modelines=1 " Run the line below for this file only
" vim:foldmethod=marker:foldlevel=0
