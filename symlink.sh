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

    echo Linking tmux...
    ln -sf $TMUX_DIR/linux.tmux.conf $HOME/.tmux.conf
    echo Done.

    BASH_LINUX=$BASH_DIR/linux
    echo Linking .bashrc...
    ln -sf $BASH_LINUX/bashrc $HOME/.bashrc
    echo Linking .bash_logout...
    ln -sf $BASH_LINUX/bash_logout $HOME/.bash_logout
    echo Linking .bash_aliases...
    ln -sf $BASH_LINUX/bash_aliases $HOME/.bash_aliases
    echo Done.

    echo Linking .gitconfig...
    ln -sf $GIT_DIR/linux.gitconfig $HOME/.gitconfig
    echo Linking .gitignore_global...
    ln -sf $GIT_DIR/gitignore_global $HOME/.gitignore_global
    echo Done.

    echo Linking ctags...
    mkdir -p $HOME/.ctags.d
    ln -sf $CTAGS_DIR/ctags $HOME/.ctags.d/common.ctags
    echo Done.
elif [[ $OSTYPE == darwin* ]]; then
    echo OS: Mac.

    echo Linking tmux...
    ln -sf $TMUX_DIR/mac.tmux.conf $HOME/.tmux.conf
    echo Done.

    BASH_MAC=$BASH_DIR/mac
    echo Linking .bash_profile...
    ln -sf $BASH_MAC/bash_profile $HOME/.bash_profile
    echo Done.

    linking "$ZSH_DIR/zshrc" "$HOME/.zshrc"

    echo Linking .gitconfig...
    ln -sf $GIT_DIR/mac.gitconfig $HOME/.gitconfig
    echo Linking .gitignore_global...
    ln -sf $GIT_DIR/gitignore_global $HOME/.gitignore_global
    echo Done.

    echo Linking ctags...
    mkdir -p $HOME/.ctags.d
    ln -sf $CTAGS_DIR/ctags $HOME/.ctags.d/common.ctags
    echo Done.
fi
