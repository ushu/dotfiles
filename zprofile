# Configure Android build tools
if [ -d "/Volumes/Work/android-sdk" ] && [ -w "/Volumes/Work/android-sdk" ]; then
  export ANDROID_HOME="/Volumes/Work/android-sdk"
elif [ -d "/Volumes/Storage/android-sdk" ]; then
  export ANDROID_HOME="/Volumes/Storage/android-sdk"
else
  export ANDROID_HOME="${HOME}/Library/Android/sdk"
fi
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

# Google tools
if [ -d "/Volumes/Work/google-cloud-sdk" ]; then
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
