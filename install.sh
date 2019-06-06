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
EMAIL="aurelien@noce.fr"
DOTFILES="$HOME/.dotfiles"
REPO="https://github.com/ushu/dotfiles"

export MANPATH="/usr/local/man"

# List of components to install
PYTHON_PIPS=(httpie scipy matplotlib jupyter virtualenv virtualenvwrapper)
GO_PACKAGES=(
  # Go tools (for IDEs etc.)
  # First the "official" tools from Google
  "golang.org/x/tools/cmd/goimports" 
  "golang.org/x/tools/refactor/rename"
  "golang.org/x/tools/cmd/guru"
  "golang.org/x/lint/golint"
  # and a ton of additional tools too...
  # first the langage server
  "github.com/sourcegraph/go-langserver"
  # then a ton of additional tools
  "github.com/mgechev/revive"
  "github.com/mdempsky/gocode"
  "github.com/zmb3/gogetdoc"
  "github.com/lukehoban/go-outline"
  "github.com/newhook/go-symbols"
  "github.com/sqs/goreturns"
  "github.com/uudashr/gopkgs/cmd/gopkgs"
  "github.com/fatih/gomodifytags"
  "github.com/josharian/impl"
  "github.com/davidrjenni/reftools/cmd/fillstruct"
  "github.com/tylerb/gotype-live"
  "github.com/cweill/gotests"
  "github.com/go-delve/delve/cmd/dlv"
  # Firebase libs
  "firebase.google.com/go"
  "google.golang.org/api/option"
)

main() {
  # Reset logfile
  echo "BOOTING INSTALL SCRIPT @ $(date)"

  echo "🚀 🚀  Starting the install process 🚀 🚀"
  echo

  # Add some default message on failure
  trap "echo;echo '☠️ ☠️  Installation failed. ☠️ ☠️ '" EXIT

  # Check we are not on a mac
  UNAME=$(uname)
  if [ "$UNAME" != "Darwin" ]; then
      echo -e "oups, this script is intended to run on a mac !"
      exit 1
  fi
  # I want CLT installed !
  if [ "$(xcode-select -p)ok" == "ok" ]; then
      echo -e "oups, this script needs Xcode CLT installed !"
      exit 1
  fi

  retreive_dotfiles
  update_symlinks

  # Spacemacs
  if [ ! -d "$HOME/.emacs.d" ];then
    git clone https://github.com/syl20bnr/spacemacs "$HOME/.emacs.d"
  fi

  # For Mojave
  if [ ! -e /usr/include/zlib.h ];then
    if  [ -e /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg ];then
      echo "installing CLT headers..."
      sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
    else
      echo "Missing headers: install CLT first !"
    fi
  fi

  install_or_update_homebrew

  # ensure asdf is loaded !
  ZSH_VERSION=""
  source "$(brew --prefix asdf)/asdf.sh" 

  install_or_update_node
  install_or_update_python
  install_or_update_ruby
  install_or_update_go
  install_or_update_rust
  install_or_update_dart
  cleanup

  # Prepare bin directory
  [ -d "$HOME/bin" ] || mkdir "$HOME/bin"
  # And install other deps
  pushd "$HOME/bin"
    #...
  popd

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
  if [ -e "$DOTFILES" ] && [ ! -e "$DOTFILES/.git" ] ; then
    echo "Found broken installation, cleaning up..."
    rm -rf "$HOME/.dotfiles" 
  fi
  
  # Grab all files in ~/.dotfiles
  if [ -e "$DOTFILES" ]; then
    echo "Found previous installation, trying to update the files..."
    cd "$DOTFILES"
    git pull --depth=1 --force -q 
  else
    echo "Retreiving files from github.com/ushu/dotfiles..."
    git clone --depth=1 -q "$REPO" "$DOTFILES"
    cd "$DOTFILES"
  fi
  git submodule update --init --recursive -q
}

