# Personal aliases — add yours here so they travel to every machine this
# repo is installed on.
#
# Examples:
# alias zshconfig="$EDITOR $DOTFILES_DIR/zshrc"

# Modern CLI replacements (brew/Brewfile: eza, bat — fd and ripgrep are
# deliberately NOT aliased over find/grep here, since their flags aren't
# compatible and shadowing them breaks muscle-memory/copy-pasted commands;
# use `fd`/`rg` directly instead).
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --group-directories-first"
  alias ll="eza -lh --group-directories-first --git"
  alias la="eza -lah --group-directories-first --git"
  alias lt="eza --tree --level=2 --group-directories-first"
fi

command -v bat >/dev/null 2>&1 && alias cat="bat --paging=never"
