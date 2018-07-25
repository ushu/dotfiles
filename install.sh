#!/usr/bin/env bash
# shellcheck source=/dev/null

# Run this file with:
#
#   $ curl https://raw.githubusercontent.com/ushu/dotfiles/master/install.sh | bash
#

# General options
set -e
set -u

NAME="Aurélien Noce"
EMAIL="aurnoce@gmail.com"
DOTFILES="$HOME/.dotfiles"
RUBY_VERSION="2.5.1"

export MANPATH="/usr/local/man"

# List of components to install
PYTHON_PIPS=(httpie scipy matplotlib jupyter)
RUBY_GEMS=(rails sass jekyll)
NODE_MODULES=(express create-react-app react-native create-react-native-app)

main() {
  # Reset logfile
  echo "BOOTING INSTALL SCRIPT @ $(date)"

  echo "🚀 🚀  Starting the install process 🚀 🚀"
  echo

  # Check we are not on linux
  UNAME=$(uname)
  if [ "$UNAME" != "Darwin" ]; then
      echo -e "oups, this script is intended to run on a mac !"
      exit 1
  fi

  # Add some default message on failure
  trap "echo;echo '☠️ ☠️  Installation failed. ☠️ ☠️ '" EXIT

  retreive_dotfiles
  update_symlinks
  install_or_update_homebrew
  install_or_update_node
  install_or_update_python
  install_or_update_ruby
  install_or_update_rust
  install_vim_plugins

  trap - EXIT

  echo
  echo "We're done !"
  echo "It's time tu add your secret settings to ~/.secrets"
  echo
  echo "for example put your API tokens in it:"
  echo "  export HOMEBREW_GITHUB_API_TOKEN=\"...\""
  echo
  echo "Side note: MacTex was not installed since it's soooo big,"
  echo "do it when needed with:"
  echo "  brew cask install MacTex"
  echo
  echo "🎉 🎉  Installation complete 🎉 🎉 "
}

# Clone or Update local copy of repo
retreive_dotfiles() {
  if [ -e "$HOME/.dotfiles" ] && [ ! -e "$HOME/.dotfiles/.git" ] ; then
    echo "Found buggy previous installation, cleaning up..."
    rm -rf "$HOME/.dotfiles" 
  fi
  
  # Grab all files in ~/.dotfiles
  if [ -e "$HOME/.dotfiles" ]; then
    echo "Found previous installation, trying to update the files..."
    cd "$HOME/.dotfiles"
    git pull --depth=1 --force -q 
  else
    echo "Retreiving files from github.com/ushu/dotfiles..."
    git clone --depth=1 --single-branch -q https://github.com/ushu/dotfiles "$DOTFILES" 
  fi
}

