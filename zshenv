# ~/.zshenv — sourced by *every* zsh invocation (interactive, login, or
# not), symlinked by ./install.sh. Keep this to just the PATH/env that
# non-interactive non-login shells need — e.g. `ssh box 'go version'`,
# VS Code Remote-SSH's headless server shell, cron. Everything else
# (theme, plugins, aliases, oh-my-zsh itself) lives in zshrc/zprofile
# instead, since those only make sense for an interactive shell.

# Resolve the real directory of this file even though it's symlinked as
# ~/.zshenv — lets the repo live anywhere (cloned to any path, any machine).
DOTFILES_DIR="${${(%):-%x}:A:h}"

source "$DOTFILES_DIR/lib/10-path.zsh"
