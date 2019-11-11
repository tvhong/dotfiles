#!/bin/bash

DOTFILES_DIR=$HOME/.dotfiles
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

_link() {
    [[ $# -ne 2 ]] \
            && echo ERROR: Calling _link with incorrect arguments >&2 \
            && return 1

    local src="$1"
    local dest="$2"

    echo "linking: $src -> $dest..."

    [[ ! -e "$src" ]] \
            && echo ERROR: "$src" does not exist! >&2 \
            && return 1

    # Create backup if needed
    if [[ -e "$dest" ]] && (! cmp -s "$src" "$dest"); then
        _run mv "$dest" "$(mktemp ${dest}.bak.XXXXXX)"
    fi

    _run ln -sf "$src" "$dest"
}

link_dotfiles() {
    if [[ ! -d $DOTFILES_DIR ]]; then
        local dotfiles_src_dir=$(cd $(dirname $0) && pwd)
        _link $dotfiles_src_dir $DOTFILES_DIR
    fi
}

link_tmux() {
    local TMUX_DIR=$DOTFILES_DIR/tmux

    if [[ $OSTYPE == linux* ]]; then
        _link "$TMUX_DIR/linux.tmux.conf" "$HOME/.tmux.conf"
    elif [[ $OSTYPE == darwin* ]]; then
        _link "$TMUX_DIR/mac.tmux.conf" "$HOME/.tmux.conf"
    fi
}

link_bash() {
    local BASH_DIR=$DOTFILES_DIR/bash

    if [[ $OSTYPE == linux* ]]; then
        BASH_LINUX="$BASH_DIR/linux"
        _link "$BASH_LINUX/bashrc" "$HOME/.bashrc"
        _link "$BASH_LINUX/bash_logout" "$HOME/.bash_logout"
        _link "$BASH_LINUX/bash_aliases" "$HOME/.bash_aliases"
    fi
}

link_git() {
    local GIT_DIR=$DOTFILES_DIR/git

    if [[ $OSTYPE == linux* ]]; then
        _link "$GIT_DIR/linux.gitconfig" "$HOME/.gitconfig"
    elif [[ $OSTYPE == darwin* ]]; then
        _link "$GIT_DIR/mac.gitconfig" "$HOME/.gitconfig"
    fi

    _link "$GIT_DIR/gitignore_global" "$HOME/.gitignore_global"
}

link_zsh() {
    local ZSH_DIR=$DOTFILES_DIR/zsh

    if [[ $OSTYPE == darwin* ]]; then
        _link "$ZSH_DIR/zshrc" "$HOME/.zshrc"
        _link "$ZSH_DIR/zsh_aliases" "$HOME/.zsh_aliases"
        _link "$ZSH_DIR/zsh_plugins.txt" "$HOME/.zsh_plugins.txt"
    fi
}

link_ctags() {
    local CTAGS_DIR=$DOTFILES_DIR/ctags

    mkdir -p "$HOME/.ctags.d"
    _link "$CTAGS_DIR/ctags" "$HOME/.ctags.d/common.ctags"
}

link_nvim() {
    local NVIM_DIR=$DOTFILES_DIR/nvim

    mkdir -p "$HOME/.config/nvim"
    _link "$NVIM_DIR/init.vim" "$HOME/.config/nvim/init.vim"
}

link_ideavim() {
    local IDEAVIM_DIR=$DOTFILES_DIR/ideavim

    _link "$IDEAVIM_DIR/ideavimrc" "$HOME/.ideavimrc"
}

usage() {
cat <<- EOF
Usage: $PROGNAME [-d|--dryrun] [all|$(tr ' ' '|' <<< "${ALL_PROGRAMS[@]}")]
EOF
}

element_in() {
    local e match="$1"
    shift
    for e; do [[ "$e" == "$match" ]] && return 0; done
    return 1
}

validate_programs() {
    local programs=$1

    if [[ ${#programs[@]} == 0 ]]; then
        usage
        return 1
    fi

    for p in "${programs[@]}"; do
        if ! element_in "$p" "${ALL_PROGRAMS[@]}"; then
            echo "ERROR: Unknown program: $p"
            usage
            return 1
        fi
    done
}

main() {
    local programs=()

    while [[ -n "$1" ]]; do
        case "$1" in
            -d | --dryrun) DRYRUN=True;;
            all) programs="${ALL_PROGRAMS[@]}";;
            *) programs+=($1)
        esac
        shift
    done

    validate_programs $programs >&2 || exit 1

    link_dotfiles

    unique_programs=($(echo "${programs[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
    for p in "${unique_programs[@]}"; do
        case $p in
            tmux) link_tmux;;
            bash) link_bash;;
            zsh) link_zsh;;
            git) link_git;;
            ctags) link_ctags;;
            nvim) link_nvim;;
            ideavim) link_ideavim;;
            *) echo "ERROR: Unknown program $p" >&2; exit 1;;
        esac
    done
}

main "$@"
