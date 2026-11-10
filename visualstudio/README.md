# Visual Studio 2026 (18.0) configuration

Replication files for Visual Studio Community 2026. Two independent stores, applied differently.

| File | Target | Applied by |
| --- | --- | --- |
| `settings.json` | `%LOCALAPPDATA%\Microsoft\VisualStudio\18.0_<hash>\settings.json` | file copy |
| `default.vssettings` | keybindings, inside `privateregistry.bin` | settings import |
