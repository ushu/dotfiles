#!/usr/bin/env bash

# Create new folder in ~/.vim/pack that contains a start folder and cd into it.
#
# Arguments:
#   package_group, a string folder name to create and change into.
#
# Examples:
#   set_group syntax-highlighting
#
function set_group () {
  package_group=$1
  path="$HOME/.vim/pack/$package_group/start"
  mkdir -p "$path" > /dev/null
  cd "$path" || exit
}

# Clone or update a git repo in the current directory.
#
# Arguments:
#   repo_url, a URL to the git repo.
#
# Examples:
#   package https://github.com/tpope/vim-endwise.git
#
function package () {
  repo_url=$1
  if [[ "$repo_url" != http* ]]; then
    repo_url="https://github.com/${repo_url}"
  fi
  expected_repo=$(basename "$repo_url" .git)
  if [ -d "$expected_repo" ]; then
    cd "$expected_repo" || exit
    result=$(git pull --force -q && printf "OK" || printf "KO")
    echo "$expected_repo: $result"
  else
    result=$(git clone --single-branch -q $repo_url && printf "OK (new)" || printf "KO")
    echo "$expected_repo: $result"
  fi
}

#####################
# PACKAGES GO BELOW #
#####################

(
set_group themes
package junegunn/seoul256.vim &
wait
) &

(
set_group tools
package junegunn/fzf &
package tpope/vim-fugitive &
package editorconfig/editorconfig-vim &
package rking/ag.vim &
package maralla/completor.vim &
package maralla/validator.vim &
wait
) &

(
set_group webdev
package kchmck/vim-coffee-script &
package ap/vim-css-color &
package pangloss/vim-javascript &
package mxw/vim-jsx &
wait
) &

(
set_group go
package fatih/vim-go &
wait
) &

(
set_group rust
package rust-lang/rust &
wait
) &

(
set_group elixir
package elixir-lang/vim-elixir &
package mattreduce/vim-mix &
wait
) &

(
set_group syntaxes
package toyamarinyon/vim-swift &
package tpope/vim-markdown &
wait
) &


wait

