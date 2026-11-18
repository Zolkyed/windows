# Windows Terminal

Target: `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`

## Keybindings

Unbind pane focus so `Alt+Arrow` reaches the shell/TUI (word movement). Add to `"keybindings"`:

```json
{ "id": null, "keys": "alt+left" },
{ "id": null, "keys": "alt+right" },
{ "id": null, "keys": "alt+up" },
{ "id": null, "keys": "alt+down" }
```
