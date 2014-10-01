# Path to your oh-my-zsh configuration.
ZSH=$HOME/Dotfiles/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="blinks"

# Aliases
alias tmux="tmux -2"
alias open="xdg-open &> /dev/null" # OSX like open for any type of file

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# set the PATH for Java
export PATH=/usr/lib/java/jdk1.8.0_20/bin:$PATH

# set the PATH for ruby gem executables
# export PATH=/home/yasith/.gem/ruby/1.9.1/bin:$PATH

# set the PATH for ls++
# Install via AUR
# export PATH=$PATH:/usr/bin/vendor_perl
# alias ls="ls++"

# disable the system bell
xset -b

# export JAVA_HOME so the Sun jdk will be used
export JAVA_HOME=/usr/lib/java/jdk1.8.0_20

# PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
# for RVM
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
