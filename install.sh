#!/usr/bin/env bash

# Run this file with:
#
#   $ curl https://raw.githubusercontent.com/ushu/dotfiles/master/install.sh | bash
#

# General options
set -e
set -u

DOTFILES="$HOME/.dotfiles"
LATEST_RUBY="2.4.0"
export MANPATH="/usr/local/man"

main() {
  echo "🚀 🚀  Starting the install process 🚀 🚀"
  echo

  # Check we are not on linux
  UNAME=$(uname)
  if [ "$UNAME" != "Darwin" ]; then
      echo "oups, this script is intended to run on a mac !"
      exit 1
  fi

  # Add some default message on failure
  trap "echo;echo '☠️ ☠️  Installation failed. ☠️ ☠️ '" EXIT

  retreive_dotfiles
  update_symlinks
  install_or_update_homebrew
  install_or_update_node
  install_or_update_ruby
  install_vim_plugins

  trap - EXIT

  echo
  echo "We're done !"
  echo "It's time tu add your secret settings to ~/.secrets"
  echo
  echo "for example put your API tokens in it:"
  echo "  export HOMEBREW_GITHUB_API_TOKEN=\"...\""
  echo
  echo "🎉 🎉  Installation complete 🎉 🎉 "
}

# Clone or Update local copy of repo
retreive_dotfiles() {
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
  [ -e "$HOME/.vimrc" ] || ln -s "$DOTFILES/.vimrc" "$HOME/.vimrc"
  [ -e "$HOME/.vim/pack" ] || mkdir -p "$HOME/.vim/pack"
  [ -e "$HOME/.vim/pack/install.sh" ] || ln -s "$DOTFILES/pack.sh" "$HOME/.vim/pack/install.sh"
  [ -e "$HOME/.editorconfig" ] || ln -s "$DOTFILES/.editorconfig" "$HOME/.editorconfig"
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
  [ -e "$HOME/.config/nvim/init.vim" ] || ln -s "$DOTFILES/init.vim" "$HOME/.config/nvim"
  [ -e "$HOME/.mutt/cache" ] || mkdir -p "$HOME/.mutt/cache"
  [ -e "$HOME/.mutt/muttrc" ] || ln -s "$DOTFILES/muttrc" "$HOME/.mutt/muttrc"
  [ -e "$HOME/.mutt/mutt-colors-solarized-dark-256.muttrc" ] || ln -s "$DOTFILES/mutt-colors-solarized-dark-256.muttrc" "$HOME/.mutt/mutt-colors-solarized-dark-256.muttrc"
  [ -e "$HOME/.signature" ] || ln -s "$DOTFILES/signature" "$HOME/.signature"
}

install_or_update_homebrew() {
  # looking up brew command (see https://stackoverflow.com/a/677212 for details)
  if command -v brew >/dev/null 2>&1; then
    echo "Updating Homebrew"
    brew update >/dev/null
  else
    # Run the installer from https://brew.sh
    echo "Homebrew not found: launching the installer"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    hash -r
  fi

  # install all the packages by reading the Brewfile
  echo "Installing Homebrew packages"
  brew tap --repair homebrew/bundle >/dev/null
  brew bundle --file="$DOTFILES/Brewfile" >/dev/null
}

install_or_update_node() {
  # Ensure nvm is loaded
  command -v nvm >/dev/null 2>&1 || source "$(brew --prefix nvm)/nvm.sh"

  echo "Installing the latest version of node"
  nvm install node >/dev/null 2>&1
  nvm alias default node >/dev/null
  hash -r

  echo "Installing basic node tools"
  nvm use node >/dev/null
  npm install -g grunt-cli gulp bower yo webpack eslint babel ttab >/dev/null 2>&1
  hash -r
}

install_or_update_ruby() {
  echo "Installing latest Ruby"
  rbenv install "$LATEST_RUBY" --skip-existing >/dev/null 2>&1
  echo "$LATEST_RUBY" > "$HOME/.ruby-version"
}

install_vim_plugins() {
  echo "Installing/Updating vim plugins"
  if [ ! -e "$HOME/.vim/dein/repos/github.com/Shougo/dein.vim" ]; then
    [ -e "$HOME/.vim/dein/repos/github.com/Shougo/dein.vim" ] || mkdir -p "$HOME/.vim/dein/repos/github.com/Shougo/dein.vim" >/dev/null
    git clone git@github.com:Shougo/dein.vim.git "$HOME/.vim/dein/repos/github.com/Shougo/dein.vim" >/dev/null 2>&1
  fi

  vim -E +"call dein#install()" +qall
}

main
