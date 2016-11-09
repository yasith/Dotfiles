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

# Easy prodaccess
alias pa="prodaccess"

# Git5 shortcuts
alias g5="git5"
alias gs="git5 sync"
alias ge="git5 export -d \"\""
alias gm="git5 mail"
alias gl="git5 lint"
alias gf="git5 fix"
alias gps="git5 export -p all --tap-options=detach,email --ignore-presubmit-warnings"

# For ASwB
export STUDIO_VM_OPTIONS=~/.studio64.vmoptions
alias aswb="/opt/android-studio-with-blaze-current/bin/studio-launcher.sh"
# When you want to kill ASwB when Chromoting
alias killaswb='ps -Af | egrep "aswb|blaze" | awk '\''{print $2}'\'' | xargs kill -9'

# Crow (Android emulator)
fpath=(/google/data/ro/teams/mobile_eng_prod/crow $fpath)
compdef _crow /google/data/ro/teams/mobile_eng_prod/crow/crow.par
alias crow=/google/data/ro/teams/mobile_eng_prod/crow/crow.par

# Enable adb.turbo go/adb.turbo
function adb() {
  EMU_DEPS=/google/data/ro/teams/mobile_eng_prod/emu/live/google3/
  ANDROID_SDK=${EMU_DEPS}/third_party/java/android/android_sdk_linux/
  EMU_SUPPORT=${EMU_DEPS}/tools/android/emulator/support/
  ANDROID_ADB=/usr/bin/adb
  ANDROID_ADB=${ANDROID_ADB} $EMU_SUPPORT/adb.turbo "$@"
}

# Tricoder
alias tricoder="/google/data/ro/teams/tricorder/tricorder"

# Jetstream builds
alias jsbuild="blaze build java/com/google/android/apps/access/wifi/consumer/app:jetstream_debug"
alias jsdeploy="adb install -r blaze-bin/java/com/google/android/apps/access/wifi/consumer/app/jetstream_debug.apk"
alias jsrun="adb shell monkey -p com.google.android.apps.access.wifi.consumer 1"
alias bdr="jsbuild && jsdeploy && jsrun"

# For tmux
alias ta="tmux attach-session -t "
