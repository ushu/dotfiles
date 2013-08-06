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

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
source ~/.nvm/nvm.sh
