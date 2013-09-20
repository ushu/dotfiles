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

export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:./node_modules/.bin"

################################################################################
# Options
################################################################################

PATH=$HOME/.rvm/bin:$PATH
source ~/.nvm/nvm.sh

################################################################################
# Custom functions
################################################################################

rn () {
  rails new $1 -m $HOME/.dotfiles/rails_template.rb -B -T
}
