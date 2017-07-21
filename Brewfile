# First run $ brew tap Homebrew/bundle

# Update common tools
brew "git"
brew "wget"
brew "curl"
brew "gawk"
brew "gnu-sed"
brew "ffmpeg"

# Development tools
brew "pkg-config"
brew "vim", args: [ "with-python", "with-lua", "with-python3" ]
brew "emacs", args: ["with-cocoa", "with-gnutls"]
brew "phantomjs"
brew "imagemagick"
brew "flow"
brew "editorconfig"
brew "heroku"
brew "antlr"
brew "carthage"

# DB & Cache servers
brew "postgresql"
brew "mongodb"
brew "mysql", restart_service: true, conflicts_with: ["homebrew/versions/mysql56"]
brew "redis"
brew "memcached"
brew "sqlite"

# Common libraries
brew "libyaml"
brew "libxml2"
brew "libxslt"
brew "libksba"
brew "openssl"
brew "imagemagick"

# Better tooling
brew "bash-git-prompt"
brew "grok"
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

# Node
brew "nvm"
brew "nodejs"
brew "jsonlint"
brew "yarn"

# Elixir
brew "elixir"

# Rust
brew "rust"

# Go
brew "go"

# C/C++
# installs clang-tidy into "$(brew --prefix llvm)/bin/clang-tidy":
brew "llvm", args: ["with-clang", "with-clang-extra-tools"]

###################################
# Install GUI apps with Brew Cask #
###################################

cask_args appdir: "/Applications"
tap "caskroom/cask"

# Browsers
cask "google-chrome"
cask "firefox"
cask "opera"

# Java
cask "java" unless system "/usr/libexec/java_home --failfast >/dev/null 2>&1"

# Dev Tools
cask "atom"
cask "gitbook-editor"
cask "reveal"

# Misc
#cask "gpgtools" # currently using beta for sierra compatibilty
cask "dropbox"
cask "steam"
cask "launchrocket"
cask "vlc"

# JetBrains IDEs
cask "webstorm"
cask "rubymine"
cask "appcode"
cask "gogland"
cask "pycharm"
cask "clion"
cask "datagrip"

###################################
# Install App Store apps with mas #
###################################

brew "mas"

# Coding apps
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
mas "Skitch", id: 425955336

