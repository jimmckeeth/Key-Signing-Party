#!/usr/bin/env bash
set -euo pipefail

have() {
  command -v "$1" >/dev/null 2>&1
}

export PATH="$HOME/.cargo/bin:$PATH"

install_debian() {
  if have apt-get; then
    sudo apt-get update
    if sudo apt-get install -y typst; then
      return
    fi
  fi

  if have cargo; then
    cargo install typst-cli
    return
  fi

  if have apt-get; then
    sudo apt-get install -y cargo
    cargo install typst-cli
    return
  fi

  echo "Could not install Typst automatically on this Debian-like system." >&2
  exit 1
}

install_macos() {
  if have brew; then
    brew install typst
    return
  fi

  if have cargo; then
    cargo install typst-cli
    return
  fi

  echo "Homebrew or Cargo is required to install Typst automatically on macOS." >&2
  echo "Install Homebrew from https://brew.sh/ and rerun this script." >&2
  exit 1
}

if have typst; then
  typst --version
  exit 0
fi

case "$(uname -s)" in
  Linux)
    if have apt-get || [[ -f /etc/debian_version ]]; then
      install_debian
    else
      echo "This script supports Debian-like Linux distributions. Install Typst with your distro package manager." >&2
      exit 1
    fi
    ;;
  Darwin)
    install_macos
    ;;
  *)
    echo "Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac

typst --version
