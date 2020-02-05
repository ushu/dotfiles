# Special setup for the "Work" directory
if [ -d "/Volumes/Work" ]; then
  [ -d "/Volumes/Work/WIP" ] || mkdir -p "/Volumes/Work/WIP"
  export WIP_DIR="/Volumes/Work"
  # also make a symlink unless exists
  [ -d "$HOME/WIP" ] || [ -h "$HOME/WIP" ] || ln -s "$WIP_DIR/WIP" "$HOME/WIP"
else
  mkdir -p "$HOME/WIP"
  export WIP_DIR="$HOME/WIP"
fi

# Configure Android build tools
if [ -d "$WIP_DIR/android-sdk" ] && [ -w "$WIP_DIR§/android-sdk" ]; then
  export ANDROID_HOME="$WIP_DIR/android-sdk"
else
  export ANDROID_HOME="${HOME}/Library/Android/sdk"
fi
ANDROID_PATH_EXT="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

# Google tools
if [ -d "$WIP_DIR/google-cloud-sdk" ]; then
  source "/Volumes/Work/google-cloud-sdk/path.zsh.inc"
fi

# ASDF
if [ -d "$HOME/.asdf" ]; then
  source "$HOME/.asdf/asdf.sh"
  export PATH="$(yarn global bin):$PATH"
fi

# rustup config dir
if [ -e "$HOME/.cargo/bin" ];then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Go{PATH|tools}
if [ -d "$WIP_DIR/go" ] && [ -w "$WIP_DIR/go" ]; then
  export GOPATH="$WIP_DIR/go"
  [ -d "$GOPATH" ] || mkdir "$GOPATH"
else
  export GOPATH="$HOME"
fi
GO_PATH_EXT="$PATH:$GOPATH/bin"

# PATH UPDATE
export PATH="$HOME/bin:$APPENGINE_PATH_EXT:$GO_PATH_EXT:$ANDROID_PATH_EXT:$PATH"

# (optional) LaTeX path(s)
if [ -e "/Library/TeX/texbin" ];then
  export PATH="$PATH:/Library/TeX/texbin"
fi