# Linking files in HOME
update_symlinks() {
  echo "Updating symlinks"
  # secrets
  [ -e "$HOME/.secrets" ] || touch "$HOME/.secrets"
  # vim config
  [ -e "$HOME/.vimrc" ] || ln -s "$DOTFILES/vimrc" "$HOME/.vimrc"
  [ -e "$HOME/.vim" ] || mkdir "$HOME/.vim"
  [ -e "$HOME/.editorconfig" ] || ln -s "$DOTFILES/.editorconfig" "$HOME/.editorconfig"
  # VSCode config
  [ -d "$HOME/Library/Application Support/Code/User" ] || mkdir -p "$HOME/Library/Application Support/Code/User"
  [ -e "$HOME/Library/Application Support/Code/User/settings.json" ] || ln -s "$DOTFILES/vscode-settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
  [ -e "$HOME/Library/Application Support/Code/User/keybindings.json" ] || ln -s "$DOTFILES/vscode-keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
  [ -e "$HOME/Library/Application Support/Code/User/locale.json" ] || ln -s "$DOTFILES/vscode-locale.json" "$HOME/Library/Application Support/Code/User/locale.json"
  # git config
  [ -e "$HOME/.gitconfig" ] || ln -s "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
  # shell configs
  [ -e "$HOME/.profile" ] || ln -s "$DOTFILES/.profile" "$HOME/.profile"
  [ -e "$HOME/.bashrc" ] || ln -s "$DOTFILES/.bashrc" "$HOME/.bashrc"
  [ -e "$HOME/.bash_custom_scripts" ] || ln -s "$DOTFILES/.bash_custom_scripts" "$HOME/.bash_custom_scripts"
  [ -e "$HOME/.tmux.conf" ] || ln -s "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
  # default options for Ruby/Rails
  [ -e "$HOME/.railsrc" ] || ln -s "$DOTFILES/.railsrc" "$HOME/.railsrc"
  [ -e "$HOME/.pryrc" ] || ln -s "$DOTFILES/.pryrc" "$HOME/.pryrc"
  [ -e "$HOME/.bundle" ] || mkdir "$HOME/.bundle"
  [ -e "$HOME/.bundle/config" ] || ln -s "$DOTFILES/.bundle.config" "$HOME/.bundle/config"
  # tmux config
  [ -e "$HOME/.tmux.conf" ] || ln -s "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
  # useful scripts
  [ -e "$HOME/bin" ] || mkdir "$HOME/bin"
  [ -e "$HOME/bin/gen-cert" ] || ln -s "$DOTFILES/bin/gen-cert" "$HOME/bin/gen-cert"
  [ -e "$HOME/bin/gen-cert-no-ca" ] || ln -s "$DOTFILES/bin/gen-cert-no-ca" "$HOME/bin/gen-cert-no-ca"
  if [ ! -e "$HOME/.emacs.d/" ]; then
      git clone https://github.com/syl20bnr/spacemacs "$HOME/.emacs.d"
      ln -s "$DOTFILES/.spacemacs" "$HOME"
      mv "$HOME/.emacs.d/private/snippets" "$HOME/.emacs.d/private/snippets_old"
      ln -s "$DOTFILES/.emacs.d/private/snippets" "$HOME/.emacs.d/private"
  fi
  [ -e "$HOME/.config/nvim" ] || mkdir -p "$HOME/.config/nvim"
  [ -e "$HOME/.config/nvim/init.vim" ] || ln -s "$DOTFILES/vimrc" "$HOME/.config/nvim/init.vim"
  [ -e "$HOME/.mutt/cache" ] || mkdir -p "$HOME/.mutt/cache"
  [ -e "$HOME/.mutt/muttrc" ] || ln -s "$DOTFILES/muttrc" "$HOME/.mutt/muttrc"
  [ -e "$HOME/.signature" ] || ln -s "$DOTFILES/signature" "$HOME/.signature"
  [ -e "$HOME/.mailcap" ] || ln -s "$DOTFILES/mailcap" "$HOME/.mailcap"
}

install_or_update_homebrew() {
  # looking up brew command (see https://stackoverflow.com/a/677212 for details)
  if command -v brew >/dev/null 2>&1; then
    echo "Updating Homebrew"
    brew update 
  else
    # Run the installer from https://brew.sh
    echo "Homebrew not found: launching the installer"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    hash -r
  fi

  # install all the packages by reading the Brewfile
  echo "Installing Homebrew packages"
  brew tap --repair homebrew/bundle 
  brew bundle --file="$DOTFILES/Brewfile" --no-update 
}

install_or_update_node() {
  # Ensure nvm is loaded
  source "$(brew --prefix nvm)/nvm.sh"

  echo "Installing the latest version of node"
  nvm install node 
  nvm alias default node 
  hash -r

  echo "Configuring yarn"
  yarn config set init-author-name "$NAME"
  yarn config set init-author-email "$EMAIL"
  yarn config set init-license "MIT"
  yarn config set yarn-offline-mirror .yarn-offline-cache
  yarn config set yarn-offline-mirror-pruning true

  echo "Installing basic node tools"
  nvm use node 
  yarn global add "${NODE_MODULES[@]}" 
  hash -r
}

install_or_update_python() {
  echo "Intalling pip"
  easy_install pip 

  echo "Installing/updating defaults libs and tools"
  pip install -U "${PYTHON_PIPS[@]}" 
}

install_or_update_ruby() {
  echo "Installing latest Ruby"
  rbenv install "$RUBY_VERSION" --skip-existing 
  rbenv local "$RUBY_VERSION"
  echo "$RUBY_VERSION" > "$HOME/.ruby-version"

  echo "Installing/updating defaults libs and tools"
  gem install "${RUBY_GEMS[@]}" --no-ri --no-rdoc 
}

install_or_update_rust() {
  echo "Installing rust"
  rustup update stable 
}

install_vim_plugins() {
  echo "Installing/Updating vim plugins"
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -E +"PlugInstall" +qall
}


main
