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
integrated terminal usable for shell and TUI work. Every binding below is a deliberate
entry in `<UserShortcuts>`; stock bindings not listed here are untouched.

### What you get

| Key | Scope | Command | Why |
| --- | --- | --- | --- |
| `Ctrl+C` | Terminal | `Terminal.Copy` | Copies the terminal selection. With **nothing selected** the command is disabled, so the key falls through to the shell and still works as the interrupt. |
| `Ctrl+Shift+C` | Terminal | `Terminal.Copy` | Stock terminal copy, kept as the selection-independent way to copy. |
| `Ctrl+Shift+C` | Text Editor | `Edit.Copy` | Makes the terminal's copy key also copy in the editor, so one pair of keys works in both panes. |
| `Ctrl+Shift+V` | Terminal | `Terminal.Paste` | Stock terminal paste (untouched). |
| `Ctrl+Shift+V` | Text Editor | `Edit.Paste` | The editor half of the same pair. |
| `Ctrl+=` | Global, Text Editor, Terminal | `View.ZoomIn` | VS Code-style zoom. Stock `Ctrl+Shift+.` still works. |
| `Ctrl+-` | Global, Text Editor, Terminal | `View.ZoomOut` | VS Code-style zoom. Stock `Ctrl+Shift+,` still works. |
| `Ctrl+P` | Global | `Edit.GoToFile` | Quick Open by filename. |
| `Ctrl+Shift+P` | Global | `Window.QuickLaunch` | Command palette. Stock `Ctrl+Q` still works. |
| `Ctrl+W` | Text Editor | `Window.CloseDocumentWindow` | Close tab **only while editing**, so the terminal keeps `Ctrl+W` for delete-word-backward. |
| `Ctrl+F4` | Global | `Window.CloseDocumentWindow` | Close tab from anywhere, replacing the Global `Ctrl+W` that was removed. |
| `Shift+Alt+F` | Text Editor | `Edit.FormatDocument` | Format document. Stock `Ctrl+K, Ctrl+D` still works. |

### What is removed, and why

Each `RemoveShortcut` frees a key that the terminal or a remap needs.

| Key freed | Taken from | Reason |
| --- | --- | --- |
| `Ctrl+E, T` / `Ctrl+E, S` / `Ctrl+E, C` / `Ctrl+E, Ctrl+S` / `Ctrl+E, Ctrl+T` / `Ctrl+E, Ctrl+C` | `TestExplorer.ShowTestExplorer`, `TestExplorer.SyncTestInContext`, `View.CodeCoverageResults`, `View.ShowStackTraceExplorer`, `View.ShowTaskStatusCenter`, `View.UnpublishedCommits` | A **chord prefix** in Global scope is swallowed by the IDE while it waits for the second keystroke, so `Ctrl+E` never reaches the shell. Removing all six chords is the only way to get `Ctrl+E` (end-of-line) back in the terminal — there is no VS Code-style `commandsToSkipShell` opt-out. |
| `Ctrl+T` | `Edit.NavigateTo` (Global + Text Editor), `Add.To.Chat` (Global) | Keeps `Ctrl+T` for the shell. `Edit.NavigateTo` still has `Ctrl+,`. |
| `Ctrl+W` | `Window.CloseDocumentWindow` (Global) | A Global binding would close a document while typing in the terminal. Re-added in Text Editor scope plus `Ctrl+F4`. |
| `Ctrl+=` | `Edit.SelectToLastGoBack` (Text Editor) | Makes room for zoom in. |
| `Ctrl+-` | `View.NavigateBackward` (Global) | Makes room for zoom out. |
| `Shift+Alt+F` | `Edit.GoToText` (Global) | Makes room for Format Document. |
| `Ctrl+P` | `File.Print` (Global) | Makes room for Quick Open. See the note on `RemoveShortcut` below — the entry names `Edit.NavigateTo`, but the key is matched, so `File.Print` is what actually loses it. |
| `Ctrl+Shift+V` | `Edit.ShowClipboardHistory` (Text Editor) | Makes room for paste in the editor. |

### Price of the remap

Commands left with no keybinding, and how to reach them instead:

| Command | Lost | Use instead |
| --- | --- | --- |
| `File.Print` | `Ctrl+P` | **File → Print** |
| `View.NavigateBackward` | `Ctrl+-` | Navigate-back button in the toolbar (`View.NavigateForward` keeps `Ctrl+Shift+-`) |
| `Edit.SelectToLastGoBack` | `Ctrl+=` | — |
| `Edit.GoToText` | `Shift+Alt+F` | **Find in Files** on `Ctrl+Shift+F` |
| `Add.To.Chat` | `Ctrl+T`, `Ctrl+Shift+V` | Copilot Chat window, or the editor context menu |
| `Edit.ShowClipboardHistory` | `Ctrl+Shift+V` | `Ctrl+Shift+Ins` |
| Test Explorer, Code Coverage, Stack Trace Explorer, Task Status Center, Unpublished Commits | their `Ctrl+E` chords | **Test** and **View** menus |

`View.ClassView` keeps `Global::Ctrl+Shift+C`. It is shadowed in the editor and the
terminal by the copy bindings above, but still opens Class View when focus is elsewhere,
such as Solution Explorer.

The two `Edit.GoToAll` removals are no-ops — that command does not exist in Visual Studio
2026. They are harmless and kept for portability.

## How Visual Studio resolves a key

Three rules explain every choice above.

1. **Scopes are resolved innermost-first.** A key is looked up in the focused scope
   (`Terminal`, `Text Editor`) before `Global`. That is what lets one key mean copy in the
   terminal and something else everywhere else, with no conflict.
2. **A single-key Global binding passes through to the shell**, which is why `Ctrl+C`
   reaches the terminal as an interrupt at stock settings. A **chord prefix** does not —
   the IDE holds the key while waiting for the second keystroke.
3. **A key only fires if its command is enabled.** `Terminal.Copy` is enabled only when
   the terminal has a selection, so `Ctrl+C` copies with a selection and interrupts
   without one. This is a consequence of command routing, not a setting.

Two gotchas when editing this file:

- **`RemoveShortcut` matches by key, not by command.** An entry naming one command will
  strip that key from whichever command actually holds it.
- **An import replaces the whole `<UserShortcuts>` set.** Always carry every existing
  entry forward; a file containing only a new line wipes the rest. Importing an empty
  `<UserShortcuts/>` is a no-op, not a reset — to undo a set, import its inverse with
  every `Shortcut` and `RemoveShortcut` swapped, then re-add any stock binding the
  inversion over-removed.

## Applying the keybindings

Keybindings live in a locked binary registry hive, so they are imported into the running
IDE rather than copied as a file. From Windows PowerShell 5.1 (`powershell.exe` — PowerShell 7
has no `Marshal::GetActiveObject`), with Visual Studio open:

```powershell
$dte = [Runtime.InteropServices.Marshal]::GetActiveObject('VisualStudio.DTE.18.0')
# back up first
$dte.ExecuteCommand('Tools.ImportandExportSettings', '/export:"$HOME\vs-settings-backup.vssettings"')
$dte.ExecuteCommand('Tools.ImportandExportSettings', '/import:"<path>\default.vssettings"')
```

It applies live, with no restart. To verify afterwards, enumerate `$dte.Commands` and read
each `.Bindings` — that is the authoritative view of what a command is bound to.
