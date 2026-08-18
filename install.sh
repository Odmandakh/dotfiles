#!/usr/bin/env bash
#
# install.sh — reproduce this whole setup (zsh, git, tmux, Homebrew
# packages, macOS defaults) on any machine.
#
#   git clone git@github.com:Odmandakh/dotfiles.git
#   cd dotfiles && ./install.sh
#
# Safe to re-run: it skips anything already installed and backs up any
# existing dotfile it would otherwise overwrite (once — re-running never
# overwrites a .pre-zsh-config.bak that already exists).

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

# --- 0. Sanity checks ------------------------------------------------------
if ! command -v git >/dev/null 2>&1; then
  echo "git is required but not found on PATH. Install git first." >&2
  exit 1
fi

if ! command -v zsh >/dev/null 2>&1; then
  echo "zsh is required but not found on PATH. Install zsh first" >&2
  echo "  macOS:  already installed, or 'brew install zsh'" >&2
  echo "  Debian/Ubuntu: sudo apt install zsh" >&2
  exit 1
fi

# --- 1. oh-my-zsh ------------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing oh-my-zsh"
  # RUNZSH=no: don't drop into a new shell mid-script.
  # CHSH=no:   we ask about the default shell ourselves, at the end.
  # KEEP_ZSHRC=yes: don't let the omz installer touch ~/.zshrc — we symlink
  #   our own right after this, but this avoids it clobbering anything if
  #   that symlink step is ever skipped.
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  info "oh-my-zsh already installed, skipping"
fi

# --- 2. Plugins --------------------------------------------------------
clone_or_update() {
  local repo="$1" dest="$2"
  if [ -d "$dest/.git" ]; then
    info "Updating $(basename "$dest")"
    git -C "$dest" pull --ff-only --quiet || true
  else
    info "Cloning $(basename "$dest")"
    git clone --depth=1 --quiet "$repo" "$dest"
  fi
}

mkdir -p "$ZSH_CUSTOM/plugins"
clone_or_update https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_update https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_update https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
clone_or_update https://github.com/jeffreytse/zsh-vi-mode "$ZSH_CUSTOM/plugins/zsh-vi-mode"
clone_or_update https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"

# --- 3. Symlink dotfiles ------------------------------------------------
link_file() {
  local src="$1" dest="$2"
  if [ -L "$dest" ]; then
    ln -sfn "$src" "$dest"
    info "Re-linked $dest"
    return
  fi
  if [ -e "$dest" ]; then
    if [ -e "$dest.pre-zsh-config.bak" ]; then
      info "$dest exists and a backup already exists too — leaving both alone, just re-linking $dest"
    else
      mv "$dest" "$dest.pre-zsh-config.bak"
      info "Backed up existing $dest -> $dest.pre-zsh-config.bak"
    fi
  fi
  ln -sfn "$src" "$dest"
  info "Linked $dest -> $src"
}

link_file "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/zprofile" "$HOME/.zprofile"
link_file "$DOTFILES_DIR/zshenv" "$HOME/.zshenv"
link_file "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/git/gitconfig-excludes" "$HOME/.gitconfig-excludes"
link_file "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

# --- 4. Powerline/Nerd Font ---------------------------------------------
# agnoster's prompt separators (the arrows/branch icons) render as boxes
# or "?" without a patched font. This installs the font file itself;
# selecting it in your terminal app's preferences is a manual, one-time
# step per machine — see README.md ("Font setup") for exact steps.
# Set SKIP_FONT_INSTALL=1 to skip this step entirely.
install_nerd_font() {
  local font_files_present=0
  local font_dir font_name="MesloLGS NF"

  case "$(uname -s)" in
    Darwin) font_dir="$HOME/Library/Fonts" ;;
    Linux)  font_dir="$HOME/.local/share/fonts" ;;
    *)
      info "Unrecognized OS — skipping automatic font install. See README.md for manual steps."
      return
      ;;
  esac

  if [ -f "$font_dir/MesloLGS NF Regular.ttf" ]; then
    info "$font_name already installed, skipping"
    return
  fi

  info "Installing $font_name (Nerd Font patched with Powerline glyphs, for agnoster)"
  mkdir -p "$font_dir"
  local base_url="https://github.com/romkatv/powerlevel10k-media/raw/master"
  local variant
  for variant in "Regular" "Bold" "Italic" "Bold Italic"; do
    if ! curl -fsSL -o "$font_dir/$font_name $variant.ttf" \
      "$base_url/${font_name// /%20}%20${variant// /%20}.ttf"; then
      info "Could not download $font_name $variant — skipping (check your network). See README.md for a manual download link."
      rm -f "$font_dir/$font_name $variant.ttf"
      continue
    fi
    font_files_present=1
  done

  if [ "$(uname -s)" = "Linux" ] && command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$font_dir" >/dev/null 2>&1 || true
  fi

  if [ "$font_files_present" = "1" ]; then
    info "Font installed to $font_dir. Now select \"$font_name\" in your terminal app's preferences — see README.md (\"Font setup\")."
  fi
}

