#!/bin/bash
DOTFILES_DIR=$HOME/.dotfiles
if [[ ! -d $DOTFILES_DIR ]]; then
    echo Please make sure that $DOTFILES_DIR exists.
    echo Exiting..
    exit
fi

linking() {
    if [[ $# -ne 2 ]]; then
        echo ERROR: Calling linking with incorrect arguments >&2
    fi

    local src="$1"
    local dest="$2"

    echo ---
    echo Linking "$src" to "$dest"...

    if [[ ! -e "$src" ]]; then
        echo ERROR: "$src" does not exist. Skipping... >&2
        return 1
    fi

    # Create backup if needed
    if [[ -e "$dest" ]] && (! cmp -s "$src" "$dest"); then
        local dest_bak=$(mktemp ${dest}.bak.XXXXXX)
        echo "Backing up $dest to $dest_bak"
        mv "$dest" "$dest_bak"
    fi

    ln -sf "$src" "$dest"

    echo Done
}

link_tmux() {
    local TMUX_DIR=$DOTFILES_DIR/tmux

    if [[ $OSTYPE == linux* ]]; then
        linking "$TMUX_DIR/linux.tmux.conf" "$HOME/.tmux.conf"
    elif [[ $OSTYPE == darwin* ]]; then
        linking "$TMUX_DIR/mac.tmux.conf" "$HOME/.tmux.conf"
    fi
}

link_bash() {
    local BASH_DIR=$DOTFILES_DIR/bash

    if [[ $OSTYPE == linux* ]]; then
        BASH_LINUX="$BASH_DIR/linux"
        linking "$BASH_LINUX/bashrc" "$HOME/.bashrc"
        linking "$BASH_LINUX/bash_logout" "$HOME/.bash_logout"
        linking "$BASH_LINUX/bash_aliases" "$HOME/.bash_aliases"
    fi
}

link_git() {
    local GIT_DIR=$DOTFILES_DIR/git

    if [[ $OSTYPE == linux* ]]; then
        linking "$GIT_DIR/linux.gitconfig" "$HOME/.gitconfig"
    elif [[ $OSTYPE == darwin* ]]; then
        linking "$GIT_DIR/mac.gitconfig" "$HOME/.gitconfig"
    fi

    linking "$GIT_DIR/gitignore_global" "$HOME/.gitignore_global"
}

link_zsh() {
    local ZSH_DIR=$DOTFILES_DIR/zsh

    if [[ $OSTYPE == darwin* ]]; then
        linking "$ZSH_DIR/zshrc" "$HOME/.zshrc"
        linking "$ZSH_DIR/zsh_aliases" "$HOME/.zsh_aliases"
        linking "$ZSH_DIR/zsh_plugins.txt" "$HOME/.zsh_plugins.txt"
    fi
}

link_ctags() {
    local CTAGS_DIR=$DOTFILES_DIR/ctags

    mkdir -p "$HOME/.ctags.d"
    linking "$CTAGS_DIR/ctags" "$HOME/.ctags.d/common.ctags"
}

link_nvim() {
    local NVIM_DIR=$DOTFILES_DIR/nvim

    mkdir -p "$HOME/.config/nvim"
    linking "$NVIM_DIR/init.vim" "$HOME/.config/nvim/init.vim"
}

link_ideavim() {
    local IDEAVIM_DIR=$DOTFILES_DIR/ideavim

    linking "$IDEAVIM_DIR/ideavimrc" "$HOME/.ideavimrc"
}

while [[ -n "$1" ]]; do
    case "$1" in
        tmux) link_tmux;;
        bash) link_bash;;
        zsh) link_zsh;;
        git) link_git;;
        ctags) link_ctags;;
        nvim) link_nvim;;
        ideavim) link_ideavim;;
        *) echo "unknown subsystem $1" >&2;;
    esac
    shift
done
