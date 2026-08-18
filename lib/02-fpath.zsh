# fpath additions that need to be in place *before* oh-my-zsh.sh runs its
# one compinit call — anything added after that would need a second,
# redundant compinit.

# Docker CLI completions
[ -d "$HOME/.docker/completions" ] && fpath=("$HOME/.docker/completions" $fpath)
