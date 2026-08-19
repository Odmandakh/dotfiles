# History size/behavior.

# XDG_STATE_HOME defaults per the XDG Base Directory spec when unset, and
# the directory has to exist before zsh will write HISTFILE inside it.
# mode 700: shell history can contain sensitive command-line arguments, so
# don't leave the directory listing world-readable regardless of umask.
: "${XDG_STATE_HOME:=$HOME/.local/state}"
mkdir -m 700 -p "$XDG_STATE_HOME/zsh"
chmod 700 "$XDG_STATE_HOME/zsh"

HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

# One-time migration from oh-my-zsh's default ~/.zsh_history, so history
# from before this file moved HISTFILE isn't orphaned. No-ops once
# HISTFILE exists.
[ -f "$HOME/.zsh_history" ] && [ ! -f "$HISTFILE" ] && cp "$HOME/.zsh_history" "$HISTFILE"

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
