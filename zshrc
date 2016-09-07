# Alias for reloading the zshrc file
alias zshrc="source ~/.zshrc"

# Path to your oh-my-zsh configuration.
ZSH=$HOME/dotfiles/oh-my-zsh

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
 DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# disable the system bell
xset -b

# Google specific shortcuts

# Git5 shortcuts
alias g5="git5"
alias gs="git5 sync"
alias ge="git5 export"
alias gm="git5 mail"

# For ASwB
export STUDIO_VM_OPTIONS=~/.studio64.vmoptions
alias aswb="/opt/android-studio-with-blaze-current/bin/studio-launcher.sh"

# Crow (Android emulator)
fpath=(/google/data/ro/teams/mobile_eng_prod/crow $fpath)
compdef _crow /google/data/ro/teams/mobile_eng_prod/crow/crow.par
alias crow=/google/data/ro/teams/mobile_eng_prod/crow/crow.par

# Enable adb.turbo go/adb.turbo
function adb() {
  EMU_DEPS=/google/data/ro/teams/mobile_eng_prod/emu/live/google3/
  ANDROID_SDK=${EMU_DEPS}/third_party/java/android/android_sdk_linux/
  EMU_SUPPORT=${EMU_DEPS}/tools/android/emulator/support/
  ANDROID_ADB=${ANDROID_SDK}/platform-tools/adb
  ANDROID_ADB=${ANDROID_ADB} $EMU_SUPPORT/adb.turbo "$@"
}
