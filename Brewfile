# First run 
# 
#   $ brew tap Homebrew/bundle
#

# Setup Homebrew Cask first
cask_args appdir: "/Applications"
#tap "homebrew/cask-cask"
tap "heroku/brew"
tap "sass/sass"

# Install Java: avoid issues w/ openjdk by using Oracle...
#tap "AdoptOpenJDK/openjdk"
#cask "adoptopenjdk13"
cask "oracle-jdk"
brew "gradle" # <- hate it but better having it installed

# Cmake is also needed by some brews
brew "cmake"

# Update common Unix tools
brew "bash"
brew "zsh"
brew "antigen" # package manager for zsh
brew "git"
brew "git-lfs"
#brew "mutt"
brew "curl"
brew "wget"
brew "tree"
#brew "mercurial"

# Brew version(s) of scripting languages
brew "python3"
brew "python@2"
brew "cython"
brew "ruby"
brew "perl"

# Development tools
brew "pkg-config"
brew "vim"
brew "watchman"
brew "heroku"
brew "sass"

# DB & Cache servers
brew "postgresql", restart_service: :changed
brew "redis", restart_service: :changed
brew "memcached", restart_service: :changed

# Common libraries
brew "libyaml"
brew "libxml2"

# Better tooling
brew "ag"
brew "fzf"

# Node & Javascript
brew "flow"

# Go
brew "go"


# Other dev tools
brew "letsencrypt"
brew "md5sha1sum"

###################################
# Install GUI apps with Brew Cask #
###################################

# Browsers
cask "google-chrome"
cask "firefox"

# Dev Tools
brew "antlr@4" # <- needs java !
cask "visual-studio-code"
cask "github"
brew "hub"

# Android
cask "keystore-explorer"

# On Catalina, install these *AFTER* the updated dev tools
brew "imagemagick"
brew "ffmpeg"
brew "node"
brew "elixir"
brew "elm"
brew "carthage"
brew "zlib"

# Could not build it on Catalina
brew "gnupg"
brew "pinentry" # <- to allow "unlocking" the key...
cask "gpg-suite-no-mail"

# Dev font
tap "homebrew/cask-fonts"
brew "homebrew/cask-fonts/font-fira-code"

# Docker stuff
cask "docker" # Docker Desktop
brew "kubectl"
brew "minikube"

