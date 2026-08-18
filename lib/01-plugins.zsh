# oh-my-zsh plugin list. install.sh clones the plugins below into
# $ZSH_CUSTOM/plugins on any machine that doesn't have them yet.
#
# Order matters:
# - zsh-vi-mode must load first, so the key bindings other plugins define
#   layer on top of it instead of getting overwritten by it.
# - zsh-syntax-highlighting must load before zsh-history-substring-search
#   (required by the latter's own docs) and after everything else that
#   defines widgets, so it's second-to-last.
# - zsh-history-substring-search stays last for the same reason.
plugins=(
  zsh-vi-mode
  git
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
  zsh-history-substring-search
)