# Linking files in HOME
update_symlinks() {
  echo "Updating symlinks"
  # secrets
  [ -e "$HOME/.secrets" ] || touch "$HOME/.secrets"
  # vim config
  [ -e "$HOME/.vimrc" ] || [ -L "$HOME/.vimrc" ] || ln -s "$DOTFILES/vimrc" "$HOME/.vimrc"
  [ -d "$HOME/.vim" ] || [ -L "$HOME/.vim" ] || ln -s "$DOTFILES/vim" "$HOME/.vim"
  [ -e "$HOME/.editorconfig" ] || [ -L "$HOME/.editorconfig" ] || ln -s "$DOTFILES/editorconfig" "$HOME/.editorconfig"
  # "root" git config
  [ -e "$HOME/.gitconfig" ] || [ -L "$HOME/.gitconfig" ] || ln -s "$DOTFILES/gitconfig" "$HOME/.gitconfig"
  [ -e "$HOME/.gitignore_global" ] || [ -L "$HOME/.gitignore_global" ] || ln -s "$DOTFILES/gitignore" "$HOME/.gitignore_global"
  # shell configs
  [ -e "$HOME/.profile" ] || [ -L "$HOME/.profile" ] || ln -s "$DOTFILES/profile" "$HOME/.profile"
  [ -e "$HOME/.bashrc" ] || [ -L "$HOME/.bashrc" ] || ln -s "$DOTFILES/bashrc" "$HOME/.bashrc"
  [ -e "$HOME/.bash_custom_scripts" ] || [ -L "$HOME/.bash_custom_scripts" ] || ln -s "$DOTFILES/bash_custom_scripts" "$HOME/.bash_custom_scripts"
  [ -e "$HOME/.zshrc" ] || [ -L "$HOME/.zshrc" ] || ln -s "$DOTFILES/zshrc" "$HOME/.zshrc"
  # SSH config
  [ -e "$HOME/.ssh" ] || mkdir -m 700 "$HOME/.ssh"
  [ -e "$HOME/.ssh/config" ] || [ -L "$HOME/.ssh/config" ] || ln -s "$DOTFILES/sshconfig" "$HOME/.ssh/config"
  # sensible defaults for Ruby/Rails
  [ -e "$HOME/.railsrc" ] || [ -L "$HOME/.railsrc" ] || ln -s "$DOTFILES/railsrc" "$HOME/.railsrc"
  [ -e "$HOME/.bundle" ] || mkdir "$HOME/.bundle"
  [ -e "$HOME/.bundle/config" ] || [ -L "$HOME/.bundle/config" ] || ln -s "$DOTFILES/bundle.config" "$HOME/.bundle/config"
  # mutt
  [ -e "$HOME/.mutt/cache" ] || mkdir -p "$HOME/.mutt/cache"
  [ -e "$HOME/.mutt/muttrc" ] || [ -L "$HOME/.mutt/muttrc" ] || ln -s "$DOTFILES/muttrc" "$HOME/.mutt/muttrc"
  [ -e "$HOME/.signature" ] || [ -L "$HOME/.signature" ] || ln -s "$DOTFILES/signature" "$HOME/.signature"
  [ -e "$HOME/.mailcap" ] || [ -L "$HOME/.mailcap" ] || ln -s "$DOTFILES/mailcap" "$HOME/.mailcap"
  # VSCode config
  local vscode_home="$HOME/Library/Application Support/Code/User"
  [ -d "$vscode_home" ] || mkdir -p "$vscode_home"
  [ -e "$vscode_home/settings.json" ] || [ -L "$vscode_home/settings.json" ] || ln -s "$DOTFILES/vscode/settings.json" "$vscode_home/settings.json"
  [ -e "$vscode_home/keybindings.json" ] || [ -L "$vscode_home/keybindings.json" ] || ln -s "$DOTFILES/vscode/keybindings.json" "$vscode_home/keybindings.json"
  [ -e "$vscode_home/locale.json" ] || [ -L "$vscode_home/locale.json" ] || ln -s "$DOTFILES/vscode/locale.json" "$vscode_home/locale.json"
  [ -d "$vscode_home/snippets" ] || [ -L "$vscode_home/snippets" ] || ln -s "$DOTFILES/vscode/snippets" "$vscode_home/snippets"
  # ASDF
  [ -e "$HOME/.default-npm-packages" ] || [ -L "$HOME/.default-npm-packages" ] || ln -s "$DOTFILES/default-npm-packages" "$HOME/.default-npm-packages"
  [ -e "$HOME/.default-gems" ] || [ -L "$HOME/.default-gems" ] || ln -s "$DOTFILES/default-gems" "$HOME/.default-gems"
  [ -e "$HOME/.tool-versions" ] || [ -L "$HOME/.tool-versions" ] || ln -s "$DOTFILES/.tool-versions" "$HOME/.tool-versions"
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
  echo "Installing Homebrew packages w/ bundle"
  brew tap --repair homebrew/bundle 
  if command -v ffmpeg >/dev/null 2>&1; then
    # for some reason ffmpeg can cause link issues
    brew unlink ffmpeg >/dev/null
  fi
  brew bundle check --file="$DOTFILES/Brewfile" || brew bundle install --file="$DOTFILES/Brewfile" --no-update 
}

install_or_update_node() {
  # Ensure asdf is loaded
  if [ -z "$(asdf plugin-list | grep 'nodejs')" ]; then
    asdf plugin-add nodejs
    bash "$HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring"
  fi

  echo "Installing the latest version of node"
  local LATEST_NODE_VERSION=$(asdf list-all nodejs | tail -1)
  asdf install nodejs "$LATEST_NODE_VERSION"
  asdf global nodejs "$LATEST_NODE_VERSION"
  hash -r

  echo "Configuring yarn"
  if [ ! -e "$HOME/.yarnrc" ]; then
    yarn config set init-author-name "$NAME"
    yarn config set init-author-email "$EMAIL"
    yarn config set init-license "MIT"
    yarn config set yarn-offline-mirror .yarn-offline-cache
    yarn config set yarn-offline-mirror-pruning true
  fi
}

