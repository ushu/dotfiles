################################################################################
# Load oh-my-zsh
################################################################################

ZSH=$HOME/.oh-my-zsh

# theme
ZSH_THEME="cloud"
# plugins
plugins=(git rails ruby)

source $ZSH/oh-my-zsh.sh
# disable autocorrect
unsetopt correct_all

export PATH="$PATH:./node_modules/.bin"
export PATH="$PATH:$HOME/.dotfiles/bin"
export PATH="$PATH:$GOPATH/bin"

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

################################################################################
# Custom commands
################################################################################

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
