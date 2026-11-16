#!/bin/bash
# Installs airdrop-paste into ~/.local/bin and starts it from your shell profile.
set -euo pipefail

BIN="$HOME/.local/bin"
RC="$HOME/.zshrc"
HOOK='[[ -o interactive ]] && ("$HOME/.local/bin/airdrop-paste" start $$ &>/dev/null &)'

[ "$(uname)" = "Darwin" ] || { echo "airdrop-paste only runs on macOS." >&2; exit 1; }

mkdir -p "$BIN"
# Copy beside it and move into place, so a copy already running keeps reading
# the file it started from rather than one rewritten underneath it.
cp "$(cd "$(dirname "$0")" && pwd)/airdrop-paste" "$BIN/airdrop-paste.new"
chmod +x "$BIN/airdrop-paste.new"
mv -f "$BIN/airdrop-paste.new" "$BIN/airdrop-paste"

# Stop every copy already running, so an update takes effect now. Before
# 2026-11-16 several tabs opening at once (a terminal restoring its windows)
# could each start one, and every AirDrop was pasted once per copy.
if pkill -f "$BIN/airdrop-paste start" 2>/dev/null; then
    for _ in 1 2 3 4 5 6 7 8 9 10; do pgrep -qf "$BIN/airdrop-paste start" || break; sleep 0.3; done
    echo "Stopped the copies that were running"
fi

if ! grep -q 'airdrop-paste' "$RC" 2>/dev/null; then
    printf '\n# AirDropped images paste themselves into the terminal you are looking at.\n%s\n' "$HOOK" >> "$RC"
    echo "Added the startup line to $RC"
fi

# Start one now, from this terminal, so it has this terminal's permission to
# read ~/Downloads. New tabs find it running and leave it be.
("$BIN/airdrop-paste" start "$PPID" &>/dev/null &)

echo "Installed and running. AirDrop an image to this Mac."
