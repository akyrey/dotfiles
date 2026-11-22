# Shell defaults previously provided by oh-my-zsh's lib/*.zsh, trimmed to what we use.

# --- History ---------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history       # record timestamp and duration
setopt hist_expire_dups_first # drop duplicates first when trimming
setopt hist_ignore_dups       # skip consecutive duplicates
setopt hist_ignore_space      # skip commands starting with a space
setopt hist_verify            # show !! expansions before running them
setopt share_history          # share history across sessions

# --- Directories -----------------------------------------------------------
setopt auto_cd auto_pushd pushd_ignore_dups pushdminus
alias -g ...='../..'
alias -g ....='../../..'
alias -- -='cd -'
alias md='mkdir -p'
alias rd=rmdir

# --- ls --------------------------------------------------------------------
if ls --color=auto -d . &>/dev/null; then
  alias ls='ls --color=tty'
else
  export CLICOLOR=1
fi
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

# --- Misc ------------------------------------------------------------------
setopt interactive_comments long_list_jobs multios prompt_subst
unsetopt flow_control

# --- Completion styles -----------------------------------------------------
zmodload -i zsh/complist
setopt auto_menu complete_in_word always_to_end
unsetopt menu_complete
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/zcompcache"

# --- Key bindings (emacs mode, prefix history search on arrows) ------------
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line
bindkey '^[[A' up-line-or-beginning-search   # Up (normal mode)
bindkey '^[OA' up-line-or-beginning-search   # Up (application mode)
bindkey '^[[B' down-line-or-beginning-search # Down (normal mode)
bindkey '^[OB' down-line-or-beginning-search # Down (application mode)
bindkey '^[[H' beginning-of-line             # Home
bindkey '^[OH' beginning-of-line
bindkey '^[[F' end-of-line                   # End
bindkey '^[OF' end-of-line
bindkey '^[[1;5C' forward-word               # Ctrl-Right
bindkey '^[[1;5D' backward-word              # Ctrl-Left
bindkey '^[[3~' delete-char                  # Delete
bindkey '^[[Z' reverse-menu-complete         # Shift-Tab
bindkey '^x^e' edit-command-line             # edit command in $EDITOR
bindkey ' ' magic-space                      # expand !! on space

# --- Terminal title: directory when idle, command while running ------------
autoload -Uz add-zsh-hook
_title_precmd() { print -Pn '\e]2;%~\a' }
_title_preexec() { print -rn -- $'\e]2;'"${1[1,80]//[^[:print:]]/}"$'\a' }
add-zsh-hook precmd _title_precmd
add-zsh-hook preexec _title_preexec
