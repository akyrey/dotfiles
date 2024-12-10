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

# Dockers
alias dk="docker"
alias dki="docker images"
alias dkr="docker run -it --rm"
alias dkxxx="docker system prune -f --volumes"
alias dkrmi="docker rmi $(docker images --filter "dangling=true" -q --no-trunc)"
alias dkc="docker compose"
function dkrv() {
  docker run -it --rm -v "$PWD":/ws -w /ws "$@";
}

# Docker login to ECR repo
alias aws-login="aws ecr get-login-password --region eu-south-1 | docker login --username AWS --password-stdin 422393141836.dkr.ecr.eu-south-1.amazonaws.com"

# Install globally required packages
alias pnpm-global="pnpm i -g npmrc eslint eslint_d prettier @fsouza/prettierd npx"

# Logitech headset requires these inputs
alias fix-headset="headsetcontrol -l 0 && headsetcontrol -s 128"

alias mount-gdrive="rclone mount --daemon --daemon-timeout=5m --buffer-size=64M --dir-cache-time=64h --vfs-cache-mode=full  --vfs-read-chunk-size 100M  --vfs-read-chunk-size-limit 0 --vfs-cache-max-age=6h GDrive: ~/GDrive"

alias work="timer 25m && notify-send 'Pomodoro' 'Work Timer is up! Take a Break \U0001F600' -i '~/Pictures/clock.png'"
alias rest="timer 10m && notify-send 'Pomodoro' 'Break is over! Get back to work \U0001F62C' -i '~/Pictures/clock.png'"

# Tools
function air() {
  docker run -it --rm \
    --network "${NETWORK:=default}" \
    -w "$PWD" -v "$PWD":"$PWD" \
    -p "${AIR_PORT:=4000}":"${AIR_PORT:=4000}" \
    docker.io/cosmtrek/air "$@";
}

function sail() { 
  if [ -x "$PWD/vendor/bin/sail" ]; then
    "$PWD/vendor/bin/sail" "$@";
  else
    dkrv laravelsail/php83-composer "$@";
  fi
}

function composer() {
  docker run --rm -it \
    --env COMPOSER_HOME \
    --env COMPOSER_CACHE_DIR \
    --user $(id -u):$(id -g) \
    -v "${COMPOSER_HOME:-$HOME/.config/composer}":"$COMPOSER_HOME" \
    -v "${COMPOSER_CACHE_DIR:-$HOME/.cache/composer}":"$COMPOSER_CACHE_DIR" \
    -w "$PWD" -v "$PWD":"$PWD" \
    composer "$@";
}
