#!/bin/bash
DOTFILES_DIR=$HOME/.dotfiles
if [[ ! -d $DOTFILES_DIR ]]; then
    echo Please make sure that $DOTFILES_DIR exists.
    echo Exiting..
    exit
fi

ALL_PROGRAMS=(tmux bash zsh git ctags nvim ideavim)
DRYRUN=False

_run() {
    if [[ $DRYRUN == True ]]; then
        echo "dryrun: $@"
    else
        echo "running: $@"
        eval "$@"
    fi
}

create_symlink() {
    [[ $# -ne 2 ]] \
            && echo ERROR: Calling create_symlink with incorrect arguments >&2 \
            && return 1

    local src="$1"
    local dest="$2"

    echo "linking: $src -> $dest..."

    [[ ! -e "$src" ]] \
            && echo ERROR: "$src" does not exist. Skipping... >&2 \
            && return 1

    # Create backup if needed
    if [[ -e "$dest" ]] && (! cmp -s "$src" "$dest"); then
        _run mv "$dest" "$(mktemp ${dest}.bak.XXXXXX)"
    fi

    _run ln -sf "$src" "$dest"
}

link_tmux() {
    local TMUX_DIR=$DOTFILES_DIR/tmux

    if [[ $OSTYPE == linux* ]]; then
        create_symlink "$TMUX_DIR/linux.tmux.conf" "$HOME/.tmux.conf"
    elif [[ $OSTYPE == darwin* ]]; then
        create_symlink "$TMUX_DIR/mac.tmux.conf" "$HOME/.tmux.conf"
    fi
}

link_bash() {
    local BASH_DIR=$DOTFILES_DIR/bash

    if [[ $OSTYPE == linux* ]]; then
        BASH_LINUX="$BASH_DIR/linux"
        create_symlink "$BASH_LINUX/bashrc" "$HOME/.bashrc"
        create_symlink "$BASH_LINUX/bash_logout" "$HOME/.bash_logout"
        create_symlink "$BASH_LINUX/bash_aliases" "$HOME/.bash_aliases"
    fi
}

link_git() {
    local GIT_DIR=$DOTFILES_DIR/git

    if [[ $OSTYPE == linux* ]]; then
        create_symlink "$GIT_DIR/linux.gitconfig" "$HOME/.gitconfig"
    elif [[ $OSTYPE == darwin* ]]; then
        create_symlink "$GIT_DIR/mac.gitconfig" "$HOME/.gitconfig"
    fi

    create_symlink "$GIT_DIR/gitignore_global" "$HOME/.gitignore_global"
}

link_zsh() {
    local ZSH_DIR=$DOTFILES_DIR/zsh

    if [[ $OSTYPE == darwin* ]]; then
        create_symlink "$ZSH_DIR/zshrc" "$HOME/.zshrc"
        create_symlink "$ZSH_DIR/zsh_aliases" "$HOME/.zsh_aliases"
        create_symlink "$ZSH_DIR/zsh_plugins.txt" "$HOME/.zsh_plugins.txt"
    fi
}

link_ctags() {
    local CTAGS_DIR=$DOTFILES_DIR/ctags

    mkdir -p "$HOME/.ctags.d"
    create_symlink "$CTAGS_DIR/ctags" "$HOME/.ctags.d/common.ctags"
}

link_nvim() {
    local NVIM_DIR=$DOTFILES_DIR/nvim

    mkdir -p "$HOME/.config/nvim"
    create_symlink "$NVIM_DIR/init.vim" "$HOME/.config/nvim/init.vim"
}

link_ideavim() {
    local IDEAVIM_DIR=$DOTFILES_DIR/ideavim

    create_symlink "$IDEAVIM_DIR/ideavimrc" "$HOME/.ideavimrc"
}

usage() {
cat <<- EOF
Usage: $PROGNAME [-d|--dryrun] [all|tmux|bash|zsh|git|ctags|nvim|ideavim]
EOF
}

main() {
    local programs=()

    while [[ -n "$1" ]]; do
        case "$1" in
            -d | --dryrun) DRYRUN=True;;
            all) programs="${ALL_PROGRAMS[@]}";;
            tmux) programs+=(tmux);;
            bash) programs+=(bash);;
            zsh) programs+=(zsh);;
            git) programs+=(git);;
            ctags) programs+=(ctags);;
            nvim) programs+=(nvim);;
            ideavim) programs+=(ideavim);;
            *) usage >&2 && exit 1;;
        esac
        shift
    done

    unique_programs=($(echo "${programs[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
    [[ ${#unique_programs[@]} == 0 ]] && usage >&2 && exit 1

    for p in "${unique_programs[@]}"; do
        case $p in
            tmux) link_tmux;;
            bash) link_bash;;
            zsh) link_zsh;;
            git) link_git;;
            ctags) link_ctags;;
            nvim) link_nvim;;
            ideavim) link_ideavim;;
            *) echo "ERROR: Unknown program $p" >&2 && exit 1;;
        esac
    done
}

main "$@"
