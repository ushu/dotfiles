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

################################################################################
# Options
################################################################################

source ~/.nvm/nvm.sh

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

################################################################################
# Custom commands
################################################################################

rn() {
  rails new $1 -m "$HOME/.dotfiles/rails_template.rb" -T -B
}
alias d="git dc"
alias s="git st"
alias l="git lg"
alias ac="git aa && git ci"
alias ci="git ci"
