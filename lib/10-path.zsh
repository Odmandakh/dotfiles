# PATH additions for tools/SDKs. Every entry is guarded by an existence
# check, so this file is safe to source unchanged on a machine that
# doesn't have a given tool installed — it just skips that line.

# Go
[ -d /usr/local/go/bin ] && export PATH="/usr/local/go/bin:$PATH"

# PHP 7.4 (Homebrew)
if [ -d /opt/homebrew/opt/php@7.4/bin ]; then
  export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
  export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"
fi

# OpenJDK 21 (Homebrew) — takes precedence over other JAVA_HOME entries below
if [ -d /opt/homebrew/opt/openjdk@21/bin ]; then
  export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
  export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
fi

# IBM Semeru JDK 18 (only if installed and OpenJDK 21 above wasn't found)
SEMERU_HOME="$HOME/Library/Java/JavaVirtualMachines/semeru-18.0.2/Contents/Home"
if [ -z "$JAVA_HOME" ] && [ -d "$SEMERU_HOME" ]; then
  export JAVA_HOME="$SEMERU_HOME"
  export PATH="$JAVA_HOME/bin:$PATH"
fi
unset SEMERU_HOME

# User-local binaries
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
