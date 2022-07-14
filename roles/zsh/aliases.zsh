alias hs='history | grep'
alias cl="clear"
alias c="clear"
alias pg='ps -ef | grep'
alias pkill!="pkill -9 -f "

alias ohmyzsh="nvim ~/.oh-my-zsh"
alias reload!='. ~/.zshrc'

alias vim="nvim"
alias vi="nvim"
alias v="nvim"

alias timezsh="time zsh -i -c echo"

alias dk="docker"
alias dkc="docker compose"

# Docker login to ECR repo
alias aws-login="aws ecr get-login-password --region eu-south-1 | docker login --username AWS --password-stdin 422393141836.dkr.ecr.eu-south-1.amazonaws.com"

# Install globally required packages
alias npm-global="npm i --location=global npmrc eslint eslint_d prettier @fsouza/prettierd npx"

# Logitech headset requires these inputs
alias fix-headset="headsetcontrol -l 0 && headsetcontrol -s 128"

alias mount-gdrive="rclone mount --daemon --daemon-timeout=5m --buffer-size=64M --dir-cache-time=64h --vfs-cache-mode=full  --vfs-read-chunk-size 100M  --vfs-read-chunk-size-limit 0 --vfs-cache-max-age=6h GDrive: ~/GDrive"
