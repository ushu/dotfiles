# First run 
# 
#   $ brew tap Homebrew/bundle
#

# Update common Unix tools
brew "bash"
brew "git"
brew "git-lfs"
brew "mutt"
brew "curl"
brew "wget"

# Python
brew "python3", args: [ "build-from-source" ]
brew "python@2", args: [ "build-from-source" ]

# Development tools
brew "pkg-config"
brew "vim", args: ["with-python", "with-lua", "with-python3"]
brew "imagemagick"
brew "ffmpeg"
brew "watchman"
brew "heroku/brew/heroku"

# DB & Cache servers
brew "postgresql", restart_service: :changed
brew "redis", restart_service: :changed
brew "memcached", restart_service: :changed

# Common libraries
brew "libyaml"
brew "libxml2", args: [ "with-python" ]

# Better tooling
brew "bash-git-prompt"
brew "ag"
brew "fzf"

# Ruby
brew "rbenv"

# Node & Javascript
brew "nvm"
brew "yarn"
brew "flow"

# Go
brew "go"
brew "dep"

# Lots of languages
brew "elixir"
brew "rustup"
brew "elm"

# Additional dev tools
brew "cmake", args: ["with-completion"]
brew "carthage"
brew "letsencrypt"

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

# Java
cask "googleappengine"

# Dev Tools
brew "antlr" # <- needs java !
cask "visual-studio-code"
cask "google-cloud-sdk"
cask "phantomjs"
# Android
cask "android-studio"
cask "android-sdk"

# Misc
cask "gpg-suite"
cask "dropbox"
cask "launchrocket"
#cask "vlc"
cask "omnidisksweeper"

# JetBrains IDEs
cask "jetbrains-toolbox"

