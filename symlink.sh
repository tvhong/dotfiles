#!/bin/bash
DOTFILES_DIR=$HOME/.dotfiles
if [[ ! -d $DOTFILES_DIR ]]; then
    echo Please make sure that $DOTFILES_DIR exists.
    echo Exiting..
    exit
fi

if [[ $OSTYPE == darwin* ]]; then
    echo I am a Mac
elif [[ $OSTYPE == linux* ]]; then
    echo Detect Linux OS.

    echo Linking tmux...
    ln -sf $HOME/.dotfiles/tmux/linux.tmux.conf $HOME/.tmux.conf
    echo Done.
fi
