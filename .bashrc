export EDITOR=vim

# Load cached values
if [ -e ~/.bashrc_cache ]; then
    source ~/.bashrc_cache
else
    touch ~/.bashrc_cache
fi

if [ -z "$BREW_PREFIX" ]; then
    BREW_PREFIX=$(brew --prefix)
    echo "# Generic prefix for Homebrew installs" >> ~/.bashrc_cache
    echo "BREW_PREFIX=\"$BREW_PREFIX\"" >> ~/.bashrc_cache
    echo >> ~/.bashrc_code
fi

# Install in /Application on "brew cask install ..."
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Java/Android HOME (needed by dev tools)
if [ -z "$JAVA_HOME" ]; then
    echo "# Current version of JAVA" >> ~/.bashrc_cache
    JAVA_HOME=$(/usr/libexec/java_home)
    echo "JAVA_HOME=\"$JAVA_HOME\"" >> ~/.bashrc_cache
    echo >> ~/.bashrc_code
fi
export ANDROID_HOME="${HOME}/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

# NVM
export NVM_DIR=~/.nvm
if [ -z "$BREW_PREFIX_NVM" ]; then
    echo "# nvm install dir" >> ~/.bashrc_cache
    BREW_PREFIX_NVM=$(brew --prefix nvm)
    echo "BREW_PREFIX_NVM=\"$BREW_PREFIX_NVM\"" >> ~/.bashrc_cache
    echo >> ~/.bashrc_code
fi
# Lazy loading for nvm.sh
nvm() {
  source "$BREW_PREFIX_NVM/nvm.sh" # This loads nvm
  nvm $@
}

# GO
export GOPATH="$HOME"
export GOMAXPROCS=1
export PATH="$PATH:$GOPATH/bin"

# Update paths
PATH_EXTENSIONS="$HOME/go_appengine:/usr/local/bin"
export PATH="$PATH_EXTENSIONS:$PATH"

if [ -e "/Library/TeX/texbin" ];then
  export PATH="$PATH:/Library/TeX/texbin"
fi

# RBENV & Ruby
# (lazy load rbenv)
rbenv() {
  eval "$($BREW_PREFIX/bin/rbenv init -)"
  rbenv $@
}
alias be="bundle exec"
# fix crazy yarn/rbenv issue
alias yarn="/usr/local/bin/yarn"

# Faster fzf using silver searcher
export FZF_DEFAULT_COMMAND='ag -l -g ""'

# Git: completion & custom aliases
source /usr/local/etc/bash_completion.d/git-completion.bash

# Change Terminal window title (to allow Timingapp tracking)
if [[ "$TERM_PROGRAM" != "iTerm.app" ]]; then
  export PROMPT_TITLE='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
  export PROMPT_COMMAND="${PROMPT_COMMAND};${PROMPT_TITLE}"
fi

alias l="git lg"
alias cl="git changelog master..HEAD"
alias d="git dc"
alias s="git status"
alias ac="git aa && git ci"
alias ci="git ci"
alias be="bundle exec"

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
