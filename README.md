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
- [Shell tool cheatsheet](#shell-tool-cheatsheet)
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
| **Zsh plugins** | `git`, [zsh-completions](https://github.com/zsh-users/zsh-completions), [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting), [zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode) (vim-style command-line editing), [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) (↑/↓ filters history by what you've typed). Load order matters — see the comment in `lib/01-plugins.zsh`. |
| **Shell tooling** | [zoxide](https://github.com/ajeetdsouza/zoxide) (`z`/`zi` — smarter `cd`), [fzf](https://github.com/junegunn/fzf) (`Ctrl+T` files, `Alt+C` cd), and [atuin](https://github.com/atuinsh/atuin) (`Ctrl+R` — SQLite-backed searchable history; deliberately loaded after fzf so it wins that binding, and with `--disable-up-arrow` so up/down stay on zsh-history-substring-search), all wired up in `lib/11-completions.zsh`. Atuin's config/data live outside this repo (`~/.config/atuin`, `~/.local/share/atuin`) and aren't tracked here — same as any other machine-local state; sync/login is opt-in (`atuin register`/`login`), not set up by this repo. [eza](https://github.com/eza-community/eza) and [bat](https://github.com/sharkdp/bat) are aliased over `ls`/`cat` in `lib/20-aliases.zsh`; [fd](https://github.com/sharkdp/fd) and [ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) are installed but deliberately not aliased over `find`/`grep` — their flags aren't compatible, use them directly. |
| **Solarized** | A terminal color scheme (not a zsh theme), so it pairs with agnoster rather than replacing it. Vendored at `terminal/solarized-dark.itermcolors` / `terminal/solarized-light.itermcolors` (from [mbadolato/iTerm2-Color-Schemes](https://github.com/mbadolato/iTerm2-Color-Schemes)). Import one into iTerm2 manually: **Preferences > Profiles > Colors > Color Presets > Import...**. |
| **Git** | `git/gitconfig` — identity, aliases (`st`, `co`, `br`, `ci`, `lg`), sane defaults (`main` as default branch, `osxkeychain` credential helper). Supports a `~/.gitconfig.local` include for per-machine overrides (e.g. a work email) — gitignored, same idea as `lib/local.zsh` on the zsh side. |
| **tmux** | `tmux/tmux.conf` — mouse mode, vi copy-mode keys, big scrollback, minimal status bar. |
| **Homebrew** | `brew/Brewfile` — core (`git`, `gh`, `jq`, `openjdk@21`, `zoxide`, `fzf`, `eza`, `fd`, `ripgrep`, `bat`), installed on every machine, no prompt. `brew/Brewfile.personal` — everything else on this machine, personal apps and extra runtimes. `brew/Brewfile.ctf` — the Homebrew-installable subset of [OSX-CTF-Ready](https://github.com/Odmandakh/OSX-CTF-Ready) (nmap, metasploit, ghidra, wireshark, hashcat, etc.) for gearing up for a CTF; the non-Homebrew parts of that setup (wordlists, `pipx` tools, wget'd scripts) live in that repo, not here. Both `.personal` and `.ctf` are tracked for reproducibility but only installed if you say yes at the `install.sh` prompt, or run explicitly (`brew bundle --file=brew/Brewfile.personal` / `.ctf`) — never on a work laptop. Set `SKIP_BREW=1` to skip the whole Homebrew step. |
| **macOS defaults** | `macos/defaults.sh` — Finder (show hidden files/extensions, path+status bar), fast key repeat, tap-to-click, disabled natural (reversed) scrolling, Dock auto-hide, screenshots to `~/Screenshots`. Never runs automatically; `install.sh` prompts, or run it directly any time: `./macos/defaults.sh`. |

## Shell tool cheatsheet

Open a new terminal (or `exec zsh`) after pulling these changes so the config in `lib/` actually loads.

**zoxide — smarter `cd`**
- `z <partial-name>` — jump to a frecency-ranked match, e.g. `z proj` after you've `cd`'d into `~/dev/big-project` a few times.
- `z foo bar` — multiple fragments narrow the match.
- `zi <partial-name>` — same, but opens an fzf picker when more than one match is plausible.
- It only knows directories you've already `cd`'d into normally — needs a bit of regular use to build up history.

**fzf — fuzzy finder** (bound in `lib/11-completions.zsh`)
- `Ctrl+T` — fuzzy-search files/dirs under the cwd, inserts the picked path at the cursor.
- `Alt+C` — fuzzy-search subdirectories and `cd` straight into the pick.
- Type to filter, arrows to move, `Enter` to select, `Esc` to cancel.
- `Ctrl+R` is atuin's, not fzf's — see below.

**atuin — searchable shell history** (bound in `lib/11-completions.zsh`, owns `Ctrl+R`)
- `Ctrl+R` — full-screen fuzzy search over your entire history (SQLite-backed, not just the current session's `HISTFILE`), with filters for directory/host/session.
- Up/down arrows are untouched — still zsh-history-substring-search (`lib/14-bindings.zsh`), not atuin's inline search.
- Sync across machines is opt-in and not configured by this repo — run `atuin register` (new account) or `atuin login` (existing account) yourself if you want it. Local-only works out of the box with no account.
- Config lives at `~/.config/atuin/config.toml`, data at `~/.local/share/atuin/` — both machine-local, not tracked in this repo.

**eza — replaces `ls`** (aliased in `lib/20-aliases.zsh`)
- `ls` — grouped-directories-first listing.
- `ll` — long format with a git status column.
- `la` — long format, includes hidden files.
- `lt` — 2-level tree view.

**bat — replaces `cat`** (aliased)
- `cat somefile.js` — syntax-highlighted, with line numbers, automatically.
- `bat -A file` — show non-printable characters, same idea as `cat -A`.
- `bat --diff` — shows git-diff markers in the gutter inside a git repo.

**fd — `find` replacement** (installed, not aliased — call directly; flags aren't `find`-compatible)
- `fd pattern` — recursively find files/dirs by name, respecting `.gitignore`.
- `fd -e md` — only `.md` files.
- `fd -H pattern` — include hidden files (excluded by default).

**ripgrep (`rg`) — `grep` replacement** (installed, not aliased — call directly)
- `rg "TODO"` — recursively search file contents, respecting `.gitignore`, much faster than `grep -r`.
- `rg -i "pattern"` — case-insensitive.
- `rg -t js "pattern"` — restrict to a file type.
- `rg -l "pattern"` — list matching filenames only.

`Ctrl+T` in fzf already uses `fd` for its file list and `bat` for the preview pane — that combo works out of the box, no extra config needed.

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
  11-completions.zsh # zoxide, fzf, atuin, nvm, Google Cloud SDK
  12-history.zsh     # HISTFILE/HISTSIZE/SAVEHIST + history dedup options
  13-shell-options.zsh # AUTOCD, NOBEEP, NUMERIC_GLOB_SORT
  14-bindings.zsh    # custom keybindings (history-substring-search)
  20-aliases.zsh     # personal aliases + eza/bat replacements for ls/cat
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
  Brewfile.ctf         # pentest/CTF tooling, opt-in only, never on a work laptop
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
