# Add following lines to ~/.bashrc

# see: https://www.gnu.org/software/bash/manual/html_node/Commands-For-History.html
# Up/Down key get matching history on inputing
if [[ $- == *i* ]]; then
  bind '"\e[A": history-search-backward'
  bind '"\e[B": history-search-forward'
fi

# Tab completion case insensitive
bind 'set completion-ignore-case on'

# Colored manpage:
# colors are from ohmyzsh https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colored-man-pages
man() {
  LESS_TERMCAP_mb=$(printf "\e[1;31m") \
  LESS_TERMCAP_md=$(printf "\e[1;31m") \
  LESS_TERMCAP_me=$(printf "\e[0m") \
  LESS_TERMCAP_se=$(printf "\e[0m") \
  LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
  LESS_TERMCAP_ue=$(printf "\e[0m") \
  LESS_TERMCAP_us=$(printf "\e[1;32m") \
  command man "$@"
}
export -f man
