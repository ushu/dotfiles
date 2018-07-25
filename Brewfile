# First run 
# 
#   $ brew tap Homebrew/bundle
#

# Update common Unix tools
brew "git"
brew "git-lfs"
brew "wget"
brew "curl"
brew "ffmpeg"
brew "mutt"
brew "graphviz"

# Documentation
brew "pandoc"
brew "asciidoc"

# Development tools
brew "pkg-config"
brew "vim", args: ["with-python", "with-lua", "with-python3"]
brew "phantomjs"
brew "imagemagick"
brew "flow"
brew "heroku"
brew "carthage"
brew "watchman"

# DB & Cache servers
brew "postgresql"
brew "redis"
brew "memcached"

# Common libraries
brew "libyaml"
brew "libxml2", args:[ "with-python" ]
brew "libxslt"

# Better tooling
brew "bash"
brew "bash-git-prompt"
brew "ag"
brew "fzf"

# Ruby
brew "ruby"
brew "rbenv"

# Python
brew "python"
brew "python3"
brew "pyenv-virtualenv"
brew "pyenv-virtualenvwrapper"

# Node & Javascript
brew "nodejs"
brew "nvm"
brew "yarn"

# Elixir
brew "elixir"

# Rust
brew "rustup"

# Go
brew "go"

# Elm
brew "elm"
brew "elm-format"

# C/C++
brew "cmake", args: ["with-completion"]

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
cask "steam"
cask "launchrocket"
cask "vlc"
#cask "MacTex" # tooooo big...

# JetBrains IDEs
cask "jetbrains-toolbox"

###################################
# Install App Store apps with mas #
###################################

brew "mas"

# Coding stuff
mas "XCode", id: 497799835
mas "Quiver", id: 866773894

# Graphics and design
mas "Affinity Photo", id: 824183456
mas "Affinity Designer", id: 824171161

# Office
mas "Keynote", id: 409183694
mas "Numbers", id: 409203825
mas "Pages", id: 409201541
mas "Deckset", id: 847496013

# Social
mas "Twitter", id: 409789998
mas "Slack", id: 803453959

# Other tools
mas "Harvest", id: 506189836

# Fonts
tap "caskroom/fonts"
cask "font-inconsolata"
cask "font-fira-code"

