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
  [[ -e `command -v $1` ]] && return 0
  # is it a bash function ?
  declare -f $1 > /dev/null
}

register_package_to_install () {
  MISSING_PACKAGES=( ${MISSING_PACKAGES[@]} $1 )
}

check_command() {
  if ! command_available $1; then
    register_package_to_install $2
  fi
}

check_commands() {
  for c in $@; do
    check_command $c $c
  done
}

check_command_and_dependencies () {
  if command_available $1; then
    echo $1 "is already available on this machine: skipping"
    return 1
  else
    local missing=()
    for c in ${@:2}; do
      if ! command_available $c; then
        missing=( ${missing[@]} $c )
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
    check_commands autoconf automake libtool apple-gcc42
    check_brew_dependencies libyaml libxml2 libxslt libksba sqlite
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

  if check_command_and_dependencies nvm curl git; then
    curl https://raw.github.com/creationix/nvm/master/install.sh | sh
    source "$HOME/.nvm/nvm.sh"
  fi

  if check_command_and_dependencies node nvm; then
    nvm install 0.10
  else
   if ! nvm ls | grep 0.10; then
     nvm install 0.10
   fi
  fi

  nvm use 0.10

  # node-based tools
  for c in grunt "less"; do
    #echo "installing" $c
    if check_command_and_dependencies $c npm; then
      npm install -g $c
    fi
  done

  if check_command git; then
    if [ -d "$DOTFILES" ]; then
      cd "$DOTFILES" && git pull origin master
    else
      git clone --recursive http://github.com/ushu/dotfiles.git $DOTFILES

      [ -f "$HOME/.vimrc" ] || ln -s "$DOTFILES/.vimrc" "$HOME/.vimrc"
      [ -d "$HOME/.vim" ] || ln -s "$DOTFILES/.vim" "$HOME/.vim"
      [ -f "$HOME/.gitconfig" ] || ln -s "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
    fi

  fi

  if check_command_and_dependencies rvm curl bash git; then
    curl -L https://get.rvm.io | bash -s stable --rails --autolibs=enabled
    source "$HOME/.nvm/nvm.sh"
  elif check_commands rvm; then
    rvm get stable
  fi


  if ! rvm list | grep -q 1.9.3; then
    # grab the last available binary version
    RUBY19=$(rvm list --remote | grep 1.9.3 | tail -n 1 | cut -d\  -f3)
    if [ -z $RUBY19 ]; then
      rvm install $RUBY19 --binary
    else
      rvm install 1.9.3
    fi
  fi
  if ! rvm list | grep -q 2.0; then
    rvm install 2.0
  fi

}

main

