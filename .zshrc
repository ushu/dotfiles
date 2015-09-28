################################################################################
# Load oh-my-zsh
################################################################################

# load PREZTO
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# disable autocorrect
unsetopt correct_all

export PATH="$PATH:./node_modules/.bin"
export PATH="$PATH:$HOME/.dotfiles/bin"
export PATH="$HOME/go_appengine:$PATH"

################################################################################
# Options
################################################################################

# load chruby functions
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

# enable nvm
source $(brew --prefix nvm)/nvm.sh
export NVM_DIR=~/.nvm

# don't enable cowsay in ansible
export ANSIBLE_NOCOWS=1

# Go needs this
export GOPATH="$HOME"
export PATH="$PATH:$GOPATH/bin"

# Faster fzf using ag
export FZF_DEFAULT_COMMAND='ag -l -g ""'

################################################################################
# Custom commands
################################################################################

alias n="nvim"
alias v="vim"
alias d="git dc"
alias s="git st"
alias l="git lg"
alias ac="git aa && git ci"
alias ci="git ci"
alias be="bundle exec"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

randompwd() {
  openssl rand -base64 64 | sed -e 's/[\/=+]//g' | cut -c1-50 | head -n1
}

# Enable zmv
autoload -U zmv

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Github personal token
[ -f ~/.github_token ] && source ~/.github_token

# Run Docker images
alias de='eval $(docker-machine env default)'
alias dr='docker run -ti -v "$PWD":/app --rm ruby:latest'
alias dp='docker run -ti -v "$PWD":/app --rm python:latest'
alias dn='docker run -ti -v "$PWD":/app --rm node:latest'

source /usr/local/opt/nvm/nvm.sh
