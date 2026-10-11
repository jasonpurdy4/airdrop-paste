# airdrop-paste

AirDrop a screenshot from your phone and it appears in your terminal prompt, ready to send.

Built for [Claude Code](https://claude.com/claude-code) in [Ghostty](https://ghostty.org): take a screenshot on your iPhone, AirDrop it to your Mac, and a second later it is attached to the prompt you are looking at. No dragging, no Finder, no keystrokes.

## Install

```bash
git clone https://github.com/jasonpurdy4/airdrop-paste.git
cd airdrop-paste && ./install.sh
```

Open a new Ghostty tab and AirDrop an image to your Mac.

Requires macOS, Ghostty 1.3 or later, and zsh.

## How it works

1. AirDrop saves every incoming file to `~/Downloads`.
2. `airdrop-paste` looks at that folder once a second for image files that were not there a moment ago.
3. macOS tags each downloaded file with the app that received it. AirDrop's tag is `sharingd`. Files tagged by a browser or chat app are skipped, and so are untagged files, which were made on the Mac itself.
4. For each AirDropped image, it asks Ghostty to paste the file's path into the terminal you have in front. Claude Code turns a pasted image path into an attachment.

Nothing is ever submitted for you. The path sits in the input box until you press return.

It works the same inside tmux or out of it, because Ghostty does the pasting. HEIC photos are converted to JPEG first.

## Why it starts from your shell and not launchd

A launchd job would be the tidy way to watch a folder, but macOS does not let background jobs read `~/Downloads`. A program started from a Ghostty shell borrows Ghostty's permission, so the installer adds one line to `~/.zshrc` that starts the watcher when you open a tab. Only one copy runs at a time, and it exits when Ghostty quits.

## Options

| What | How |
| --- | --- |
| Also paste screenshots taken on the Mac | `export AIRDROP_PASTE_INCLUDE_LOCAL=1` in `~/.zshrc`, above the startup line |
| Stop it | `airdrop-paste stop` |
| See what it did and why | `~/Library/Logs/airdrop-paste.log` |

## Uninstall

```bash
airdrop-paste stop
rm ~/.local/bin/airdrop-paste
```

Then delete the `airdrop-paste` line from `~/.zshrc`.

## License

MIT
