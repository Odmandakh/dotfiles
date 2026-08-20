#!/usr/bin/env bash
#
# macos/defaults.sh — opinionated macOS system preferences.
#
# Not symlinked or auto-run: ./install.sh offers to run this once, since it
# changes system UI behavior immediately (some settings need a Finder/Dock
# restart, done at the end). Run it again any time to re-apply:
#
#   ./macos/defaults.sh
#
# Every setting below is a single `defaults write` — comment out any line
# you don't want, or find its old value with `defaults read <domain> <key>`
# before changing it if you want to be able to revert by hand.

set -euo pipefail

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

info "Finder"
# Show the path bar and status bar at the bottom of Finder windows.
defaults write com.apple.finder ShowPathbar -bool false
defaults write com.apple.finder ShowStatusBar -bool false
# Show all filename extensions, not just the ones Finder feels like.
defaults write NSGlobalDomain AppleShowAllExtensions -bool false
# Show hidden (dotfile) files.
defaults write com.apple.finder AppleShowAllFiles -bool false
# Show the full path in the Finder window title bar.
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# Default to list view (icnv/clmv/glyv/Nlsv are the other view codes).
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

info "Keyboard"
# Fast key repeat — lowest values macOS honors without extra tools.
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Disable press-and-hold accent picker in favor of key repeat (matters for
# vim/terminal use — hjkl held down should move, not pop up an accent menu).
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

info "Trackpad"
# Tap to click, instead of requiring a physical click.
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

info "Scrolling"
# Enable "natural" scrolling — content moves with your fingers, like a
# touchscreen (scroll down with two fingers moves the page up). This is
# macOS's own default on a fresh install.
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

info "Dock"
# Auto-hide, and remove the show/hide delay so it doesn't feel sluggish.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.4

info "Screenshots"
# Save screenshots as PNG (macOS default) to ~/Screenshots instead of the
# Desktop, so they don't pile up there.
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"

info "Restarting Finder and Dock to apply changes"
killall Finder >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true

info "Done. Some settings (keyboard repeat rate especially) only fully apply after logging out and back in."
