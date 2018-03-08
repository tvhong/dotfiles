" This is to be linked to ~/.config/nvim/init.vim
" Dependencies:
" * Prospector for linting (`pip install prospector` in the project's venv).
" * Isort for python sorting (`pip install isort` in the project's venv).

" Dependencies {{{
    " Vim Plug:
    " - Website: https://github.com/junegunn/vim-plug
    " - Installation: https://github.com/junegunn/vim-plug#neovim

    " Solarized Palette:
    " - Website: http://ethanschoonover.com/solarized
    " - Installation:
    "   + iterm2: https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized
    "   + Gnome Terminal: Right click > Profile > Profile Preferences > Colours.
    "                     Select built-in Solarized themes.

    " NERD Fonts:
    " - Website: https://github.com/ryanoasis/nerd-fonts
    " - Installation: https://github.com/ryanoasis/nerd-fonts#font-installation

    " The Silver Searcher:
    " - Website: https://github.com/ggreer/the_silver_searcher
    " - Installation:
    "   + MacOS: `brew install the_silver_searcher`
    "   + Ubuntu: `apt install silversearcher-ag`

    " Universal Ctags:
    " - Website: https://ctags.io/
    " - Installation:
    "   + MacOS: https://github.com/universal-ctags/homebrew-universal-ctags
    "   + Ubuntu: https://askubuntu.com/a/836521/69234

    " Python2 Support For NeoVim:
    " Assumed that python 2 host executible is installed by:
    " $ pyenv virtualenv 2.7.14 py2nvim
    " $ pyenv activate py2nvim
    " $ pip install neovim

    " Specify the python path:
    let g:python_host_prog = join([$HOME, '.pyenv/versions/py2nvim/bin/python'], '/')

    " YouCompleteMe:
    " - Website: https://github.com/Valloric/YouCompleteMe/
    " - Installation:
    "   + :PlugInstall to download YCM. If it times out, might need increase
    "   vim-plug timeout.
    "   + Enable Python2 support for NeoVim.
    "   + Compile YCM (https://github.com/Valloric/YouCompleteMe/#installation).

    " Linters:
    " Linters defined in g:ale_linters are assumed to available in $PATH.
    " This can be done by activating the python virtualenv or prepend
    " <project-path>/node_modules/.bin to $PATH
" }}}
" General Configs {{{
    set autoread
" }}}
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

    " No folding by default. Press zi to enable folding.
    set nofoldenable

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
    " Map <leader> key.
    let mapleader = ","

    " Move down on long lines.
    nnoremap j gj
    nnoremap k gk

    " Shortcut for :
    nnoremap ; :
    nnoremap q; q:
    vnoremap ; :

    " Delete buffer and close the window.
    nnoremap <leader>qc :bd!<CR>

    " Close window.
    nnoremap <leader>wq :q<CR>

    " Map Y to copy till EOL (like D & C).
    nnoremap Y y$
    " Yank all to clipboard.
    nnoremap <leader>ya :%y+<CR>

    " Highlight last inserted text.
    nnoremap gV `[v`]

    " Use space to trigger folding.
    nnoremap <space> za
    " Use space to create fold in visual mode.
    vnoremap <space> zf
    " Use Q to execute default register.
    nnoremap Q @q

    " Get file name.
    nnoremap <leader>@ :echo @%<CR>

    " Copy file name to clipboard
    nnoremap <leader>c@ :let @+ = @%<CR>

    " Windows keys.
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-h> <C-w>h
    nnoremap <C-l> <C-w>l

    " Remap goto start and goto end.
    nnoremap B ^
    nnoremap E $

    " Clear the highlighting of :set hlsearch.
    nnoremap <leader><space> :nohlsearch<CR>

    " Change between relative and absolute numbering.
    nnoremap <leader>r :call ToggleNumber()<cr>

    " Save session.
    nnoremap <leader>s :mksession!<CR>

    " Edit vimrc.
    nnoremap <leader>ev :e $MYVIMRC<CR>
