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

# Generate a random password
randompwd() {
  openssl rand -base64 2048 | tr '\n' '+' | sed -e 's/[\n\/=+]//g' | cut -c1-${1:-50} | head -n1
}

# Custom prompt
PS1="\W \$ "
if [ -f "$BREW_PREFIX/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    source "$BREW_PREFIX/opt/bash-git-prompt/share/gitprompt.sh"
fi

# Open Chrome Canary with CORS disables
nocors() {
  if [ ! -d "$HOME/.Chrome" ]; then mkdir "$HOME/.Chrome"; fi
  open -a Google\ Chrome --args --disable-web-security --user-data-dir="$HOME/.Chrome"
}

# Open the iCloud Drive folder
ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
icloud() {
  cd "$ICLOUD"
}

