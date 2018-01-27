#!/bin/bash
DOTFILES_DIR=$HOME/.dotfiles
if [[ ! -d $DOTFILES_DIR ]]; then
    echo Please make sure that $DOTFILES_DIR exists.
    echo Exiting..
    exit
fi

if [[ $OSTYPE == linux* ]]; then
    echo Detect Linux OS.

    echo Linking tmux...
    ln -sf $DOTFILES_DIR/tmux/linux.tmux.conf $HOME/.tmux.conf
    echo Done.

    BASH_LINUX=$DOTFILES_DIR/bash/linux
    echo Linking .bashrc...
    ln -sf $BASH_LINUX/bashrc $HOME/.bashrc
    echo Done.

    echo Linking .bash_logout...
    ln -sf $BASH_LINUX/bash_logout $HOME/.bash_logout
    echo Done.

    echo Linking .bash_aliases...
    ln -sf $BASH_LINUX/bash_aliases $HOME/.bash_aliases
    echo Done.

    GIT_DIR=$DOTFILES_DIR/git
    echo Linking .gitconfig...
    ln -sf $GIT_DIR/linux.gitconfig $HOME/.gitconfig
    echo Done.
elif [[ $OSTYPE == darwin* ]]; then
    echo Detect Mac OS.

    echo Linking tmux...
    ln -sf $DOTFILES_DIR/tmux/mac.tmux.conf $HOME/.tmux.conf
    echo Done.

    BASH_MAC=$DOTFILES_DIR/bash/mac
    echo Linking .bash_profile...
    ln -sf $BASH_MAC/bash_profile $HOME/.bash_profile
    echo Done.

    echo Linking .bash_aliases...
    ln -sf $BASH_MAC/bash_aliases $HOME/.bash_aliases
    echo Done.

    GIT_DIR=$DOTFILES_DIR/git
    echo Linking .gitconfig...
    ln -sf $GIT_DIR/mac.gitconfig $HOME/.gitconfig
    echo Done.
fi
