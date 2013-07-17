################################################################################
# Load oh-my-zsh
################################################################################

ZSH=$HOME/.oh-my-zsh

# theme
ZSH_THEME="wedisagree"
# plugins
plugins=(git rails ruby)

source $ZSH/oh-my-zsh.sh


################################################################################
# Options
################################################################################

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
source ~/.nvm/nvm.sh
