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

check_command() {
  if ! command_available $1; then
    MISSING_PACKAGES=( ${MISSING_PACKAGES[@]} $2 )
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

main () {
  # linux ??
  if is_debian; then
    check_commands curl git zsh 
    check_command vim vim-nox
  fi
  
  if [ ${#MISSING_PACKAGES[@]} -ne 0 ]; then
    if is_debian; then
      sudo apt-get install ${MISSING_PACKAGES[@]}
    elif is_osx; then
      sudo brew install ${MISSING_PACKAGES[@]}
    fi
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
    if [ -f "$DOTFILES" ]; then
      cd "$DOTFILES" && git update origin master
    else
      git clone https://github.com/ushu/dotfiles $DOTFILES
    fi

    [ -f "$HOME/.vimrc" ] || ln -s "$DOTFILES/.vimrc" "$HOME/.vimrc"
    [ -f "$HOME/,vim" ] || ln -s "$DOTFILES/.vim" "$HOME/.vim"
    [ -f "$HOME/.gitconfig" ] || ln -s "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
  fi
  
  
}

main

