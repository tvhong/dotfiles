SOURCE_CONFIG_DIR="${HOME}/.dotfiles/zsh/custom"
DESTINATION_CONFIG_DIR="${HOME}/.zgen/robbyrussell/oh-my-zsh-master/custom"

CONFIG_PATH=${SOURCE_CONFIG_DIR}/$1

if [[ ! -e "$CONFIG_PATH" ]]; then
    echo \"$CONFIG_PATH\" does not exist
    exit 1
fi

# Print commands and their arguments as they are executed.
set -x
ln -fs "$CONFIG_PATH" "$DESTINATION_CONFIG_DIR"