install_or_update_python() {
  # Ensure asdf is loaded
  if [ -z "$(asdf plugin-list | grep 'python')" ]; then
    asdf plugin-add python
  fi

  echo "Installing the latest version of Python"
  local LATEST_PYTHON2_VERSION=$(asdf list-all python | grep '^2\.' | grep -v '\-dev' | tail -1)
  local LATEST_PYTHON3_VERSION=$(asdf list-all python | grep '^3\.' | grep -v '\-dev' | tail -1)
  asdf install python "$LATEST_PYTHON2_VERSION"
  asdf install python "$LATEST_PYTHON3_VERSION"
  asdf global python "$LATEST_PYTHON3_VERSION" "$LATEST_PYTHON2_VERSION"
  hash -r


  echo "Intalling Python2 dependencies"
  asdf shell python "$LATEST_PYTHON2_VERSION"
  local python2_site_path=$(python2 -m site --user-site)
  [ -d "$python2_site_path" ] && chown -R `whoami` "$python2_site_path" # fix nasty sudo pip...
  if command -v pip2; then
    pip2 install --upgrade pip
  else
    local python2_version=$(python2 -c "import sys;print(str(sys.version_info.major) + '.' + str(sys.version_info.minor))")
    "easy_install-${python2_version}" pip
  fi
  pip2 install -U "${PYTHON_PIPS[@]}" 

  echo "Intalling Python3 dependencies"
  asdf shell python "$LATEST_PYTHON3_VERSION"
  local python3_site_path=$(python3 -m site --user-site)
  [ -d "$python3_site_path" ] && chown -R `whoami` "$python3_site_path" # fix nasty sudo pip...
  if command -v pip3; then
    pip3 install --upgrade pip
  else
    local python3_version=$(python3 -c "import sys;print(str(sys.version_info.major) + '.' + str(sys.version_info.minor))")
    "easy_install-${python3_version}" pip
  fi
  pip3 install -U "${PYTHON_PIPS[@]}" 
}

install_or_update_ruby() {
  # Ensure asdf is loaded
  if [ -z "$(asdf plugin-list | grep 'ruby')" ]; then
    asdf plugin-add ruby
  fi

  echo "Installing the latest version of Ruby"
  local LATEST_RUBY_VERSION=$(asdf list-all ruby | grep '^[0-9]' | grep -v '\-dev' | tail -1)
  asdf install ruby "$LATEST_RUBY_VERSION"
  asdf global ruby "$LATEST_RUBY_VERSION"
  hash -r
  echo "$LATEST_RUBY_VERSION" > "$HOME/.ruby-version"
}

install_or_update_rust() {
  echo "Installing rust"
  if command -v rustup; then
    rustup update stable 
  elif command -v rustup-init; then
    rustup-init -y
  fi
}

install_or_update_dart() {
  # Ensure asdf is loaded
  if [ -z "$(asdf plugin-list | grep 'dart')" ]; then
    asdf plugin-add dart
  fi

  local LATEST_DART_VERSION=$(asdf list-all dart | grep '^[0-9]' | tail -1)
  echo "Installing the latest version of Dart ($LATEST_DART_VERSION)"
  asdf install dart "$LATEST_DART_VERSION"
  asdf global dart "$LATEST_DART_VERSION"
  hash -r
}

install_or_update_go() {
  # Ensure asdf is loaded
  if [ -z "$(asdf plugin-list | grep 'golang')" ]; then
    asdf plugin-add golang
  fi

  local LATEST_GO_VERSION=$(asdf list-all golang | grep '^[0-9]' | tail -1)
  echo "Installing the latest version of Go ($LATEST_GO_VERSION)"
  asdf install golang "$LATEST_GO_VERSION"
  asdf global golang "$LATEST_GO_VERSION"
  hash -r

  echo "installing go packages for dev..."
  asdf current golang "$LATEST_GO_VERSION"
  for pkg in ${GO_PACKAGES[@]}; do
    go get "$pkg"
  done

  echo "code-signing delve... (to allow debugging on Mojave !)"
  (cd "$GOPATH/src/github.com/go-delve/delve" && make install)

  echo 'updating installed google cloud components...'
  asdf shell python system
  gcloud components update --quiet
  gcloud components install app-engine-go --quiet
}

cleanup() {
  echo 'Cleanup Homebrew Cache...'
  brew cleanup -s
  rm -rfv /Library/Caches/Homebrew/*
  brew tap --repair
  echo 'Cleanup gems...'
  gem cleanup &>/dev/null
}

main