if [ "${SKIP_FONT_INSTALL:-}" != "1" ]; then
  install_nerd_font
else
  info "SKIP_FONT_INSTALL=1 set, skipping font install"
fi

# --- 5. Homebrew + packages ----------------------------------------------
# macOS only — brew/Brewfile.personal is a Linux/cloud-dev-machine no-op
# anyway, but skip the whole section there rather than print noise.
# Set SKIP_BREW=1 to skip this step entirely (e.g. on a Mac where you
# manage Homebrew packages yourself).
if [ "${SKIP_BREW:-}" = "1" ]; then
  info "SKIP_BREW=1 set, skipping Homebrew step"
elif [ "$(uname -s)" = "Darwin" ]; then
  if ! command -v brew >/dev/null 2>&1; then
    info "Installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  info "Installing core Homebrew packages (brew/Brewfile)"
  brew bundle --file="$DOTFILES_DIR/brew/Brewfile"

  install_personal="${INSTALL_PERSONAL_BREW:-}"
  if [ -z "$install_personal" ] && [ -t 0 ]; then
    read -r -p "Also install brew/Brewfile.personal (extra apps, security tooling — skip on a work laptop)? [y/N] " reply
    [[ "$reply" =~ ^[Yy]$ ]] && install_personal=1
  fi
  if [ "$install_personal" = "1" ]; then
    info "Installing brew/Brewfile.personal"
    brew bundle --file="$DOTFILES_DIR/brew/Brewfile.personal"
  else
    info "Skipping brew/Brewfile.personal — run 'brew bundle --file=brew/Brewfile.personal' yourself later if you want it."
  fi
else
  info "Not macOS — skipping Homebrew/Brewfile step."
fi

# --- 6. macOS system defaults ---------------------------------------------
if [ "$(uname -s)" = "Darwin" ]; then
  run_defaults="${RUN_MACOS_DEFAULTS:-}"
  if [ -z "$run_defaults" ] && [ -t 0 ]; then
    read -r -p "Apply macos/defaults.sh (Finder/Dock/keyboard/trackpad preferences)? [y/N] " reply
    [[ "$reply" =~ ^[Yy]$ ]] && run_defaults=1
  fi
  if [ "$run_defaults" = "1" ]; then
    "$DOTFILES_DIR/macos/defaults.sh"
  else
    info "Skipping macOS defaults — run './macos/defaults.sh' yourself later if you want them."
  fi
fi

# --- 7. Default shell ----------------------------------------------------
zsh_path="$(command -v zsh)"
if [ "${SHELL:-}" != "$zsh_path" ]; then
  info "Your default shell is $SHELL, not zsh."
  if [ -t 0 ]; then
    read -r -p "Set zsh ($zsh_path) as your default shell now? [y/N] " reply
    if [[ "$reply" =~ ^[Yy]$ ]]; then
      if ! grep -qx "$zsh_path" /etc/shells 2>/dev/null; then
        echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
      fi
      chsh -s "$zsh_path"
    fi
  else
    info "Non-interactive shell — skipping the chsh prompt. Run 'chsh -s $zsh_path' yourself if you want zsh as default."
  fi
fi

info "Done. Open a new terminal, or run: exec zsh"
