" this is to be linked to ~/.config/nvim/init.vim

augroup mynvimrchook
    au!
    autocmd BufWritePost init.vim,.nvimrc source $MYVIMRC " Auto reload vimrc whne it changes
augroup END

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
filetype indent on      " load filetype-specific indent files

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

" Use <C-L to clear the highlighting of :set hlsearch
if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

" Function to toggle relative numbering
function! ToggleNumber()
    if (&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

nnoremap <leader>r :call ToggleNumbek()<cr>

" Use ; for commands.
nnoremap ; :
