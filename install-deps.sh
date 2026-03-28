#!/usr/bin/env bash
set -e

# Install script for macOS Neovim config dependencies
# Run once on a fresh machine before launching nvim for the first time.

if [[ "$(uname)" != "Darwin" ]]; then
  echo "This script is for macOS only."
  exit 1
fi

# --- Homebrew ---
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing dependencies via Homebrew..."
brew install \
  neovim \
  tree-sitter \
  ripgrep \
  fd \
  fzf \
  gnu-sed

# --- Xcode Command Line Tools (provides clang + make) ---
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
fi

# --- Nerd Font ---
echo "Installing Hack Nerd Font..."
brew install --cask font-hack-nerd-font

echo ""
echo "✅ All dependencies installed."
echo ""
echo "Next steps:"
echo "  1. Set your terminal font to 'Hack Nerd Font'"
echo "  2. Launch nvim — plugins, LSP servers, and Treesitter parsers install automatically"
echo "  3. For Ruby support: gem install standard (or add 'gem \"standard\"' to your project Gemfile)"
