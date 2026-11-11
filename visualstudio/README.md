# Visual Studio 2026 (18.0) configuration

Replication files for Visual Studio Community 2026. Two independent stores, applied differently.

| File | Target | Applied by |
| --- | --- | --- |
| `settings.json` | `%LOCALAPPDATA%\Microsoft\VisualStudio\18.0_<hash>\settings.json` | file copy |
| `default.vssettings` | keybindings, inside `privateregistry.bin` | settings import |

To reopen the most recently used solution at startup:

- Go to **Tools → Options → Environment → Startup**.
- Set **On startup, open** to **Most recent solution**.
- Select **OK**.

## Keybindings

`default.vssettings` moves Visual Studio towards VS Code muscle memory and keeps the
integrated terminal usable for shell and TUI work. Stock bindings not listed stay as they are.

| Key | Scope | Command | Notes |
| --- | --- | --- | --- |
| `Ctrl+C` | Terminal | `Terminal.Copy` | Copies the selection. With nothing selected the command is disabled, so the key falls through to the shell and still interrupts. |
| `Ctrl+Shift+C` | Terminal, Text Editor | `Terminal.Copy`, `Edit.Copy` | Selection-independent copy; one key for both panes. |
| `Ctrl+Shift+V` | Terminal, Text Editor | `Terminal.Paste`, `Edit.Paste` | Same pair for paste. Terminal side is stock. |
| `Ctrl+=` / `Ctrl+-` | Global, Text Editor, Terminal | `View.ZoomIn` / `View.ZoomOut` | Stock `Ctrl+Shift+.` / `Ctrl+Shift+,` still work. |
| `Ctrl+P` | Global | `Edit.GoToFile` | Quick Open. |
| `Ctrl+Shift+P` | Global | `Window.QuickLaunch` | Command palette. `Ctrl+Q` still works. |
| `Ctrl+W` | Text Editor | `Window.CloseDocumentWindow` | Editor only, so the terminal keeps `Ctrl+W` for delete-word-backward. |
| `Ctrl+F4` | Global | `Window.CloseDocumentWindow` | Close tab from anywhere. |
| `Shift+Alt+F` | Text Editor | `Edit.FormatDocument` | `Ctrl+K, Ctrl+D` still works. |

### Keys freed for the terminal and the remaps

| Key | Taken from | Use instead |
| --- | --- | --- |
| `Ctrl+E` chords (6) | Test Explorer, Code Coverage, Stack Trace Explorer, Task Status Center, Unpublished Commits | **Test** / **View** menus |
| `Ctrl+T` | `Edit.NavigateTo`, `Add.To.Chat` | `Ctrl+,` for Go To |
| `Ctrl+W` (Global) | `Window.CloseDocumentWindow` | `Ctrl+F4` |
| `Ctrl+P` | `File.Print` | **File → Print** |
| `Shift+Alt+F` | `Edit.GoToText` | `Ctrl+Shift+F` (Find in Files) |
| `Ctrl+-` | `View.NavigateBackward` | toolbar back button (`Ctrl+Shift+-` still goes forward) |
| `Ctrl+=` | `Edit.SelectToLastGoBack` | — |
| `Ctrl+Shift+V` | `Edit.ShowClipboardHistory` | `Ctrl+Shift+Ins` |
| `Ctrl+Shift+V` | `Add.To.Chat` | Copilot Chat window or context menu |

A Global **chord prefix** is swallowed while the IDE waits for the second keystroke, so all
six `Ctrl+E` chords must go before `Ctrl+E` reaches the shell. `View.ClassView` keeps
`Global::Ctrl+Shift+C` and still opens from Solution Explorer. The two `Edit.GoToAll`
removals are no-ops — no such command in 2026.

## Rules worth knowing

- Scopes resolve **innermost first** (`Terminal`, `Text Editor`, then `Global`), which is how
  one key means different things per pane without conflict.
- A single-key Global binding **passes through to the shell**; a chord prefix does not.
- A key only fires if its command is **enabled** — that is why `Ctrl+C` copies with a
  selection and interrupts without one.
- `RemoveShortcut` matches **by key, not by command**: it strips that key from whichever
  command actually holds it.
- An import **replaces** the whole `<UserShortcuts>` set, so carry every entry forward. An
  empty `<UserShortcuts/>` is a no-op, not a reset; undo a set by importing its inverse.

## Applying

Keybindings live in a locked registry hive, so they are imported into the running IDE. From
Windows PowerShell 5.1 (`powershell.exe` — PS7 has no `Marshal::GetActiveObject`):

```powershell
$dte = [Runtime.InteropServices.Marshal]::GetActiveObject('VisualStudio.DTE.18.0')
$dte.ExecuteCommand('Tools.ImportandExportSettings', '/export:"$HOME\vs-backup.vssettings"')
$dte.ExecuteCommand('Tools.ImportandExportSettings', '/import:"<path>\default.vssettings"')
```

Applies live, no restart. Verify by reading `.Bindings` off `$dte.Commands`.
