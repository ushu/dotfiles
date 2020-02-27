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

# "locals"
DOTFILES="$HOME/.dotfiles"
REPO="https://github.com/ushu/dotfiles"

# List of components to install
PYTHON_PIPS=(httpie)
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

  # We often need the official fonts (even the legacy ones !) for the
  # design tools !
  echo "Installing Apple Fonts..."
  install_apple_fonts

  install_or_update_homebrew

  # ASDF
  if [ ! -d "$HOME/.asdf" ]; then
    git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" 
    pushd "$HOME/.asdf"
      git checkout "$(git describe --abbrev=0 --tags)"
    popd
  else
    pushd "$HOME/.asdf"
      git fetch origin 
      git checkout "$(git describe --abbrev=0 --tags)"
    popd
  fi
  ZSH_VERSION=""
  source "$HOME/.asdf/asdf.sh"
  source "$HOME/.asdf/completions/asdf.bash"

  # VIM deps
  if [ ! -e "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  install_or_update_node
  install_or_update_python
  install_or_update_ruby
  install_or_update_go
  install_or_update_rust
  install_or_update_dart
  install_or_update_elixir
  install_or_update_haskell
  
  install_google_cloud

  cleanup

  generate_bashrc_cache

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
  # Shell Configs
  #> BASH
  [ -e "$HOME/.profile" ] || [ -L "$HOME/.profile" ] || ln -s "$DOTFILES/profile" "$HOME/.profile"
  [ -e "$HOME/.bashrc" ] || [ -L "$HOME/.bashrc" ] || ln -s "$DOTFILES/bashrc" "$HOME/.bashrc"
  #> ZSH
  [ -e "$HOME/.zshrc" ] || [ -L "$HOME/.zshrc" ] || ln -s "$DOTFILES/zshrc" "$HOME/.zshrc"
  [ -e "$HOME/.zprofile" ] || [ -L "$HOME/.zprofile" ] || ln -s "$DOTFILES/zprofile" "$HOME/.zprofile"
  #> shell scripts/commands
  [ -e "$HOME/.hushlogin" ] || touch "$HOME/.hushlogin"
  [ -e "$HOME/.custom_shell_scripts" ] || [ -L "$HOME/.custom_shell_scripts" ] || ln -s "$DOTFILES/custom_shell_scripts" "$HOME/.custom_shell_scripts" 
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
  # MacOS env variables (!)
  [ -e "$HOME/Library/LaunchAgents/ushu.startup.plist" ] || [ -L "$HOME/Library/LaunchAgents/ushu.startup.plist" ] || ln -s "$DOTFILES/ushu.startup.plist" "$HOME/Library/LaunchAgents/ushu.startup.plist"
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
  (brew bundle check --file="$DOTFILES/Brewfile" || brew bundle install --file="$DOTFILES/Brewfile" --no-update); true 
}

install_or_update_node() {
  # Ensure asdf is loaded
  if [ -z "$(asdf plugin-list | grep 'nodejs')" ]; then
    asdf plugin-add nodejs
  fi
  bash "$HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring"

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
    yarn config set prefix ~/.yarn
  fi
}

install_or_update_python() {
  # Needed by python-build on Mojave
  export SDKROOT="$(xcrun --show-sdk-path)"

  echo "Installing the latest version of Python"
  local LATEST_PYTHON2_VERSION=$(asdf list-all python | grep '^2\.' | grep -v '\-dev' | tail -1)
  local LATEST_PYTHON3_VERSION=$(asdf list-all python | grep '^3\.' | grep -v '\-dev' | grep -v 'b\d\+' | tail -1)
  hash -r

  echo "Install MiniConda"
  MINICONDA_PATH="$HOME/.miniconda"
  if [ -d "/Volumes/Work" ]; then
    MINICONDA_PATH="/Volumes/Work/miniconda"
  fi

  if [ ! -d "$MINICONDA_PATH" ]; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
    chmod +x ./Miniconda3-latest-MacOSX-x86_64.sh
    ./Miniconda3-latest-MacOSX-x86_64.sh -b -p "$MINICONDA_PATH"
    rm ./Miniconda3-latest-MacOSX-x86_64.sh
  fi

  # now we activate miniconda
  export PATH="$MINICONDA_PATH/bin:$PATH"

  # and install pip in base conda env
  conda install pip -y

  echo "Install PIPs"
  for pkg in ${PYTHON_PIPS[@]}; do
    pip install "$pkg"
  done
}

install_or_update_ruby() {
  # Ensure asdf is loaded
  if [ -z "$(asdf plugin-list | grep 'ruby')" ]; then
    asdf plugin-add ruby
  fi

  echo "Installing the latest version of Ruby"
  local LATEST_RUBY_VERSION=$(asdf list-all ruby | grep '^[0-9]' | grep -v '\-dev' | grep -v '\-preview' | tail -1)
  asdf install ruby "$LATEST_RUBY_VERSION"
  asdf global ruby "$LATEST_RUBY_VERSION"
  hash -r

  asdf shell ruby "$LATEST_RUBY_VERSION"
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
  # ensure asdf is loaded
  if [ -z "$(asdf plugin-list | grep 'dart')" ]; then
    asdf plugin-add dart
  fi

  local latest_dart_version=$(asdf list-all dart | grep '^[0-9]' | tail -1)
  echo "installing the latest version of dart ($latest_dart_version)"
  asdf install dart "$latest_dart_version"
  asdf global dart "$latest_dart_version"
  hash -r

  asdf shell dart "$latest_dart_version"
}

