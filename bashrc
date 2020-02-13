export EDITOR=vim

# Special setup for the "Work" directory
if [ -d "/Volumes/Work" ]; then
  [ -d "/Volumes/Work/WIP" ] || mkdir -p "/Volumes/Work/WIP"
  export WIP_DIR="/Volumes/Work"
  # also make a symlink unless exists
  [ -d "$HOME/WIP" ] || [ -h "$HOME/WIP" ] || ls -s "$WIP_DIR/WIP" "$HOME/WIP"
else
  mkdir -p "$HOME/WIP"
  export WIP_DIR="$HOME/WIP"
fi

# preload vars
if [ -f "$HOME/.bashrc_cache" ]; then
  source "$HOME/.bashrc_cache"
fi

# General Homebrew prefix
if [ -z "$BREW_PREFIX" ]; then
  BREW_PREFIX=$(brew --prefix)
fi 

# Add HOME/bin to PATH
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

# Install in /Application on "brew cask install ..."
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Java/Android HOME (needed by dev tools)
if [ -z "$JAVA_HOME" ] || [ ! -d "$JAVA_HOME" ] ; then
  JAVA_HOME=$(/usr/libexec/java_home)
fi
if [ -d "$WIP_DIR/android-sdk" ] && [ -w "$WIP_DIR/android-sdk" ]; then
  export ANDROID_HOME="$WIP_DIR/android-sdk"
elif [ -d "/Volumes/Storage/android-sdk" ]; then
  export ANDROID_HOME="/Volumes/Storage/android-sdk"
else
  export ANDROID_HOME="${HOME}/Library/Android/sdk"
fi
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

# GO
if [ -d "$WIP_DIR/go" ] && [ -w "$WIP_DIR/go" ] ; then
  export GOPATH="$WIP_DIR/go"
  [ -d "$GOPATH" ] || mkdir "$GOPATH"
else
  export GOPATH="$HOME/go"
fi
#export GOMAXPROCS=1
export PATH="$PATH:$GOPATH/bin"

# Update paths
PATH_EXTENSIONS="$HOME/go_appengine:/usr/local/bin"
export PATH="$PATH_EXTENSIONS:$PATH"

if [ -e "/Library/TeX/texbin" ];then
  export PATH="$PATH:/Library/TeX/texbin"
fi

# Git: completion & custom aliases
source "$BREW_PREFIX/etc/bash_completion.d/git-completion.bash"

# Aliases
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

# Needed by python-build on Mojave
export SDKROOT="$(xcrun --show-sdk-path)"
# Setup virtualenvwrapper
if [ -z "$PYTHON3_VERSION" ] || [ ! -z "$PYTHON_VERSION" ]; then
    PYTHON3_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
fi
if [ -e "/usr/local/bin/virtualenvwrapper.sh" ];then
  export WORKON_HOME="$HOME/.virtualenvs"
  export VIRTUALENVWRAPPER_PYTHON="/usr/local/bin/python${PYTHON3_VERSION}"
  source "/usr/local/bin/virtualenvwrapper.sh"
fi

# Sources completions & co
if [ -d "$BREW_PREFIX/Caskroom/google-cloud-sdk/latest" ]; then
  source "$BREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc" 
  source "$BREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
fi

# reorder path(s) for homebrew usage
export PATH="/usr/local/sbin:/usr/local/bin/:$PATH"

# ASDF
if [ -d "$HOME/.asdf" ]; then
  source "$HOME/.asdf/asdf.sh"
  source "$HOME/.asdf/completions/asdf.bash"
  export PATH="$(yarn global bin):$PATH"
fi

# anaconda
conda() {
  if [ -d "$HOME/.miniconda/bin" ]; then
    export PATH="$HOME/.miniconda/bin:$PATH"
  fi
  __conda_setup="$($HOME/.miniconda/bin/conda 'shell.bash' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
     eval "$__conda_setup"
  fi
  conda $@
}

# Custom prompt
PS1="\W \$ "
if [ -f "$BREW_PREFIX/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    source "$BREW_PREFIX/opt/bash-git-prompt/share/gitprompt.sh"
fi

if [ -e "$HOME/.custom_shell_scripts" ]; then
  source "$HOME/.custom_shell_scripts"
fi
if [ -e "$HOME/.bash_local_scripts" ]; then
  source "$HOME/.bash_local_scripts"
fi


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
