#!/bin/bash
# Installs airdrop-paste into ~/.local/bin and starts it from your shell profile.
set -euo pipefail

BIN="$HOME/.local/bin"
RC="$HOME/.zshrc"
HOOK='[[ -o interactive ]] && ("$HOME/.local/bin/airdrop-paste" start $$ &>/dev/null &)'

[ "$(uname)" = "Darwin" ] || { echo "airdrop-paste only runs on macOS." >&2; exit 1; }

mkdir -p "$BIN"
cp "$(cd "$(dirname "$0")" && pwd)/airdrop-paste" "$BIN/airdrop-paste"
chmod +x "$BIN/airdrop-paste"

if ! grep -q 'airdrop-paste' "$RC" 2>/dev/null; then
    printf '\n# AirDropped images paste themselves into the terminal you are looking at.\n%s\n' "$HOOK" >> "$RC"
    echo "Added the startup line to $RC"
fi

echo "Installed. Open a new terminal tab, then AirDrop an image to this Mac."