" }}}
" AutoGroups {{{
    augroup my_nvimrc_hook
        autocmd!
        " Auto reload vimrc when it changes.
        autocmd BufWritePost init.vim,.nvimrc source $MYVIMRC
        autocmd BufRead,BufEnter *.tmux.conf set syntax=tmux
        autocmd BufRead,BufEnter bashrc,bash_logout,bash_aliases set syntax=sh
    augroup END

    augroup clean_whitespaces_on_write
        autocmd!
        " Remove whitespaces before write.
        autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
                    \ :call <SID>StripTrailingWhitespaces()
    augroup END



    " Zenefits specific settings.
    augroup zenefits_projects_settings
        autocmd!
        " Indentations settings.
        autocmd BufRead,BufEnter */{yourPeople*,global-styles,z-*}/*.py
            \ set shiftwidth=4 softtabstop=4 tabstop=4
        autocmd BufRead,BufEnter */{yourPeople*,global-styles,z-*}/*.{js,ts,tsx,scss,css,html,hbs}
            \ set shiftwidth=2 softtabstop=2 tabstop=2
        autocmd BufRead,BufEnter */{yourPeople*}/*
            \ set noexpandtab
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
    " Toggle between number and relative number.
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
        " save last search & cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        %s/\s\+$//e
        let @/=_s
        call cursor(l, c)
    endfunction
" }}}
" Plugins {{{
    " Auto install vim-plug.
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
      silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

    call plug#begin()
    " General editing plugins.
    Plug 'tpope/vim-surround'
    Plug 'scrooloose/nerdcommenter' " Auto comment for different file types

    " Layout plugins.
    Plug 'altercation/vim-colors-solarized' " Solarize vim theme.
    Plug 'vim-airline/vim-airline' " Nicer statusbar support for vim.
        Plug 'vim-airline/vim-airline-themes', {'do': ':AirlineTheme solarized'} " Vim-airline & solarize integration
    Plug 'ap/vim-css-color' " Highlight HEX color codes.
    Plug 'yuttie/comfortable-motion.vim' " For a smoother scrolling experience.
    Plug 'yggdroot/indentline' " Simple indentation guides.

    " Text editor enhancement plugins.
    Plug 'jiangmiao/auto-pairs' " Auto insert/delete brackets, parens, quotes
    Plug 'scrooloose/nerdtree' " File explorer
        Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " Plugin to color different file ext differently.
    Plug 'majutsushi/tagbar' " Shows tags for the currently edited file.
    Plug 'ludovicchabant/vim-gutentags' " Auto-generate tag files.
    Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --bin'}
        Plug 'junegunn/fzf.vim' " Fuzzy search for files, tags, buffer, e.t.c
    Plug 'qpkorr/vim-bufkill' " Add commands to kill buffers without removing the window.
    Plug 'rking/ag.vim' " Silver searcher vim integration.
    Plug 'michaeljsmith/vim-indent-object'

    " Tmux support.
    Plug 'christoomey/vim-tmux-navigator' " Easier navigation from vim panes to tmux panes.

    " IDE-like features.
    Plug 'Valloric/YouCompleteMe' " Auto-complete for vim.
    Plug 'w0rp/ale' " Linting engine.
    Plug 'tpope/vim-fugitive' " Git integration.

    " Plugins for Javascript.
    Plug 'pangloss/vim-javascript' " Enhance javascript coding experience.
    Plug 'docunext/closetag.vim' " Use <C-_> to close HTML/XML tags.
    Plug 'gregsexton/matchtag' " Highlight matching HTML/XML tag.

    "Plugins for Typescript.
    Plug 'leafgarland/typescript-vim'

    " Plugins for JSX & TSX
    Plug 'mxw/vim-jsx' " JSX language support.
    Plug 'ianks/vim-tsx' " TSX language support.

    " Plugins for CSS.
    Plug 'csscomb/vim-csscomb'

    " Plugins for Ember.
    Plug 'joukevandermaas/vim-ember-hbs' " Support for Ember handle bar files.

    " Plugins for Markdown.
    Plug 'godlygeek/tabular' " Dependency for vim-markdown.
    Plug 'plasticboy/vim-markdown' " Markdown support for vim.

    " Plugins for GraphQL
    Plug 'jparise/vim-graphql' " GraphQL filetype support syntax.

    " Snippet?
    " Note: Has dependency on ryanoasis/nerd-fonts.
    "
    " This plugin need to stay at the end for other plugins to use.
    Plug 'ryanoasis/vim-devicons' " Icons for NERDTree.
    call plug#end()
" }}}
" Solarized colorscheme {{{
    syntax enable " enable syntax processing
    set background=dark

    " Using solarized color scheme.
    " Note: also need to set the terminal's color pallete to Solarized color.
    " scheme, check out https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized for instructions.
    colorscheme solarized
" }}}
" NERDtree {{{
    augroup nerdtree
        autocmd!
        " Open a NERDTree automatically when vim starts up if no files were specified.
        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

        " Open NERDTree automatically when vim starts up on opening a directory.
        autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
    augroup END

    " Remap NERDTree menu key so we can still use marking.
    let NERDTreeMapMenu = 'M'
    " Remap NERDTree next/prev sibling keys.
    let NERDTreeMapJumpNextSibling = '<C-n>'
    let NERDTreeMapJumpPrevSibling = '<C-p>'
    " Remap NERDTree split keys.
    let NERDTreeMapOpenSplit = '<C-s>'
    let NERDTreeMapPreviewSplit = 'gs'
    let NERDTreeMapOpenVSplit = '<C-v>'
    let NERDTreeMapPreviewVSplit = 'gv'
    let NERDTreeMapOpenInTab = '<C-t>'
    let NERDTreeMapOpenInTabSilent = 'T'
    " Remap help key.
    let NERDTreeMapHelp = 'H'

    " Ignore certain files in NERDTree.
    let NERDTreeIgnore=[
        \ '\~$', '\.swp$', '\.lock',
        \ '\.pyc$', '__pycache__[[dir]]', 'migrations[[dir]]',
        \ 'node_modules[[dir]]', 'bower_components[[dir]]']
    " List py files before directories.
    let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\~$']
    " Show bookmarks don't list by default.
    let NERDTreeShowBookmarks=0

    " Start NERDTree.
    nnoremap <leader>wn :NERDTreeToggle<CR>
    " Show current buffer in NERDTree.
    nnoremap <leader>gn :NERDTreeFind<CR>
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
    " Search for files in git repo (ignore .gitignores).
    nnoremap <leader>f :GFiles<CR>
    " Normal file search.
    nnoremap <leader>F :Files<CR>
    " Search windows
    nnoremap <leader>ww :Windows<CR>
    " Remap splitting key bindings.
    let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit' }
" }}}
" Vim-Airline {{{
    " Note, if ever need to customize airline's section, see
    " :help airline-section
    let g:airline_powerline_fonts = 1 " Let vim-airline uses new fonts
    " Set solarized theme (Need :AirlineTheme solarized) before this has effect.
    let g:airline_solarized_bg='dark'

    " Enable tabline when there's no window.
    let g:airline#extensions#tabline#enabled = 1

    augroup vim_airline_config
        autocmd!
        autocmd VimEnter * AirlineTheme solarized
    augroup END
" }}}
" YouCompleteMe {{{
    " Remember to add the project dir to PYTHONPATH so that Jedi can find the
    " definition.
    let g:ycm_python_binary_path = 'python' " Tell Jedi to use the first Python found in $PATH.

    let g:ycm_auto_trigger = 1 " Turn off auto trigger because it's too distracting.

    " Control threshold for ID-based suggestion.
    " Use high number (e.g. 99) to turn off ID-based suggestion and leave semantic completion.
    let g:ycm_min_num_of_chars_for_completion = 7
    " let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file.
    let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure.
    let g:ycm_seed_identifiers_with_syntax = 1 " Seed identifiers from the language's keywords list.
    let g:ycm_complete_in_comments = 1 " Completion in comments.
    let g:ycm_complete_in_strings = 1 " Completion in string.
    let g:ycm_max_num_candidates = 50 " Limit the # of candidates from semantic completion suggestion.

    " Shortcuts for ycm goto commands.
    nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>
    nnoremap <leader>gr :YcmCompleter GoToReferences<CR>
    " Go peek
    nnoremap <leader>gp :YcmCompleter GetDoc<CR>
" }}}
" Tagbar {{{
    " Whether to auto focus to Tagbar when open.
    let g:tagbar_autofocus = 1
    " Whether to auto close the tagbar when hitting <CR>.
    let g:tagbar_autoclose = 0
    " Enable tag sorting.
    let g:tagbar_sort = 1

    " Map tagbar keys to be consistent with NERDTree.
    " Map hIde to 'I'.
    let g:tagbar_map_hidenonpublic = 'I'
    " Map Help to 'H'.
    let g:tagbar_map_help = 'H'
    " Toggle Tagbar.
    nnoremap <leader>wt :TagbarToggle<CR>
    " Jump to this method in Tagbar.
    nnoremap <leader>gt :TagbarOpen j<CR>
" }}}
" ag.vim {{{
    " Open a larger quickfix window.
    let g:ag_qhandler = "botright copen 20"
    " Highlight result (not working!).
    let g:ag_highlight = 1
    " Specify the default ag options.
    let g:ag_prg = "ag --column --nogroup --noheading --ignore '*.pyc'"

    " Search using Silver search.
    nnoremap <leader>a :Ag! --ignore "test*.py" --ignore "tags" --ignore-dir "*.tmp" 
    nnoremap <leader>at :Ag! --ignore "tags" --ignore-dir "*.tmp" 
    " Immediately search for the word under the cursor.
    nnoremap <leader>A :Ag! --ignore "test*.py" --ignore "tags" --ignore-dir "*.tmp" --word "<C-r><C-w>"<CR>
    nnoremap <leader>At :Ag! --ignore "tags" --ignore-dir "*.tmp" --word "<C-r><C-w>"<CR>
" }}}
" ALE {{{
    let g:ale_linters = {
                \   'python': ['pyflakes'],
                \   'javascript': ['eslint', 'prettier'],
                \   'typescript': ['tslint'],
                \}

    " Run all 'value' linters for 'key' filetypes.
    let g:ale_linter_aliases = {
                \   'typescript': 'javascript'
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

    " Don't run linters when coding.
    let g:ale_lint_on_text_changed = 'never'
    " Don't run linters on opening a file.
    let g:ale_lint_on_enter = 0
" }}}
" BufKill {{{
    " Close buffer but keep window open.
    nnoremap <leader>qq :BD!<CR>
" }}}
" CSSComb {{{
    augroup csscomb
        " Map bc to run CSScomb. bc stands for beautify css
        " autocmd FileType css noremap <buffer> <leader>bc :CSScomb<CR>
        " Automatically comb your CSS on save
        autocmd BufWritePre,FileWritePre *.css,*.less,*.scss,*.sass silent! :CSScomb
    augroup END
" }}}
" Vim-Markdown {{{
    " Fold a little nicer.
    let g:vim_markdown_folding_style_pythonic = 1
" }}}

" Auto-folding when open this file.
set modelines=1 " Run the line below for this file only
" vim:foldmethod=marker:foldlevel=0
