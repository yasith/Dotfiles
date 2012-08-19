#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Use ls with color output
alias ls='ls --color=auto'

# Status line
PS1='[\u@\h \W]\$ '

# auto-complete commands while using sudo
complete -cf sudo

# always run tmux 2
alias tmux='tmux -2'

# if we are not running tmux, run tmux
[[ $TERM != screen* ]] && exec tmux
