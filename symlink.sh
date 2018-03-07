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
elif [[ $OSTYPE == darwin* ]]; then
    echo OS: Mac.

    echo Linking tmux...
    ln -sf $TMUX_DIR/mac.tmux.conf $HOME/.tmux.conf
    echo Done.

    BASH_MAC=$BASH_DIR/mac
    echo Linking .bash_profile...
    ln -sf $BASH_MAC/bash_profile $HOME/.bash_profile
    echo Linking .bash_aliases...
    ln -sf $BASH_MAC/bash_aliases $HOME/.bash_aliases
    echo Done.

    echo Linking .gitconfig...
    ln -sf $GIT_DIR/mac.gitconfig $HOME/.gitconfig
    echo Linking .gitignore_global...
    ln -sf $GIT_DIR/gitignore_global $HOME/.gitignore_global
    echo Done.

    echo Linking ctags...
    ln -sf $CTAGS_DIR/ctags $HOME/.ctags.d/mac.ctags
    echo Done.
fi
