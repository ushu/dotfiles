export EDITOR=vim

# Load cached values
if [ -e ~/.bashrc_cache ]; then
    source ~/.bashrc_cache
else
    touch ~/.bashrc_cache
fi

# Add HOME/bin to PATh
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

if [ -z "$BREW_PREFIX" ]; then
    BREW_PREFIX=$(brew --prefix)
    echo "# Generic prefix for Homebrew installs" >> ~/.bashrc_cache
    echo "BREW_PREFIX=\"$BREW_PREFIX\"" >> ~/.bashrc_cache
    echo >> ~/.bashrc_cache
fi

# Install in /Application on "brew cask install ..."
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Java/Android HOME (needed by dev tools)
if [ -z "$JAVA_HOME" ] || [ ! -d "$JAVA_HOME" ] ; then
    echo "# Current version of JAVA" >> ~/.bashrc_cache
    JAVA_HOME=$(/usr/libexec/java_home)
    echo "JAVA_HOME=\"$JAVA_HOME\"" >> ~/.bashrc_cache
    echo >> ~/.bashrc_cache
fi
if [ -d "/Volumes/WIP/android-sdk" ]; then
  export ANDROID_HOME="/Volumes/WIP/android-sdk"
elif [ -d "/Volumes/Storage/android-sdk" ]; then
  export ANDROID_HOME="/Volumes/Storage/android-sdk"
else
  export ANDROID_HOME="${HOME}/Library/Android/sdk"
fi
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

# NVM
export NVM_DIR=~/.nvm
if [ -z "$BREW_PREFIX_NVM" ] || [ ! -d "$BREW_PREFIX_NVM" ]; then
    echo "# nvm install dir" >> ~/.bashrc_cache
    BREW_PREFIX_NVM=$(brew --prefix nvm)
    echo "BREW_PREFIX_NVM=\"$BREW_PREFIX_NVM\"" >> ~/.bashrc_cache
    echo >> ~/.bashrc_cache
fi
source "$BREW_PREFIX_NVM/nvm.sh" # This loads nvm

# GO

if [ -d "/Volumes/WIP" ]; then
  export WIPPATH="$HOME/WIP"
  [ -e "$WIPPATH" ] || [ -l "$WIPPATH" ] || ls -s "/Volumes/WIP" "$WIPPATH"
  export GOPATH="/Volumes/WIP/go"
  [ -d "$GOPATH" ] || mkdir "$GOPATH"
else
  export GOPATH="$HOME"
fi
#export GOMAXPROCS=1
export PATH="$PATH:$GOPATH/bin"

# Update paths
PATH_EXTENSIONS="$HOME/go_appengine:/usr/local/bin"
export PATH="$PATH_EXTENSIONS:$PATH"

if [ -e "/Library/TeX/texbin" ];then
  export PATH="$PATH:/Library/TeX/texbin"
fi

# RBENV & Ruby
eval "$($BREW_PREFIX/bin/rbenv init -)"
alias be="bundle exec"
# fix crazy yarn/rbenv issue
alias yarn="/usr/local/bin/yarn"

# Faster fzf using silver searcher
export FZF_DEFAULT_COMMAND='ag -l -g ""'

# Git: completion & custom aliases
source /usr/local/etc/bash_completion.d/git-completion.bash

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

# Custom prompt
PS1="\W \$ "
if [ -f "$BREW_PREFIX/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    source "$BREW_PREFIX/opt/bash-git-prompt/share/gitprompt.sh"
fi

if [ -e "$HOME/.bash_custom_scripts" ]; then
  source "$HOME/.bash_custom_scripts"
fi
if [ -e "$HOME/.bash_local_scripts" ]; then
  source "$HOME/.bash_local_scripts"
fi

# Setup virtualenvwrapper
if [ -z "$PYTHON3_VERSION" ] || [ ! -z "$PYTHON_VERSION" ]; then
    PYTHON3_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
    echo "# Installed Python3 version" >> ~/.bashrc_cache
    echo "PYTHON3_VERSION=\"$PYTHON3_VERSION\"" >> ~/.bashrc_cache
    echo >> ~/.bashrc_cache
fi
if [ -e "/usr/local/bin/virtualenvwrapper.sh" ];then
  export WORKON_HOME="$HOME/.virtualenvs"
  export VIRTUALENVWRAPPER_PYTHON="/usr/local/bin/python${PYTHON3_VERSION}"
  source "/usr/local/bin/virtualenvwrapper.sh"
fi

# Sources completions & co
if [ -d /usr/local/Caskroom/google-cloud-sdk/latest ];then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
fi


