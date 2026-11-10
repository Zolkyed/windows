# Visual Studio 2026 (18.0) configuration

Replication files for Visual Studio Community 2026. Two independent stores, applied differently.

| File | Target | Applied by |
| --- | --- | --- |
| `settings.json` | `%LOCALAPPDATA%\Microsoft\VisualStudio\18.0_<hash>\settings.json` | file copy |
| `vs-keys-herdr.vssettings` | keybindings, inside `privateregistry.bin` | settings import |

## settings.json

VS 2026's unified settings store — plain JSON, editable while the IDE runs. Copy it into the
instance directory, whose trailing hash differs per install, so resolve it rather than hardcoding:

```powershell
$dir = Get-ChildItem "$env:LOCALAPPDATA\Microsoft\VisualStudio" -Directory |
       Where-Object Name -like '18.0_*' | Select-Object -First 1
Copy-Item .\settings.json (Join-Path $dir.FullName 'settings.json')
```

`environment.security.trust.locations` is deliberately absent: it is a list of machine-local
folder paths that VS regenerates as you open projects.

## vs-keys-herdr.vssettings

Keybindings live in `privateregistry.bin`, a registry hive locked while `devenv.exe` runs. It
cannot be edited from outside; it must be imported.

**Tools > Import and Export Settings > Import selected environment settings >
No, just import > Browse to this file > tick Keyboard only > Finish.**

Imports merge user shortcuts rather than replacing them, and take effect immediately — no restart.

### Why entries silently do nothing

`<RemoveShortcut>` is a no-op unless **command + scope + key all match exactly**. There is no
error on a miss. A settings *export* only lists user shortcuts, so it cannot tell you what holds
a key — dump the live bindings instead and take the triple from there.

Narrowest scope wins, then Global. A key reaches the integrated terminal only if nothing claims
it in `Terminal` or `Global` scope. You cannot unbind per scope; you relocate the binding to
`Text Editor` instead. That is why `Ctrl+W` appears as a Global removal plus a Text Editor add.

### Two traps in the file format

- An **empty** `<DefaultShortcuts />` wipes existing default overrides. This file lists
  `View.ViewCode` (F7) and `View.ViewDesigner` (Shift+F7) explicitly to preserve them. Omit the
  element or list its contents, never leave it empty.
- `<ShortcutsScheme>` switches keyboard scheme on import. It is left empty here on purpose;
  naming a scheme (e.g. `Visual C++ 6`) would change the scheme on a fresh machine.

### What this file changes

- **Ctrl+E** — freed, by removing six Global chord prefixes. A chord prefix reserves the key.
- **Ctrl+=** / **Ctrl+-** — reassigned to `View.ZoomIn` / `View.ZoomOut` in Global, Text Editor and
  Terminal. Not freed.
- **Ctrl+T** — freed. `Add.To.Chat` (Global) was the real second claimant; `Edit.GoToAll` matches
  nothing in VS 18. Go To All remains on `Ctrl+,` and `Ctrl+P`.
- **Ctrl+W** — editor-only. Global removal, `Ctrl+F4` keeps close-document, `Ctrl+W` re-added in
  Text Editor. Terminal gets word-delete; the editor still closes tabs.
