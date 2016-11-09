# https://wiki.archlinux.org/index.php/Zsh

HISTFILE=~/.zsh_histfile
HISTSIZE=1000
SAVEHIST=1000

autoload -Uz compinit promptinit
#autoload -U colors && colors
compinit
promptinit
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
setopt completealiases
prompt suse

# keyboard:
#bindkey -e
bindkey '\e[A' history-search-backward  # up
bindkey '\e[B' history-search-forward   # down

# alias
alias ls='ls --color=auto'
alias l='ls -CF'
alias la='ls -AF'
alias ll='ls -alF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
