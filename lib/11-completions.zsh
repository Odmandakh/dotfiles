# Shell integrations / completions for dev tools. Guarded so a machine
# missing one of these tools just skips that block.

# --- zoxide (smarter cd, `z`/`zi`) --------------------------------------
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# --- fzf (fuzzy finder: Ctrl+T files, Alt+C cd) -------------------------
# Ctrl+R is intentionally handed off to atuin below — it's sourced after
# this, so its Ctrl+R binding wins over fzf's.
command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"

# --- atuin (SQLite-backed searchable shell history) ---------------------
# Owns Ctrl+R (overrides fzf's binding above, by load order). Up-arrow is
# left alone so it stays bound to zsh-history-substring-search (see
# lib/14-bindings.zsh) instead of atuin's own inline search.
# Config/data live outside this repo (~/.config/atuin, ~/.local/share/atuin)
# and aren't tracked here, same as any other machine-local state.
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh --disable-up-arrow)"

# --- nvm -------------------------------------------------------------
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- Google Cloud SDK --------------------------------------------------
# Checked in a few common install locations since the SDK doesn't have a
# fixed path across machines (Downloads, home dir, Homebrew Caskroom).
# nullglob so an unmatched Caskroom pattern just disappears instead of
# erroring out shell startup. This file is sourced at the top level (not
# inside a function), so restore the option afterwards rather than relying
# on `localoptions`, which only reverts on function return.
[[ -o nullglob ]]; _had_nullglob=$?
setopt nullglob
for _gcloud_dir in \
  "$HOME/Downloads/google-cloud-sdk" \
  "$HOME/google-cloud-sdk" \
  /opt/homebrew/Caskroom/google-cloud-sdk/*/google-cloud-sdk \
  /usr/local/Caskroom/google-cloud-sdk/*/google-cloud-sdk
do
  [ -f "$_gcloud_dir/path.zsh.inc" ] && source "$_gcloud_dir/path.zsh.inc"
  [ -f "$_gcloud_dir/completion.zsh.inc" ] && source "$_gcloud_dir/completion.zsh.inc"
done
(( _had_nullglob == 0 )) || unsetopt nullglob
unset _gcloud_dir _had_nullglob
