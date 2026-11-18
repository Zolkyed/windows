# Windows Terminal

| File | Target | Apply |
| --- | --- | --- |
| `settings.json` | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json` | merge into `"keybindings"` |

## Keybindings

`Alt+Arrow` pane focus is unbound (`"id": null`) so it reaches the shell/TUI for word movement.
