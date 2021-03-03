# Amazon specific tools
ZSH_THEME="crunch"

for f in AmazonMqOpsToolsConsumable SDETools envImprovement AmazonAwsCli OdinTools; do
    if [[ -d /apollo/env/$f ]]; then
        export PATH=$PATH:/apollo/env/$f/bin
    fi
done

export JAVA_HOME=/apollo/env/envImprovement/jdk1.8
export PATH=$JAVA_HOME/bin:$PATH

# Brazil tools
export PATH=$HOME/.toolbox/bin:$PATH
alias brazil-octane='/apollo/env/OctaneBrazilTools/bin/brazil-octane'
alias third-party-promote='~/.toolbox/bin/brazil-third-party-tool promote'
alias third-party='~/.toolbox/bin/brazil-third-party-tool'

export GIT_EDITOR=vim
alias vim='/apollo/env/envImprovement/bin/vim'
alias vi='/apollo/env/envImprovement/bin/vim'

alias bb="brazil-build"
alias bws="brazil workspace"
alias bre="brazil-recursive-cmd --allPackages"

alias auth='kinit -f && mwinit -o'

eval `ssh-agent`
