if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

if [ -f "$HOME/.secrets" ]; then
  . "$HOME/.secrets"
fi

export DOCKER_OPTS="--insecure-registry 192.168.0.26:5000"


# Flutter
export PATH="$HOME/flutter/bin:$PATH"
# Rust
export PATH="$HOME/.cargo/bin:$PATH"
