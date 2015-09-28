#!/usr/bin/env sh


if uname -a | grep -Fqs "Darwin"
then
  echo "Found OSX"
else
  echo "Sorry, unsupported OS"
  exit 1
fi

# output all on stdin
exec 2>&1

set -a

######################################################################
# Configure shell
######################################################################

PREZTOR_DIR="${ZDOTDIR:-$HOME}/.zprezto"
if ! [[ -d "$PREZTOR_DIR" ]]; then
  # Clone source
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "$PREZTOR_DIR"

  # Copy default configs
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
fi

if [[ "$SHELL" != "/bin/zsh" ]]; then
  echo "Setting SHELL to zsh"
  chsh -s /bin/zsh
fi

######################################################################
# Copy config files
######################################################################

DOTFILES="$HOME/.dotfiles"

function clone_config() {
  if [[ -d "$DOTFILES" ]]; then
    cd "$DOTFILES"; git pull origin master
  else
    git clone --recursive https://github.com/ushu/dotfiles "$DOTFILES"
  fi
}
clone_config

function create_symlinks() {
  # Linking files in HOME
  # vim config
  [ -f "$HOME/.vimrc" ] || ln -s "$DOTFILES/.vimrc" "$HOME/.vimrc"
  [ -d "$HOME/.vim" ] || mkdir "$HOME/.vim"
  [ -f "$HOME/.editorconfig" ] || ln -s "$DOTFILES/.editorconfig" "$HOME/.editorconfig"
  # git config
  [ -f "$HOME/.gitconfig" ] || ln -s "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
  # shell configs
  [ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc-old"
  ln -s "$DOTFILES/.zshrc" "$HOME/.zshrc"
  [ -f "$HOME/.bashrc" ] || ln -s "$DOTFILES/.bashrc" "$HOME/.bashrc"
  # default options for rails new ...
  [ -f "$HOME/.railsrc" ] || ln -s "$DOTFILES/.railsrc" "$HOME/.railsrc"
  # tmux config
  [ -f "$HOME/.tmux.conf" ] || ln -s "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
}
create_symlinks


######################################################################
# Update the config files
######################################################################

# Create the .bash_profile if necessary
test -f ~/.bash_profile || echo "[[ -s ~/.bashrc ]] && source ~/.bashrc" >> .bash_profile

function config() {
  local cmd="$1"
  if ! grep -Fqs "$cmd" ~/.bashrc >/dev/null; then echo "$cmd" >> ~/.bashrc; fi
  if ! grep -Fqs "$cmd" ~/.zshrc >/dev/null; then echo "$cmd" >> ~/.zshrc; fi
}

function run_and_config() {
  eval "$1" >/dev/null
  config "$1"
}


######################################################################
# Homebrew
######################################################################

function install_homebrew() {
  # Install homebrew
  if command -v brew >/dev/null
  then
    echo "Updating Homebrew"
  else
    echo "Homebrew not found: installing"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" >/dev/null
  fi

  # installing brews
  cd "$DOTFILES"
  brew tap --repair homebrew/bundle >/dev/null
  brew bundle >/dev/null
}
install_homebrew

function patch_paths() {
  if ! cat /etc/paths | head -n1 | grep -Fqs "/usr/local/bin"; then
    echo "patch /etc/paths (old version in $DOTFILES/.paths.backup)"
    cp /etc/paths .paths.backup
    sed '/[/]usr[/]local[/]s*bin/d' /etc/paths | sed '1 i\
/usr/local/bin
'   > "$DOTFILES/paths"
  fi
}
patch_paths


######################################################################
# Install node with nvm
######################################################################

run_and_config "source $(brew --prefix nvm)/nvm.sh"

function install_nvm() {
  echo "Installing node.js"
  # Install node 0.10 and 0.12
  nvm install -s "0.10" >/dev/null
  nvm install -s "0.12" >/dev/null
  # Set 0.12 as the default
  nvm alias default "0.12" >/dev/null

  echo "Installing node.js programs"
  # Install the commands
  nvm use "0.12" >/dev/null
  npm install --global grunt-cli gulp less bower yo express csslint cordova ionic >/dev/null
}
install_nvm


######################################################################
# Install Ruby
######################################################################

# Load chruby
run_and_config "source $(brew --prefix chruby)/share/chruby/chruby.sh"

function add_ruby() {
  local version="$1"
  local rubies=$(chruby)
  if ! echo "$rubies" | grep -Fqs "$version"; then
    echo "Installing ruby v$1"
    ruby-install ruby "$1" >/dev/null
  fi

  # reload chruby
  source $(brew --prefix chruby)/share/chruby/chruby.sh
}

function add_gems() {
  local gems="$@"
  local local_gems=$(gem list)
  for gem in $gems; do
    if ! echo "$local_gems" | grep -Fqs "$gem"; then
      echo "Installing $gem"
      gem install "$gem" --no-ri --no-rdoc >/dev/null
    fi
  done
}

function install_ruby() {
  add_ruby "2.2.3"

  # Loading ruby 2.2.3
  chruby "2.2.3"

  echo "Installing gems"
  # Tools
  add_gems bundler pry sass rails vagrant cocoapods
  # Libs
  add_gems pry compass
}
install_ruby

######################################################################
# Configure vim
######################################################################

function install_vim() {
  if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
    echo "Installing vimplug"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim>/dev/null
  fi

  # Install vim plugins
  vim -E +PlugInstall +qall
}
install_vim


