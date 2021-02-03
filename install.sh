#!/bin/bash
#
# Create symbolic links to various program configurations.

readonly DOTFILES_DIR=$HOME/.dotfiles
readonly ALL_PROGRAMS=(tmux bash zsh git ctags nvim ideavim)

DRYRUN=False

main() {
    local programs=()

    while [[ -n "$1" ]]; do
        case "$1" in
            -h | --help) print_usage; exit 0;;
            -d | --dryrun) DRYRUN=True;;
            all) programs="${ALL_PROGRAMS[@]}";;
            *) programs+=($1)
        esac
        shift
    done

    validate_programs ${programs[@]} >&2 || exit 1

    link_dotfiles
    link_programs ${programs[@]}
}

print_usage() {
    local programs_string="all|$(tr ' ' '|' <<< "${ALL_PROGRAMS[@]}")"

cat << EOF
Usage: $(basename "$0") [-h|--help] [-d|--dryrun] $programs_string [${ALL_PROGRAMS[0]}|...]

WHERE
    -h | --help: Prints this help message.
    -d | --dryrun: Runs program in dryrun mode. Prints out the intended actions, but no changes to the system is performed.
EOF
}

validate_programs() {
    local programs=("$@")

    if [[ ${#programs[@]} == 0 ]]; then
        print_usage
        return 1
    fi

    for p in "${programs[@]}"; do
        if ! element_in "$p" "${ALL_PROGRAMS[@]}"; then
            echo "ERROR: Unknown program: $p"
            print_usage
            return 1
        fi
    done
}

link_dotfiles() {
    if [[ ! -d $DOTFILES_DIR ]]; then
        local dotfiles_src_dir=$(cd $(dirname $0) && pwd)
        symlink $dotfiles_src_dir $DOTFILES_DIR
    fi
}

link_programs() {
    local programs=("$@")

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

link_tmux() {
    local tmux_dir=$DOTFILES_DIR/tmux

    if [[ $OSTYPE == linux* ]]; then
        symlink "$tmux_dir/linux.tmux.conf" "$HOME/.tmux.conf"
    elif [[ $OSTYPE == darwin* ]]; then
        symlink "$tmux_dir/mac.tmux.conf" "$HOME/.tmux.conf"
    fi
}

link_bash() {
    local bash_dir=$DOTFILES_DIR/bash

    if [[ $OSTYPE == linux* ]]; then
        BASH_LINUX="$bash_dir/linux"
        symlink "$BASH_LINUX/bashrc" "$HOME/.bashrc"
        symlink "$BASH_LINUX/bash_logout" "$HOME/.bash_logout"
        symlink "$BASH_LINUX/bash_aliases" "$HOME/.bash_aliases"
    fi
}

link_git() {
    local git_dir=$DOTFILES_DIR/git

    if [[ $OSTYPE == linux* ]]; then
        symlink "$git_dir/linux.gitconfig" "$HOME/.gitconfig"
    elif [[ $OSTYPE == darwin* ]]; then
        symlink "$git_dir/mac.gitconfig" "$HOME/.gitconfig"
    fi

    symlink "$git_dir/gitignore_global" "$HOME/.gitignore_global"
}

link_zsh() {
    local zsh_dir=$DOTFILES_DIR/zsh

    symlink "$zsh_dir/zshrc" "$HOME/.zshrc"
    symlink "$zsh_dir/zsh_aliases" "$HOME/.zsh_aliases"
    symlink "$zsh_dir/zsh_plugins.txt" "$HOME/.zsh_plugins.txt"

    echo "Remember to install [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) and any customer zsh scripts"
}

link_ctags() {
    local ctags_dir=$DOTFILES_DIR/ctags

    mkdir -p "$HOME/.ctags.d"
    symlink "$ctags_dir/ctags" "$HOME/.ctags.d/common.ctags"
}

link_nvim() {
    local nvim_dir=$DOTFILES_DIR/nvim

    mkdir -p "$HOME/.config/nvim"
    symlink "$nvim_dir/init.vim" "$HOME/.config/nvim/init.vim"
}

link_ideavim() {
    local ideavim_dir=$DOTFILES_DIR/ideavim

    symlink "$ideavim_dir/ideavimrc" "$HOME/.ideavimrc"
}

#######################################
# Create symlink from $src to $dest. Creating backup if necessary.
# Arguments:
#   $src
#   $dest
#######################################
symlink() {
    [[ $# -ne 2 ]] \
            && echo ERROR: Calling symlink with incorrect arguments >&2 \
            && return 1

    local src="$1"
    local dest="$2"

    echo "linking $src -> $dest..."

    [[ ! -e "$src" ]] \
            && echo ERROR: "$src" does not exist! >&2 \
            && return 1

    # Create backup if needed
    if [[ -e "$dest" ]] && (! cmp -s "$src" "$dest"); then
        execute mv "$dest" "${dest}.$(random_string 3).bak"
    fi

    execute ln -sf "$src" "$dest"
}

execute() {
    if [[ $DRYRUN == True ]]; then
        echo "dryrun: $@"
    else
        echo "running: $@"
        eval "$@"
    fi
}

#######################################
# Check if element is in array.
# Arguments:
#   $element
#   $array
#######################################
element_in() {
    local e match="$1"
    shift
    for e; do [[ "$e" == "$match" ]] && return 0; done
    return 1
}

random_string() {
    local len=$1
    echo $(head /dev/urandom | base64 | head -n 1 | tr -dc '[:lower:][:digit:]' | cut -c -$len)
}

main "$@"
