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
LATEST_RUBY="2.4.1"
export MANPATH="/usr/local/man"
LOGFILE="$DOTFILES/install.log"

# List of components to install
PYTHON_PIPS=(httpie scipy matplotlib jupyter virtualenv virtualenvwrapper)
RUBY_GEMS=(rails sass jekyll solargraph)
NODE_MODULES=(grunt-cli gulp bower yo webpack eslint babel ttab)

main() {
  # Reset logfile
  echo "BOOTING INSTALL SCRIPT @ $(date)" >"$LOGFILE"

  i_log "🚀 🚀  Starting the install process 🚀 🚀"
  i_log

  # Check we are not on linux
  UNAME=$(uname)
  if [ "$UNAME" != "Darwin" ]; then
      i_log "oups, this script is intended to run on a mac !"
      exit 1
  fi

  # Add some default message on failure
  trap "i_log;i_log '☠️ ☠️  Installation failed. ☠️ ☠️ '" EXIT

  retreive_dotfiles
  update_symlinks
  install_or_update_homebrew
  install_or_update_node
  install_or_update_python
  install_or_update_ruby
  install_or_update_rust
  install_vim_plugins

  trap - EXIT

  i_log
  i_log "We're done !"
  i_log "It's time tu add your secret settings to ~/.secrets"
  i_log
  i_log "for example put your API tokens in it:"
  i_log "  export HOMEBREW_GITHUB_API_TOKEN=\"...\""
  i_log
  i_log "Side note: MacTex was not installed since it's soooo big,"
  i_log "do it when needed with:"
  i_log "  brew cask install MacTex"
  i_log
  i_log "🎉 🎉  Installation complete 🎉 🎉 "
}

# Clone or Update local copy of repo
retreive_dotfiles() {
  # Grab all files in ~/.dotfiles
  if [ -e "$HOME/.dotfiles" ]; then
    i_log "Found previous installation, trying to update the files..."
    cd "$HOME/.dotfiles"
    git pull --depth=1 --force -q >>"$LOGFILE" 2>&1
  else
    i_log "Retreiving files from github.com/ushu/dotfiles..."
    git clone --depth=1 --single-branch -q https://github.com/ushu/dotfiles "$DOTFILES" >>"$LOGFILE" 2>&1
  fi
}

# Linking files in HOME
update_symlinks() {
  i_log "Updating symlinks"
  # secrets
  [ -e "$HOME/.secrets" ] || touch "$HOME/.secrets"
  # vim config
  [ -e "$HOME/.vimrc" ] || ln -s "$DOTFILES/vimrc" "$HOME/.vimrc"
  [ -e "$HOME/.vim" ] || mkdir "$HOME/.vim"
  [ -e "$HOME/.editorconfig" ] || ln -s "$DOTFILES/.editorconfig" "$HOME/.editorconfig"
  # VSCode config
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
  [ -e "$HOME/.mutt/mutt-colors-solarized-dark-256.muttrc" ] || ln -s "$DOTFILES/mutt-colors-solarized-dark-256.muttrc" "$HOME/.mutt/mutt-colors-solarized-dark-256.muttrc"
  [ -e "$HOME/.signature" ] || ln -s "$DOTFILES/signature" "$HOME/.signature"
  [ -e "$HOME/.mailcap" ] || ln -s "$DOTFILES/mailcap" "$HOME/.mailcap"
}

install_or_update_homebrew() {
  # looking up brew command (see https://stackoverflow.com/a/677212 for details)
  if command -v brew >/dev/null 2>&1; then
    i_log "Updating Homebrew"
    brew update >>"$LOGFILE"
  else
    # Run the installer from https://brew.sh
    i_log "Homebrew not found: launching the installer"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    hash -r
  fi

  # install all the packages by reading the Brewfile
  i_log "Installing Homebrew packages"
  brew tap --repair homebrew/bundle >>"$LOGFILE"
  brew bundle --file="$DOTFILES/Brewfile" --no-update >>"$LOGFILE" 2>&1
}

install_or_update_node() {
  # Ensure nvm is loaded
  command -v nvm >/dev/null 2>&1 || source "$(brew --prefix nvm)/nvm.sh"

  i_log "Installing the latest version of node"
  nvm install node >>"$LOGFILE" 2>&1
  nvm alias default node >>"$LOGFILE" 2>&1
  hash -r

  i_log "Configuring yarn"
  yarn config set init-author-name "$NAME"
  yarn config set init-author-email "$EMAIL"
  yarn config set init-license "MIT"
  yarn config set yarn-offline-mirror .yarn-offline-cache
  yarn config set yarn-offline-mirror-pruning true

  i_log "Installing basic node tools"
  nvm use node >>"$LOGFILE" 2>&1
  yarn global add "${NODE_MODULES[@]}" >>"$LOGFILE" 2>&1
  hash -r
}

install_or_update_python() {
  i_log "Intalling pip"
  easy_install-2.7 pip >>"$LOGFILE" 2>&1
  easy_install-3.6 pip >>"$LOGFILE" 2>&1

  i_log "Installing/updating defaults libs and tools"
  pip2 install -U "${PYTHON_PIPS[@]}" >>"$LOGFILE" 2>&1
  pip3 install -U "${PYTHON_PIPS[@]}" >>"$LOGFILE" 2>&1
}

install_or_update_ruby() {
  i_log "Installing latest Ruby"
  rbenv install "$LATEST_RUBY" --skip-existing >>"$LOGFILE" 2>&1
  rbenv local "$LATEST_RUBY" >>"$LOGFILE" 2>&1
  echo "$LATEST_RUBY" > "$HOME/.ruby-version"

  i_log "Installing/updating defaults libs and tools"
  gem install "${RUBY_GEMS[@]}" --no-ri --no-rdoc >>"$LOGFILE" 2>&1
}

install_or_update_rust() {
  i_log "Installing rust"
  rustup update stable >>"$LOGFILE" 2>&1
  rustup component add rls-preview rust-analysis rust-src rustfmt-preview
  cargo install --force rustsym
}

install_vim_plugins() {
  i_log "Installing/Updating vim plugins"
  if [ ! -e "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi 
  vim -E +"PlugInstall" +qall
}

# Log to both stdout and output file (w/ prefix)
i_log() {
  echo "$@"
  echo ">>>>" "$@" >>"$LOGFILE"
}

main
