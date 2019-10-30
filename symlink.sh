#!/bin/bash
DOTFILES_DIR=$HOME/.dotfiles
if [[ ! -d $DOTFILES_DIR ]]; then
    echo Please make sure that $DOTFILES_DIR exists.
    echo Exiting..
    exit
fi

TMUX_DIR=$DOTFILES_DIR/tmux
BASH_DIR=$DOTFILES_DIR/bash
GIT_DIR=$DOTFILES_DIR/git
CTAGS_DIR=$DOTFILES_DIR/ctags
ZSH_DIR=$DOTFILES_DIR/zsh
NVIM_DIR=$DOTFILES_DIR/nvim
IDEAVIM_DIR=$DOTFILES_DIR/ideavim

copy_with_backup() {
    if [[ $# -ne 2 ]]; then
        echo ERROR: Calling copy_with_backup with incorrect arguments
    fi

    src="$1"
    dest="$2"
    dest_bk=$(mktemp ${dest}.bk.XXXXXX)
    if [[ ! -e "$src" ]]; then
        echo "$src" does not exist. Skipping...
        return 1
    fi

    if [[ -e "$dest" ]]; then
        echo Backing up "$dest" to "$dest_bk"
        mv "$dest" "$dest_bk"
    fi

    ln -s "$src" "$dest"
}

linking() {
    if [[ $# -ne 2 ]]; then
        echo ERROR: Calling linking with incorrect arguments
    fi

    src="$1"
    dest="$2"
    echo ---
    echo Linking "$src" to "$dest"...
    copy_with_backup "$src" "$dest"
    echo Done
}
    

if [[ $OSTYPE == linux* ]]; then
    echo OS: Linux.

    linking "$TMUX_DIR/linux.tmux.conf" "$HOME/.tmux.conf"

    BASH_LINUX=$BASH_DIR/linux
    linking "$BASH_LINUX/bashrc" "$HOME/.bashrc"
    linking "$BASH_LINUX/bash_logout" "$HOME/.bash_logout"
    linking "$BASH_LINUX/bash_aliases" "$HOME/.bash_aliases"

    linking "$GIT_DIR/linux.gitconfig" "$HOME/.gitconfig"
elif [[ $OSTYPE == darwin* ]]; then
    echo OS: Mac.

    linking "$TMUX_DIR/mac.tmux.conf" "$HOME/.tmux.conf"
    linking "$ZSH_DIR/zshrc" "$HOME/.zshrc"
    linking "$GIT_DIR/mac.gitconfig" "$HOME/.gitconfig"
fi

linking "$GIT_DIR/gitignore_global" "$HOME/.gitignore_global"

mkdir -p $HOME/.ctags.d
linking "$CTAGS_DIR/ctags" "$HOME/.ctags.d/common.ctags"

mkdir -p $HOME/.config/nvim
linking "$NVIM_DIR/init.vim" "$HOME/.config/nvim/init.vim"

linking "$IDEAVIM_DIR/ideavimrc" "$HOME/.ideavimrc"

