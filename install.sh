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

    # add repo for gcc
    echo "add additional sources"
    brew tap homebrew/dupes
    brew tap homebrew/versions
    brew tap josegonzalez/php

    # patch /etc/paths to help homebrew
    echo "patch /etc/paths (old version in $DOTFILES/.paths.backup)"
    cp /etc/paths .paths.backup
    sed '/[/]usr[/]local[/]s*bin/d' /etc/paths | sed '1 i\
/usr/local/bin
' > "$DOTFILES/paths"
    sudo mv "$DOTFILES/paths" /etc/paths
  fi
}

main () {
  # linux ??
  if is_osx; then
    install_homebrew

  fi

  if is_debian; then
    check_commands curl git bash zsh autoconf libtool bison pkg-config
    check_command vim vim-nox
    check_apt_dependencies libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libgdbm-dev libncurses5-dev libffi-dev
  elif is_osx; then
    # common dependencies
    check_commands curl git zsh vim
    # for ruby/rails
    check_commands autoconf automake libtool
    check_brew_dependencies libyaml libxml2 libxslt libksba sqlite apple-gcc42 gcc49 ag qt grok
    # let's brew php (with debug options
    #brew install php56 --with-fpm --with-imap --without-apache --with-debug
    brew install php56 --with-fpm
  fi

  if [ ${#MISSING_PACKAGES[@]} -ne 0 ]; then
    if is_debian; then
      sudo apt-get install ${MISSING_PACKAGES[@]}
    elif is_osx; then
      brew install ${MISSING_PACKAGES[@]}
    fi
    # add gjslint
    easy_install http://closure-linter.googlecode.com/files/closure_linter-latest.tar.gz
  fi

  if check_command nvm; then
    if [ -f "$HOME/.nvm/nvm.sh" ]; then
      source "$HOME/.nvm/nvm.sh"
    fi
  fi
  if check_command_and_dependencies nvm curl git; then
    curl https://raw.github.com/creationix/nvm/master/install.sh | sh
  fi

  LATEST_NODE=$(nvm ls-remote | tail -n1 | xargs)
  if ! nvm ls | grep "$LATEST_NODE" >/dev/null; then
    nvm install "$LATEST_NODE"
  fi

  nvm use "$LATEST_NODE"
  nvm alias default "$LATEST_NODE"

  # node-based tools
  for c in "grunt-cli" "less" bower yo "generator-webapp"; do
    if check_command_and_dependencies "$c" npm; then
      npm install -g "$c"
    fi
  done

  if check_command git; then
    if [ -d "$DOTFILES" ]; then
      cd "$DOTFILES" && git pull origin master
    else
      # clone and init all submodules
      git clone http://github.com/ushu/dotfiles.git $DOTFILES
      cd $DOTFILES
      git submudule init
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

  if check_command_and_dependencies rvm curl bash git; then
    curl -L https://get.rvm.io | bash -s stable --rails --autolibs=enabled
  elif check_commands rvm; then
    rvm get stable
  fi

  if [ -d "$HOME/.rvm" ]; then
    # load RVM into current shell sessions
    export PATH="$PATH:$HOME/.rvm/bin"
    source "$HOME/.rvm/scripts/rvm"
  fi

  LATEST_RUBY=$(rvm list --remote | grep ruby- | tail -n1 | xargs)
  if ! rvm list | grep -q "$LATEST_RUBY"; then
    rvm install $LATEST_RUBY --binary
  fi

<<<<<<< HEAD
  # setup Ruby 2 as default
  rvm --default use 2.0

  # move to global gemset
  if ! rvm gemset list | grep global; then
    rvm gemset create global
  fi
  rvm gemset use global

  # basic gems
  gem install bundler rak pry
  # useful libs
  gem install nokogiri thor rmagick
  gem install aws fog unf
  # web dev
  gem install sass compass rails sinatra jekyll
  # Rails <3
  gem install rails bcrypt-ruby
  gem install autoprefixr-rails email_validator date_validator omniauth-google-oauth2 omniauth-facebook omniauth-twitter carrierwave mime-types # plugins
  gem install omniauth-google-oauth2 omniauth-facebook omniauth-twitter devise  # auth
  gem install figaro zeus jazz_hands coffee-rails-source-maps sass-rails-source-maps better_errors annotate bullet # dev tools
  # deployment gems
  gem install chef sprinkle capistrano mina
  # test tools
  gem install rspec cucumber capybara poltergeist
  gem install rspec-rails cucumber-rails
=======
  # setup Ruby 2 with usefull gems !
  rvm --default use "$LATEST_RUBY"
  rvm gemset use global # using global gemset == bin are always available
  gem install bundler rak sass compass rails nokogiri capistrano sinatra chef sprinkle
>>>>>>> 01b0dc63762df8504a5c56aa440b8bb59b151041

  if is_osx; then
    # register custom theme
    open "$DOTFILES/Flat-bigFont.terminal"

    if check_commands brew; then
      if ! check_brew_dependency vim; then
        # install vim/macvim with lua/python/ruby enabled
        brew install vim --with-lua
        brew install macvim --with-lua
      fi
    fi
  fi
}

main

