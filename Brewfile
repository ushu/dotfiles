# First run $ brew tap Homebrew/bundle

# Update common tools
brew "git"
brew "wget"
brew "curl"
brew "gawk"
brew "gnu-sed"

# Development tools
brew "pkg-config"
#brew "vim", args: [ "with-python", "with-lua", "with-luajit" ]
brew "vim"
brew "emacs", args: ["with-cocoa", "with-gnutls"]
brew "phantomjs"
brew "imagemagick"
brew "flow"
brew "editorconfig"
brew "heroku"

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

# Cask
cask_args appdir: "/Applications"
tap "caskroom/cask"
cask "launchrocket"

# Browsers
cask "google-chrome"
cask "firefox"
cask "opera"

# Java
cask "java" unless system "/usr/libexec/java_home --failfast >/dev/null"

# Dev Tools
cask "atom"
cask "gitbook-editor"

# Misc Tools
cask "gpgtools"
cask "dropbox"
cask "slack"

