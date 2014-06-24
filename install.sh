#!/usr/bin/env bash


MISSING_PACKAGES=()
DOTFILES="$HOME/.dotfiles"

is_debian () {
  [ `uname -a | grep -ci "debian\|ubuntu"` -ne 0 ] && return 0
}

is_osx () {
  [ `uname -a | grep -ci "darwin"` -ne 0 ] && return 0
}

command_available () {
  [[ -e `command -v "$1"` ]] && return 0
  # is it a bash function ?
  declare -f "$1" >/dev/null 2>&1
}

register_package_to_install () {
  MISSING_PACKAGES=( ${MISSING_PACKAGES[@]} $1 )
}

check_command() {
  if ! command_available "$1"; then
    register_package_to_install "$2"
  fi
}

check_commands() {
  for c in $@; do
    check_command "$c" "$c"
  done
}

check_command_and_dependencies () {
  if command_available "$1"; then
    echo $1 "is already available on this machine: skipping"
    return 1
  else
    local missing=()
    for c in "${@:2}"; do
      if ! command_available "$c"; then
        missing=( ${missing[@]} "$c" )
      fi
    done
    if [ ${#missing[@]} -ne 0 ]; then
      echo "cannot install" $1 "because of missing dependencies" ${missing[@]}
      return 1
    else
      return 0
    fi
  fi
}

check_apt_dependencies () {
  for c in $@; do
    if ! check_apt_dependency $c; then
      MISSING_PACKAGES=( ${MISSING_PACKAGES[@]} $c )
    fi
  done
}

check_apt_dependency () {
  apt-cache pkgnames | grep -q $1 && return 0
}

check_brew_dependencies () {
  for c in $@; do
    if ! check_brew_dependency $c; then
      MISSING_PACKAGES=( ${MISSING_PACKAGES[@]} $c )
    fi
  done
}

check_brew_dependency () {
  brew list | grep -q $1 && return 0
}

install_homebrew () {
  if ! command_available brew; then
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

    echo "Preparing brew for multi-user"
    sudo chgrp -R admin /usr/local
    sudo chmod -R g+w /usr/local
    sudo chgrp -R admin /Library/Caches/Homebrew
    sudo chmod -R g+w /Library/Caches/Homebrew
    sudo chmod g+x /Library/Caches/Homebrew

    ## add repo for gcc
    #echo "add additional sources"
    #brew tap homebrew/dupes
    #brew tap homebrew/versions
    #brew tap josegonzalez/php

    # patch /etc/paths to help homebrew
    echo "patch /etc/paths (old version in $DOTFILES/.paths.backup)"
    cp /etc/paths .paths.backup
    sed '/[/]usr[/]local[/]s*bin/d' /etc/paths | sed '1 i\
/usr/local/bin
' > "$DOTFILES/paths"
    sudo mv "$DOTFILES/paths" /etc/paths
  fi
}

install_nvm_tools () {
  # load nvm
  . "$HOME/.nvm/nvm.sh"

  # ensure the latest node is installed through nvm
  LATEST_NODE=$(nvm ls-remote | tail -n1 | xargs)
  if ! nvm ls | grep "$LATEST_NODE" >/dev/null; then
    nvm install "$LATEST_NODE"
  fi

  # setup as current+default node
  nvm use "$LATEST_NODE"
  nvm alias default "$LATEST_NODE"

  # Install node packages
  NODE_TOOLS=(grunt-cli less bower yo express)
  for c in ${NODE_TOOLS[@]}; do
    if check_command_and_dependencies "$c" npm; then
      npm install -g "$c"
    fi
  done
}

install_system_packages () {
  # find missing packages
  if is_debian; then

    # install common tools
    check_commands curl git bash zsh autoconf libtool bison pkg-config

    # install vim
    check_commands vim vim-nox

    # install common libs for Rails
    check_apt_dependencies libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libgdbm-dev libncurses5-dev libffi-dev

  elif is_osx; then

    # latest version of common tools
    check_commands wget curl git zsh gawk

    # userful dev tools
    #check_commands autoconf automake libtool
    check_commands grok ag

    # base runtimes
    check_commands ruby python3 nodejs

    # runtime version managers
    check_commands ruby-install chruby pyenv-virtualenv pyenv-virtualenvwrapper nvm

    # libraries for Rails dev
    check_brew_dependencies libyaml libxml2 libxslt libksba sqlite

    ## let's brew php (with debug options)
    ##brew install php56 --with-fpm --with-imap --without-apache --with-debug
    #brew install php56 --with-fpm
  fi

  # install missing packages
  if [ ${#MISSING_PACKAGES[@]} -ne 0 ]; then
    if is_debian; then
      sudo apt-get install ${MISSING_PACKAGES[@]}
    elif is_osx; then
      brew install ${MISSING_PACKAGES[@]}
    fi
    ## add gjslint
    #easy_install http://closure-linter.googlecode.com/files/closure_linter-latest.tar.gz
  fi
}

install_ruby () {
  # load chruby
  source /usr/local/share/chruby/chruby.sh

  LATEST_AVAILABLE_RUBY=$(ruby-install | grep 'stable: ' | head -n1 | sed "s/ *stable: //")
  LATEST_RUBY=$(chruby | tail -n1 | sed "s/ *ruby-//")

  if [ $LATEST_RUBY != $LATEST_AVAILABLE_RUBY ]; then
    echo "installing ruby $LATEST_AVAILABLE_RUBY"

    # install latest ruby
    ruby-install ruby stable

    # reload chruby
    source /usr/local/share/chruby/chruby.sh

    LATEST_RUBY="$LATEST_AVAILABLE_RUBY"
  fi

  # load as current ruby
  chruby $LATEST_RUBY

  # pre-install fat gems
  gem install bundler pry nokogiri
  # web tools
  gem install sass compass rails sinatra jekyll
  # other tools
  gem install vagrant
}

main () {
  # linux ??
  if is_osx; then
    install_homebrew
  fi

  install_system_packages

  install_ruby

  install_nvm_tools

  if check_command git; then
    if [ -d "$DOTFILES" ]; then
      cd "$DOTFILES" && git pull origin master
    else
      # clone and init all submodules
      git clone http://github.com/ushu/dotfiles.git $DOTFILES
      cd $DOTFILES
      git submodule init
      cd ..
    fi

    # Linking files in HOME
    # vim config
    [ -f "$HOME/.vimrc" ] || ln -s "$DOTFILES/.vimrc" "$HOME/.vimrc"
    [ -d "$HOME/.vim" ] || ln -s "$DOTFILES/.vim" "$HOME/.vim"
    # git config
    [ -f "$HOME/.gitconfig" ] || ln -s "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
    # zsh config
    [ -d "$HOME/.oh-my-zsh" ] || git clone git://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"
    [ -f "$HOME/.zshrc" ] || ln -s "$DOTFILES/.zshrc" "$HOME/.zshrc" && chsh -s /bin/zsh
    [ -f "$HOME/.zprofile" ] || ln -s "$DOTFILES/.zprofile" "$HOME/.zprofile"
    # default options for rails new ...
    [ -f "$HOME/.railsrc" ] || ln -s "$DOTFILES/.railsrc" "$HOME/.railsrc"
    # tmux config
    [ -f "$HOME/.tmux.conf" ] || ln -s "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf" && chsh -s /bin/zsh
  fi

  if is_osx; then
    if ! check_brew_dependency vim; then
      # install vim/macvim with lua/python/ruby enabled
      brew install vim --with-lua
      brew install macvim --with-lua
    fi
  fi

  # install ievms ?
  if ! "$HOME/.ievms"; then
    read -r -p "Install IEVMS [y/N] ? " response
    case $response in
      [yY][eE][sS]|[yY])
        curl -s https://raw.githubusercontent.com/xdissent/ievms/master/ievms.sh | env INSTALL_PATH="$HOME/.ievms" bash
        ;;
      *)
        echo "Aborted..."
        ;;
    esac
  fi
}

# Proceed
main
