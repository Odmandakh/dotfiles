# dotfiles

My personal machine setup — clone it, run `./install.sh`, get the same
environment everywhere: new MacBook, work laptop, cloud dev machine.

```sh
git clone git@github.com:Odmandakh/dotfiles.git
cd dotfiles
./install.sh
```

## Contents

- [What `install.sh` does](#what-installsh-does)
- [What's included](#whats-included)
- [Font setup](#font-setup)
- [Layout](#layout)
- [Updating](#updating)

## What `install.sh` does

- Installs [oh-my-zsh](https://ohmyz.sh) if it's missing.
- Clones the zsh plugins below into `$ZSH_CUSTOM/plugins`.
- Symlinks `~/.zshrc`, `~/.zprofile`, `~/.zshenv`, `~/.gitconfig`, and
  `~/.tmux.conf` to the files in this repo — backing up anything already
  there as `*.pre-zsh-config.bak`, once.
- Installs Homebrew and the core package list on macOS.
- Offers to apply a curated set of macOS system preferences.

Re-running it later is safe — it just updates plugins/packages and
re-links.

## What's included

| Area | Details |
| --- | --- |
| **Zsh theme** | [agnoster](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#agnoster). Needs a Powerline/Nerd Font to render correctly — `install.sh` installs the font file automatically, but you pick it in your terminal's preferences once per machine. See [Font setup](#font-setup). |
| **Zsh plugins** | `git`, [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [zsh-completions](https://github.com/zsh-users/zsh-completions), [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting). |
| **Solarized** | A terminal color scheme (not a zsh theme), so it pairs with agnoster rather than replacing it. Vendored at `terminal/solarized-dark.itermcolors` / `terminal/solarized-light.itermcolors` (from [mbadolato/iTerm2-Color-Schemes](https://github.com/mbadolato/iTerm2-Color-Schemes)). Import one into iTerm2 manually: **Preferences > Profiles > Colors > Color Presets > Import...**. |
| **Git** | `git/gitconfig` — identity, aliases (`st`, `co`, `br`, `ci`, `lg`), sane defaults (`main` as default branch, `osxkeychain` credential helper). Supports a `~/.gitconfig.local` include for per-machine overrides (e.g. a work email) — gitignored, same idea as `lib/local.zsh` on the zsh side. |
| **tmux** | `tmux/tmux.conf` — mouse mode, vi copy-mode keys, big scrollback, minimal status bar. |
| **Homebrew** | `brew/Brewfile` — core (`git`, `gh`, `jq`, `openjdk@21`), installed on every machine, no prompt. `brew/Brewfile.personal` — everything else on this machine, including security/pentesting tooling and personal apps. Tracked for reproducibility, but only installed if you say yes at the `install.sh` prompt, or run it explicitly: `brew bundle --file=brew/Brewfile.personal`. Keep work-laptop-unsafe stuff out of the core file. Set `SKIP_BREW=1` to skip this step entirely. |
| **macOS defaults** | `macos/defaults.sh` — Finder (show hidden files/extensions, path+status bar), fast key repeat, tap-to-click, Dock auto-hide, screenshots to `~/Screenshots`. Never runs automatically; `install.sh` prompts, or run it directly any time: `./macos/defaults.sh`. |

## Font setup

The agnoster prompt draws its arrow/branch separators using special
Powerline glyphs. A normal font doesn't have those characters, so
without the right font the prompt shows boxes or `?` instead of clean
arrows.

`install.sh` downloads and installs the font automatically — a Nerd
Font build of Meslo called **"MesloLGS NF"** (the same font recommended
by Powerline and Powerlevel10k, so it also covers you if you switch
themes later). It's copied to:

- macOS: `~/Library/Fonts`
- Linux: `~/.local/share/fonts`

That's the part a script *can* do. The part it can't: telling your
terminal app to actually use that font — that's a setting inside each
terminal app's own preferences, with no safe command-line way to flip
it for you (especially for GUI apps like Terminal.app or iTerm2). Do
this once per machine, right after running `./install.sh`:

**iTerm2**

1. Open **iTerm2 > Settings** (or **Preferences**) from the menu bar.
2. Go to the **Profiles** tab, select the profile you use (usually
   "Default"), then the **Text** sub-tab.
3. Under **Font**, click the font name/**Change Font** button and pick
   **MesloLGS NF**, size 12–14 (whatever felt right in your old font).
4. Close the settings — open a new tab or window to see the change.

**Terminal.app (macOS default)**

1. Open **Terminal > Settings** (or **Preferences**) from the menu bar.
2. Go to the **Profiles** tab, select your profile on the left, then
   the **Text** tab on the right.
3. Click **Change...** under **Font**, choose **MesloLGS NF**, and
   click **Select**.
4. Open a new window to see the change.

**Another terminal app** (Warp, Alacritty, Kitty, VS Code's integrated
terminal, etc.) — the same idea applies: open that app's font setting
and choose **MesloLGS NF** by name.

> If the font doesn't appear in the list, the terminal app was already
> open when `install.sh` installed it — quit and reopen the app (or log
> out/in on Linux) so it picks up the new font, then try again.

## Layout

```
zshrc              # symlinked to ~/.zshrc — thin, just sources lib/*.zsh in order
zprofile           # symlinked to ~/.zprofile — login-shell PATH/env setup
zshenv             # symlinked to ~/.zshenv — PATH/env for *every* shell,
                   #   including non-interactive/non-login (ssh, cron, VS Code
                   #   Remote-SSH's server shell)
lib/
  00-theme.zsh       # ZSH_THEME
  01-plugins.zsh     # oh-my-zsh plugin list
  02-fpath.zsh       # fpath additions needed before oh-my-zsh's compinit
  10-path.zsh        # PATH for dev tools (Go, PHP, Java/JDK, ~/.local/bin)
  11-completions.zsh # nvm, Google Cloud SDK
  20-aliases.zsh     # personal aliases
  local.zsh          # gitignored — machine-only overrides, if ever needed
terminal/
  solarized-dark.itermcolors  # iTerm2 color preset, import manually
  solarized-light.itermcolors # iTerm2 color preset, import manually
git/
  gitconfig            # symlinked to ~/.gitconfig
  gitconfig-excludes   # symlinked to ~/.gitconfig-excludes — global gitignore
tmux/
  tmux.conf            # symlinked to ~/.tmux.conf
brew/
  Brewfile             # core packages, installed on every machine
  Brewfile.personal    # everything else, opt-in only
macos/
  defaults.sh          # macOS system preferences, opt-in only
install.sh
```

Every entry in `lib/` is guarded by an existence check (`[ -d ... ]` /
`[ -f ... ]`), so cloning this onto a machine that's missing one of
these tools doesn't break the shell — that block is just skipped. Add
a new file under `lib/` (numbered so load order stays predictable)
rather than growing any single file.

## Updating

Edit the files in this repo (in your clone on any machine — `~/.zshrc`
is a symlink to `zshrc` here, so changes apply immediately in new
shells), commit, and push.

- On other machines: `git pull && ./install.sh` picks up plugin/package
  changes.
- A plain `git pull` is enough for anything under `lib/`, `git/`, or
  `tmux/`, since those are sourced/read directly through the symlink.
