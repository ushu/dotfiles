# First run 
# 
#   $ brew tap Homebrew/bundle
#

# Update common Unix tools
brew "bash"
brew "git"
brew "git-lfs"
brew "mutt"

# Development tools
brew "pkg-config"
brew "vim", args: ["with-python", "with-lua", "with-python3"]
brew "phantomjs"
brew "imagemagick"
brew "watchman"
brew "heroku"

# DB & Cache servers
brew "postgresql"
brew "redis"
brew "memcached"

# Common libraries
brew "libyaml"
brew "libxml2", args:[ "with-python" ]

# Better tooling
brew "bash-git-prompt"
brew "ag"
brew "fzf"

# Ruby
brew "rbenv"

# Python
brew "python"
brew "pyenv-virtualenv"
brew "pyenv-virtualenvwrapper"

# Node & Javascript
brew "nvm"
brew "yarn"
brew "flow"

# Lots of languages
brew "elixir"
brew "rustup"
brew "go"
brew "elm"

# Additional dev tools
brew "cmake", args: ["with-completion"]
brew "carthage"

###################################
# Install GUI apps with Brew Cask #
###################################

cask_args appdir: "/Applications"
tap "caskroom/cask"

# Browsers
cask "google-chrome"
cask "firefox"

# Java
cask "java" unless system "/usr/libexec/java_home --failfast >/dev/null 2>&1"

# Dev Tools
brew "antlr" # <- needs java !
cask "visual-studio-code"
# Android
cask "android-studio"
cask "android-sdk"

# Misc
cask "gpg-suite"
cask "dropbox"
cask "launchrocket"
cask "vlc"
cask "omnidisksweeper"

# JetBrains IDEs
cask "jetbrains-toolbox"

