# Add following lines to ~/.bashrc

# Up/Down key get matching history on inputing
if [[ $- == *i* ]]
then
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
fi
