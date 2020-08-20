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
. ~/.colored-man-pages.bash
# sudo apt install most
#if [ -x /usr/bin/most ]; then
#  #export PAGER="most"
#  alias man='PAGER="most" man'
#fi

