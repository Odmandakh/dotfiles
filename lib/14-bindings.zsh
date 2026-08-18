# Custom keybindings layered on top of what the plugins in 01-plugins.zsh
# set up by default. Sourced after oh-my-zsh.sh (and therefore after every
# plugin has registered its own widgets/keymaps), so these are safe to set
# without a plugin clobbering them afterwards.

# zsh-history-substring-search: filter history by what's already typed
# instead of walking the full list, bound to the up/down arrows in insert
# mode and to k/j in zsh-vi-mode's normal mode (bindkey lines straight from
# the plugin's own README).
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
