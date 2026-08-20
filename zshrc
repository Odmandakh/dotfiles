# ~/.zshrc — managed by the zsh-config repo (github.com/Odmandakh/zsh-config).
#
# This file is symlinked into place by ./install.sh. Edit files inside the
# repo (not this symlink directly is fine too — it's the same file) and,
# on any other machine, just re-run ./install.sh to pick up plugin changes.

# Resolve the real directory of this file even though it's symlinked as
# ~/.zshrc — lets the repo live anywhere (cloned to any path, any machine).
DOTFILES_DIR="${${(%):-%x}:A:h}"

# --- oh-my-zsh ---------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

# Theme + plugin list + fpath additions must be set *before* oh-my-zsh.sh
# is sourced, since that's what oh-my-zsh reads them at load time.
source "$DOTFILES_DIR/lib/00-theme.zsh"
source "$DOTFILES_DIR/lib/01-plugins.zsh"
source "$DOTFILES_DIR/lib/02-fpath.zsh"

source "$ZSH/oh-my-zsh.sh"

# --- everything else, in order -----------------------------------------
for _dotfile in "$DOTFILES_DIR"/lib/1*-*.zsh(N) "$DOTFILES_DIR"/lib/2*-*.zsh(N); do
  source "$_dotfile"
done
unset _dotfile

# Machine-local overrides — never committed, only exists if a machine
# needs a one-off tweak that shouldn't apply everywhere else.
[ -f "$DOTFILES_DIR/lib/local.zsh" ] && source "$DOTFILES_DIR/lib/local.zsh"

VAULT_ADDR=https://vault.in:8200
VAULT_DISABLE_SSL_VALIDATION=true
VAULT_TOKEN=