install_or_update_elixir() {
  # ensure asdf is loaded
  if [ -z "$(asdf plugin-list | grep 'elixir')" ]; then
    asdf plugin-add elixir
  fi

  local latest_elixir_version=$(asdf list-all elixir | grep '^[0-9]' | grep -v '\-rc' | tail -1)
  echo "installing the latest version of elixir ($latest_elixir_version)"
  asdf install elixir "$latest_elixir_version"
  asdf global elixir "$latest_elixir_version"
  hash -r

  asdf shell elixir "$latest_elixir_version"
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
  asdf shell golang "$LATEST_GO_VERSION"

  if [ -d "/Volumes/Work" ] && [ -w "/Volumes/Work" ]; then
    [ -e "/Volumes/Work/go" ] || mkdir -p "/Volumes/Work/go"
    export GOPATH="/Volumes/Work/go"
  else
    export GOPATH="$HOME"
  fi
  
  # Latest procogen is needed for Firebase
  go get -u github.com/golang/protobuf/protoc-gen-go
  # then all the deps
  for pkg in ${GO_PACKAGES[@]}; do
    go get "$pkg"
  done

  echo "code-signing delve... (to allow debugging on Mojave !)"
  (cd "$GOPATH/src/github.com/go-delve/delve" && make install)
}

install_google_cloud() {
  local install_dir="$HOME"
  if [ -d /Volumes/Work ]; then
    install_dir="/Volumes/Work"
  fi
  if [ ! -d "$install_dir/google-cloud-sdk" ]; then
    echo "Updating google cloud SDK"
    curl https://sdk.cloud.google.com > ./Google-Cloud-Installer.sh
    chmod +x ./Google-Cloud-Installer.sh
    ./Google-Cloud-Installer.sh --disable-prompts --install-dir="$install_dir"
    rm ./Google-Cloud-Installer.sh
  fi
  export PATH="$install_dir/google-cloud-sdk/bin:$PATH"

  echo "updating google cloud SDK"
  gcloud components update --quiet

  echo 'adding appengine specifics'
  gcloud components install app-engine-go --quiet
}

install_apple_fonts() {
  [ -d "$HOME/Library/Fonts" ] || mkdir -p "$HOME/Library/Fonts"
  find "$DOTFILES/Apple Fonts" -name '*.[ot]tf' | while read f;  do
    [ -e "$HOME/Library/Fonts/$f" ] || cp "$f" "$HOME/Library/Fonts/"
  done
  if [ ! -d "/Applications/SF Symbols.app" ]; then
    echo "Installing Apple Symbols..."
    (sudo installer -pkg "$DOTFILES/Apple Fonts/SF Symbols.pkg" -target /; true)
  fi
  if [ ! -e "/Library/Fonts/SF-Compact-Text-Black.otf" ]; then
    echo "Installing SF Compact..."
    (sudo installer -pkg "$DOTFILES/Apple Fonts/San Francisco Compact.pkg" -target /; true)
  fi
  if [ ! -e "/Library/Fonts/SF-Mono-Bold.otf" ]; then
    echo "Installing SF Mono..."
    (sudo installer -pkg "$DOTFILES/Apple Fonts/SF Mono Fonts.pkg" -target /; true)
  fi
  if [ ! -e "/Library/Fonts/NewYorkLarge-Black.otf" ]; then
    echo "Installing New York..."
    (sudo installer -pkg "$DOTFILES/Apple Fonts/NY Fonts.pkg" -target /; true)
  fi
}

install_or_update_haskell() {
  if [ -d /Volumes/Work ]; then
    export GHCUP_INSTALL_BASE_PREFIX="/Volumes/Work"
  fi
  if ! command -v cabal; then
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
  fi
}

cleanup() {
  echo 'Cleanup Homebrew Cache...'
  brew cleanup -s
  rm -rfv /Library/Caches/Homebrew/*
  brew tap --repair
  echo 'Cleanup gems...'
  gem cleanup 
  echo 'Re-generating asdf shims...'
  asdf reshim
}

generate_bashrc_cache() {
  local cache="$HOME/.bashrc_cache"

  # Create file
  touch "$HOME/.bashrc_cache"

  # Add global brew prefix
  BREW_PREFIX=$(brew --prefix)
  echo "# Generic prefix for Homebrew installs" >> "$cache"
  echo "BREW_PREFIX=\"$BREW_PREFIX\"" >> "$cache"
  echo >> "$cache"


  # Detect JAVA Home
  JAVA_HOME=$(/usr/libexec/java_home)
  echo "# Home path of the JAVA SDK" >> "$cache"
  echo "JAVA_HOME=\"$JAVA_HOME\"" >> "$cache"
  echo >> "$cache"

  # Current version (MAJOR.MINOR) of Python
  PYTHON3_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
  echo "# Installed Python3 version" >> ~/.bashrc_cache
  echo "PYTHON3_VERSION=\"$PYTHON3_VERSION\"" >> ~/.bashrc_cache
  echo >> ~/.bashrc_cache
}

main
