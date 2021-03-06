###
# Root-level constants
###

# Detect setup from context
# 1) we load the cache, if any
[ -e "$HOME/.zshrc_detected_paths" ] && source "/Users/ushu/.zshrc_detected_paths"
# 2) for each missing path, we detect the actual value
# -> to force reload, delete the cache file !
if [ -z "$BREW_PREFIX" ]; then
  BREW_PREFIX=$(brew --prefix)
  echo "BREW_PREFIX=\"$BREW_PREFIX\"" >> "/Users/ushu/.zshrc_detected_paths"
fi
if [ -z "$PYTHON3_VERSION" ]; then
  PYTHON3_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
  echo "PYTHON3_VERSION=\"$PYTHON3_VERSION\"" >> "/Users/ushu/.zshrc_detected_paths"
fi
if [ -z "$JAVA_HOME" ]; then
  export JAVA_HOME="$(/usr/libexec/java_home)"
  echo "export JAVA_HOME=\"$JAVA_HOME\"" >> "/Users/ushu/.zshrc_detected_paths"
fi

# we use openJDK, which implies some config to work well on Android
export JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions' # <- ignore missing JDK

# Generic options
export EDITOR=vim
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export FZF_DEFAULT_COMMAND='ag -l -g ""'

export TYPEWRITTEN_CURSOR="block"


###
# Plugins
###

ANTIGEN_PATH="$BREW_PREFIX/opt/antigen"
source "$ANTIGEN_PATH/share/antigen/antigen.zsh"

  # Activate Oh My ZSH framework
  antigen use oh-my-zsh

  # Load plugins
  antigen bundle git
  antigen bundle docker
  antigen bundle pip
  antigen bundle zsh-users/zsh-autosuggestions
  antigen bundle zsh-users/zsh-syntax-highlighting

  # Set active theme
  antigen theme reobin/typewritten

antigen apply


###
# Aliase(s)
###

# Ruby
alias be="bundle exec"
# Git
alias l="git lg"
alias cl="git changelog master..HEAD"
alias d="git diff --color"
alias s="git status"
alias ac="git add --all && git ci"
alias ci="git ci"
alias ginit="git init && git commit --allow-empty -m'Initial commit'"
alias be="bundle exec"
# Faster start for (spac|e)emacs
alias e="emacsclient  -a '' --no-wait -c"
# n|nv => neovim
alias nv="nvim"
alias n="nvim"

# Google tools
if [ -d "/Volumes/Work/google-cloud-sdk" ]; then
  source "/Volumes/Work/google-cloud-sdk/completion.zsh.inc"
fi

# ASDF
if [ -d "$HOME/.asdf" ]; then
  source "$HOME/.asdf/completions/asdf.bash"
fi

# anaconda
conda() {
  if [ -d "$WIP_DIR/miniconda/bin" ]; then
    export PATH="$WIP_DIR/miniconda/bin:$PATH"
  fi
  __conda_setup="$($WIP_DIR/miniconda/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
  [ $? -eq 0 ] && eval "$__conda_setup"
  conda $@
}

# Haskell
if [ -d /Volumes/Work ]; then
  export GHCUP_INSTALL_BASE_PREFIX="/Volumes/Work"
fi
if [ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ]; then
  source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"
fi

# Rust
if [ -e "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

# custom comandes
[ -e "$HOME/.custom_shell_scripts" ] && source "$HOME/.custom_shell_scripts"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Other ZSH-specific options
#setopt menu_complete

# Custom binaries (?)
if [ -d "$HOME/.bin" ]; then
  export PATH="$HOME/.bin:$PATH"
fi
