export ENV=development
export TERM=xterm-256color
export SHELL=zsh
export EDITOR="/usr/local/bin/nvim"
export VISUAL="/usr/local/bin/nvim"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export XDG_CONFIG_HOME=$HOME/.config
# Use the KDE Wallet to store Git credentials
export GIT_ASKPASS='/usr/bin/ksshaskpass'
export GPG_TTY=$(tty)
# Path to install go app and libraries
export GOPATH=$HOME/go
export DOCKER_BUILDKIT=1
