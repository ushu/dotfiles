# First run 
# 
#   $ brew tap Homebrew/bundle
#

# Setup Homebrew Cask first
cask_args appdir: "/Applications"
tap "caskroom/cask"
cask "homebrew/cask-versions/adoptopenjdk8"

# Java is needed
cask "java" unless system "/usr/libexec/java_home --failfast >/dev/null 2>&1"

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
brew "heroku/brew/heroku"
brew "sass/sass/sass"

# DB & Cache servers
brew "postgresql", restart_service: :changed
brew "redis", restart_service: :changed
brew "memcached", restart_service: :changed

# Common libraries
brew "libyaml"
brew "libxml2"

# Version manager
brew "asdf"

# Better tooling
brew "ag"
brew "fzf"

# Node & Javascript
brew "flow"

# Go
brew "go"


# Other dev tools
brew "letsencrypt"

###################################
# Install GUI apps with Brew Cask #
###################################

# Browsers
cask "google-chrome"
cask "firefox"

# Dev Tools
brew "antlr@4" # <- needs java !
cask "visual-studio-code"
#cask "emacs"
cask "miniconda"

# GCP stuff
#cask "googleappengine"
#cask "google-cloud-sdk"

# Android
cask "android-studio"
cask "keystore-explorer"

# On Catalina, install these *AFTER* the updated dev tools
brew "imagemagick"
brew "ffmpeg"
brew "node"
brew "elixir"
brew "rustup"
brew "elm"
brew "carthage"
brew "zlib"

# LaTeX
#cask "basictex"
cask "jabref"

# Could not build it on Catalina
# brew "gpg2"

