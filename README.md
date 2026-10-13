# airdrop-paste

AirDrop a screenshot from your phone and it appears in your terminal prompt, ready to send.

Built for [Claude Code](https://claude.com/claude-code): take a screenshot on your iPhone, AirDrop it to your Mac, and a second later it is attached to the prompt you are looking at. No dragging, no Finder, no keystrokes.

It only pastes while a terminal is the app in front. An image that arrives while you are in a browser or anything else stays in `~/Downloads` and nothing is typed anywhere.

## Install

```bash
git clone https://github.com/jasonpurdy4/airdrop-paste.git
cd airdrop-paste && ./install.sh
```

Open a new terminal tab and AirDrop an image to your Mac.

Requires macOS and zsh.

## Where it works

| Terminal | How the paste happens | Permission needed | Tested |
| --- | --- | --- | --- |
| Ghostty 1.3+ | Ghostty's own "input text" command | None | Yes |
| tmux, in any terminal | tmux pastes into the pane of its most recently used client | None | Yes |
| Apple Terminal | Path goes on the clipboard, Cmd+V is pressed for you | Accessibility, once | Yes |
| iTerm2 | iTerm2's own "write text" command | None | Not yet |
| VS Code, Cursor, Windsurf, Warp, kitty, Alacritty, WezTerm, Zed, Hyper | Same as Apple Terminal | Accessibility, once | Not yet |

"Not yet" means the code is there and nobody has confirmed it. If you try one, please open an issue either way.

For the Cmd+V terminals:

- macOS will ask you to allow your terminal under System Settings > Privacy & Security > Accessibility. Until you do, the path is left on the clipboard so a manual Cmd+V still works.
- Your previous clipboard text is put back afterwards. A copied image is not.
- In an editor like VS Code, the paste lands wherever the cursor is, so have the terminal panel focused.

## How it works

1. AirDrop saves every incoming file to `~/Downloads`.
2. `airdrop-paste` looks at that folder once a second for image files that were not there a moment ago.
3. macOS tags each downloaded file with the app that received it. AirDrop's tag is `sharingd`. Files tagged by a browser or chat app are skipped, and so are untagged files, which were made on the Mac itself.
4. It checks which app is in front. If that is a terminal, each AirDropped image's path is pasted there, using the method in the table above, and Claude Code turns a pasted image path into an attachment. If it is any other app, the image is left alone.

5. AirDrop opens a Finder window on the new file and takes focus with it. `airdrop-paste` closes that window and puts you back in the app you were using. macOS asks once for permission to control Finder.

Nothing is ever submitted for you. The path sits in the input box until you press return.

HEIC photos are converted to JPEG first.

## Why it starts from your shell and not launchd

A launchd job would be the tidy way to watch a folder, but macOS does not let background jobs read `~/Downloads`. A program started from a terminal borrows that terminal's permission, so the installer adds one line to `~/.zshrc` that starts the watcher when you open a tab. Only one copy runs at a time, and it exits when the terminal app that started it quits.

## Options

| What | How |
| --- | --- |
| Also paste screenshots taken on the Mac | `export AIRDROP_PASTE_INCLUDE_LOCAL=1` in `~/.zshrc`, above the startup line |
| Paste into the last terminal you used even when another app is in front | `export AIRDROP_PASTE_ALWAYS=1` in `~/.zshrc`, above the startup line |
| Leave the AirDrop Finder window open | `export AIRDROP_PASTE_KEEP_FINDER=1` in `~/.zshrc`, above the startup line |
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
