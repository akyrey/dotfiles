export ENV=development
export TERM=xterm-256color
export SHELL=zsh
export EDITOR="/usr/local/bin/nvim"
export VISUAL="/usr/local/bin/nvim"
# export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export SSH_AUTH_SOCK=$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
export XDG_CONFIG_HOME=$HOME/.config
export GPG_TTY=$(tty)
export ANDROID_HOME=$HOME/Library/Android/sdk
# Path to install go app and libraries
export GOPATH=$HOME/go
export DOCKER_BUILDKIT=1
export JAVA_HOME="$(/usr/libexec/java_home)"
