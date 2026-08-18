# ~/.zprofile — login-shell setup, symlinked by ./install.sh.
# Runs once per login shell, before .zshrc. Keep this to PATH/env setup
# that only needs to happen once (shell integrations, package managers).

# --- Homebrew ------------------------------------------------------------
# Apple Silicon default prefix, falling back to Intel's.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# --- MacPorts (legacy, only applies if installed) -------------------------
if [ -d /opt/local/bin ]; then
  export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
  export MANPATH="/opt/local/share/man:$MANPATH"
fi

# --- JetBrains Toolbox scripts --------------------------------------------
if [ -d "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]; then
  export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
fi
