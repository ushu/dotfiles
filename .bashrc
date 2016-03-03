export NVM_DIR=~/.nvm
source "$NVM_DIR/nvm.sh"
#source $(brew --prefix nvm)/nvm.sh

source $(brew --prefix chruby)/share/chruby/chruby.sh
source $(brew --prefix chruby)/share/chruby/auto.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
