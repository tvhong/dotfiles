# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

export PATH=$HOME/Library/Python/3.7/bin:$HOME/.toolbox/bin:$PATH
export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home

alias bb=brazil-build
alias bws="brazil workspace"
alias bre="brazil-recursive-cmd --allPackages"

# Hook direnv into the shell
eval "$(direnv hook zsh)"
