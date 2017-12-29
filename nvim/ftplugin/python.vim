" Fold config
setlocal foldmethod=indent
setlocal foldnestmax=2 " so it only folds classes and methods, and not the ifs
setlocal foldminlines=20 " minimum number of lines for folding to kick in

" Highlight trailing characters. Use to override system's python.vim
setlocal listchars=tab:\|\ ,trail:-,extends:>,precedes:<,nbsp:+
set list
