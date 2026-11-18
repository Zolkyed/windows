# Visual Studio 2026

| File | Target | Apply |
| --- | --- | --- |
| `settings.json` | `%LOCALAPPDATA%\Microsoft\VisualStudio\18.0_<hash>\settings.json` | copy |
| `default.vssettings` | keybindings (`privateregistry.bin`) | import |

Live keybindings: `%LOCALAPPDATA%\Microsoft\VisualStudio\18.0_<hash>\Settings\CurrentSettings.vssettings`

**Tools → Options → Environment → Startup → On startup, open: Most recent solution**

## Keybindings

VS Code muscle memory, terminal left usable for shell and TUI. Unlisted bindings are stock.

| Key | Scope | Command | Note |
| --- | --- | --- | --- |
| `Ctrl+C` | Terminal | `Terminal.Copy` | No selection → falls through as interrupt |
| `Ctrl+Shift+C` | Terminal, Text Editor | `Terminal.Copy`, `Edit.Copy` | |
| `Ctrl+Shift+V` | Terminal, Text Editor | `Terminal.Paste`, `Edit.Paste` | |
| `Ctrl+=` / `Ctrl+-` | Global, Text Editor, Terminal | `View.ZoomIn` / `View.ZoomOut` | |
| `Ctrl+P` | Global | `Edit.GoToFile` | |
| `Ctrl+Shift+P` | Global | `Window.QuickLaunch` | |
| `Ctrl+W` | Text Editor | `Window.CloseDocumentWindow` | Terminal keeps delete-word |
| `Ctrl+F4` | Global | `Window.CloseDocumentWindow` | |
| `Shift+Alt+F` | Text Editor | `Edit.FormatDocument` | |
| `Ctrl+Alt+Left` | Terminal | `Window.Float` | Float terminal; maximize once (`Win+Up`), VS remembers |
| `Ctrl+Alt+Right` | Terminal | `Window.Dock` | Back to its docked spot |

### Removed

| Key | From | Instead |
| --- | --- | --- |
| `Ctrl+E` chords | Test Explorer, Code Coverage, Stack Trace, Task Status, Unpublished Commits | **Test** / **View** menus |
| `Ctrl+T` | `Edit.NavigateTo`, `Add.To.Chat` | `Ctrl+,` |
| `Ctrl+W` (Global) | `Window.CloseDocumentWindow` | `Ctrl+F4` |
| `Ctrl+P` | `File.Print` | **File → Print** |
| `Shift+Alt+F` | `Edit.GoToText` | `Ctrl+Shift+F` |
| `Ctrl+-` | `View.NavigateBackward` | toolbar back |
| `Ctrl+=` | `Edit.SelectToLastGoBack` | — |
| `Ctrl+Shift+V` | `Edit.ShowClipboardHistory`, `Add.To.Chat` | `Ctrl+Shift+Ins` |

## Rules

- Scopes resolve innermost first: `Terminal` → `Text Editor` → `Global`.
- Single-key Global bindings pass through to the shell; chord prefixes don't.
- A key only fires if its command is enabled.
- `RemoveShortcut` matches by key, not command.
- Import replaces all `<UserShortcuts>`; an empty one is a no-op.

## Applying

Windows PowerShell 5.1 (PS7 lacks `GetActiveObject`), VS running:

```powershell
$dte = [Runtime.InteropServices.Marshal]::GetActiveObject('VisualStudio.DTE.18.0')
$dte.ExecuteCommand('Tools.ImportandExportSettings', "/export:`"$HOME\vs-backup.vssettings`"")
$dte.ExecuteCommand('Tools.ImportandExportSettings', '/import:"<path>\default.vssettings"')
```

## Exporting

**Tools → Import and Export Settings… → Export selected environment settings**, clear all, then check:

- **General Settings → Menu and Command Bar Customizations**
- **Options → Environment → Keyboard**
