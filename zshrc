###
# Root-level constants
###

# Detect setup from context
BREW_PREFIX=$(brew --prefix)
PYTHON3_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
export JAVA_HOME="$(/usr/libexec/java_home)"

# Generic options
export EDITOR=vim
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export FZF_DEFAULT_COMMAND='ag -l -g ""'

# Configure Android build tools
if [ -d "/Volumes/WIP/android-sdk" ]; then
  export ANDROID_HOME="/Volumes/WIP/android-sdk"
elif [ -d "/Volumes/Storage/android-sdk" ]; then
  export ANDROID_HOME="/Volumes/Storage/android-sdk"
else
  export ANDROID_HOME="${HOME}/Library/Android/sdk"
fi

# Go{PATH|tools}
if [ -d "/Volumes/WIP" ]; then
  export WIPPATH="$HOME/WIP"
  [ -e "$WIPPATH" ] || [ -l "$WIPPATH" ] || ls -s "/Volumes/WIP" "$WIPPATH"
  export GOPATH="/Volumes/WIP/go"
  [ -d "$GOPATH" ] || mkdir "$GOPATH"
else
  export GOPATH="$HOME"
fi
#export GOMAXPROCS=1

# Setup virtualenvwrapper
if [ -e "/usr/local/bin/virtualenvwrapper.sh" ];then
  export WORKON_HOME="$HOME/.virtualenvs"
  export VIRTUALENVWRAPPER_PYTHON="/usr/local/bin/python${PYTHON3_VERSION}"
  source "/usr/local/bin/virtualenvwrapper.sh"
fi

# Uptate path(s)
ANDROID_PATH_EXT="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
GO_PATH_EXT="$PATH:$GOPATH/bin"
APPENGINE_PATH_EXT="$HOME/go_appengine" # /usr/local/bin ?
export PATH="$HOME/bin:$APPENGINE_PATH_EXT:$GO_PATH_EXT:$ANDROID_PATH_EXT:$PATH"
if [ -e "/Library/TeX/texbin" ];then
  export PATH="$PATH:/Library/TeX/texbin"
fi

###
# Plugins
###

ANTIGEN_PATH="$BREW_PREFIX/opt/antigen"
source "$ANTIGEN_PATH/share/antigen/antigen.zsh"

  # Activate Oh My ZSH framework
  antigen use oh-my-zsh

  # Load plugins
  antigen bundle git

  # Set active theme
  antigen theme robbyrussell

antigen apply

###
# Aliase(s)
###

# Ruby
alias be="bundle exec"
# Git
alias l="git lg"
alias cl="git changelog master..HEAD"
alias d="git diff --color"
alias s="git status"
alias ac="git add --all && git ci"
alias ci="git ci"
alias ginit="git init && git commit --allow-empty -m'Initial commit'"
alias be="bundle exec"
# Faster start for (spac|e)emacs
alias e="emacsclient  -a '' --no-wait -c"
# n|nv => neovim
alias nv="nvim"
alias n="nvim"

ASDF_PATH="$BREW_PREFIX/opt/asdf"
[ -e "$ASDF_PATH/asdf/sh" ] && source "$ASDF_PATH/asdf.sh"

