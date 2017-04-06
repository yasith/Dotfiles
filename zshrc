# Path to your oh-my-zsh configuration.
ZSH=$HOME/Dotfiles/oh-my-zsh

ZSH_THEME="powerlevel9k/powerlevel9k"

# Powerline configuration.
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_DISABLE_RPROMPT=true

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="$ "

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)

#Powerline VCS color customization
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='black'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='green'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='black'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='black'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='red'

# Aliases
alias tmux="tmux -2"
alias open="xdg-open &> /dev/null" # OSX like open for any type of file
alias zshrc="source ~/.zshrc"

# Disable auto setting the terminal title
DISABLE_AUTO_TITLE="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# export ANDROID_HOME
export ANDROID_HOME=/home/yasith/Android/Sdk

# export JAVA_HOME so the Sun jdk will be used
export JAVA_HOME=/home/yasith/Apps/jdk1.8.0_65

# set the PATH for Java
export PATH=$JAVA_HOME/bin:$PATH

# add brew to the PATH
export PATH=/home/yasith/.linuxbrew/bin:$PATH

# add Anaconda to the PATH
export PATH="/home/yasith/anaconda3/bin:$PATH"

# add appengine to the PATH
export PATH=$PATH:~/Apps/google_appengine/

# disable the system bell
xset -b

function java-font-patch() {
  export JAVA_HOME=~/Apps/jdk-8u5-tuxjdk-b08/
  export _JAVA_OPTIONS="-Dawt.useSystemAAFrontSettings=lcd -Dsun.java2d.xrender=true"
  export GNOME_DESKTOP_SESSION_ID=this-is-deprecated
}

alias studio="java-font-patch && sh ~/Apps/android-studio/bin/studio.sh"

function start-intellij(){
  IDEA_HOME=~/Apps/idea-IU-145.972.3
  exec $IDEA_HOME/bin/idea.sh "$@"
}
alias intellij="java-font-patch && start-intellij"

alias pycharm="java-font-patch && sh /home/yasith/Apps/pycharm-4.5.3_old/bin/pycharm.sh"

alias webstorm="java-font-patch && sh /home/yasith/Apps/WebStorm-143.1559.5/bin/webstorm.sh"
