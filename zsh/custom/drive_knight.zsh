# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

export PATH=$HOME/Library/Python/3.7/bin:$HOME/.toolbox/bin:$PATH
export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home

alias bb=brazil-build
alias bws="brazil workspace"
alias bre="brazil-recursive-cmd --allPackages"

# Hook direnv into the shell
if commandExists direnv; then
    eval "$(direnv hook zsh)"
fi

alias auth="kinit && mwinit"

# prune my backup branches
git-prune-backup() {
    local branches
    branches=$(git branch -r | awk -F/ '/backup\/vhong/{print $2"/"$3}')
    echo $branches

    echo -n "Continue?(y/n) "
    read
    if [[ $REPLY =~ ^[Yy] ]]; then
        echo "Deleting the branches..."
        echo $branches | xargs -I {} git push backup -d {}
        echo "Done"
    fi
}

#######################################################################
# Rapid Development Environment (RDE) config
#######################################################################
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i
