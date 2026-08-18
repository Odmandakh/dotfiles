# Prompt theme. Default matches what's currently running: agnoster.
#
# To try another theme on one machine without changing the repo, export
# ZSH_CONFIG_THEME before ~/.zshrc loads (e.g. in lib/local.zsh):
#   echo 'ZSH_CONFIG_THEME=robbyrussell' >> lib/local.zsh
ZSH_THEME="${ZSH_CONFIG_THEME:-agnoster}"

# Agnoster needs a Powerline-patched font to render its glyphs correctly.
# install.sh does not install fonts (that's a GUI step) — if prompt icons
# show as boxes/question marks, install a Nerd Font / Powerline font and
# set it as your terminal's font.

# "solarized" (from the project brief) is a terminal color scheme, not an
# oh-my-zsh prompt theme — it pairs with agnoster rather than replacing it.
# See terminal/solarized-dark.itermcolors and terminal/solarized-light.itermcolors
# (vendored in this repo); import one into iTerm2 under
# Preferences > Profiles > Colors > Color Presets > Import...
