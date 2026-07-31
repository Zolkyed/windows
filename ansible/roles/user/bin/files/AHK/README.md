# ⚙️ Custom Key Mapping Configuration

This configuration defines custom keyboard shortcuts for various applications, media controls, system utilities, and IoT devices.

---

## 🖥️ Applications
| Shortcut | Action       |
|----------|--------------|
| Windows + F1 | 🌐 Open Brave   |
| Windows + F2 | 📚 Open Comick  |
| Windows + F3 | 📖 Open Miru    |
| Windows + F4 | 🎵 Open Spotify |

---

## 🎧 Spotify Controls
| Shortcut     | Action               |
|--------------|----------------------|
| Windows + Shift + F1 | 🎶 Playlist 1 |
| Windows + Shift + F2 | 🎶 Playlist 2 |
| Windows + Shift + F3 | 🎶 Playlist 3 |
| Windows + Shift + F4 | 🎶 Playlist 4 |

---

## 🔄 Suspend Script
| Shortcut | Action                 |
|----------|------------------------|
| F10      | Toggle suspend script  |

---

## 📸 Screenshot Tools
| Shortcut             | Action                        |
|----------------------|-------------------------------|
| PrintScreen          | ✂️ Snipping Tool               |

---

## 🧩 Extensions
| Shortcut            | Action               |
|---------------------|----------------------|
| ScrollLock          | 🧩 Chrome Extensions 1 |

---

## 🎶 Music Controls
| Shortcut   | Action         |
|------------|----------------|
| Insert     | ⏯️ Play/Pause    |
| Home       | 🔊 Volume Up     |
| End        | 🔉 Volume Down   |
| PageUp     | ⏭️ Next Track    |
| PageDown   | ⏮️ Previous Track|

---

## 🌐 Web Navigation (Num Lock OFF)
| Shortcut      | Action             |
|---------------|--------------------|
| NumpadUp      | ⬆️ Scroll to Top     |
| NumpadDown    | ⬇️ Scroll to Bottom  |

---

## 🔌 IoT Device Controls (Num Lock ON)
| Shortcut   | Action              |
|------------|---------------------|
| Numpad4    | 🌬️ Toggle Fan         |
| Numpad8    | 🔆 Increase Light     |
| Numpad5    | 💡 Toggle Light       |
| Numpad2    | 🔅 Decrease Light     |
| Numpad6    | 🔌 Toggle Device Power|
| NumpadEnter| 📱 Locate Phone       |

---

## 🛠️ PowerToys Shortcuts
| Shortcut         | Action           |
|------------------|------------------|
| Windows          | ⚡ PowerToys Run  |
| Windows + Space  | 📌 Always On Top  |

---

## 🔒 Lock Controls
| Shortcut       | Action                        |
|----------------|-------------------------------|
| Windows + L    | 🔒 Lock workstation & turn off monitor |

---

## 🪟 Windows Applications
| Shortcut       | Action             |
|----------------|--------------------|
| Windows + E    | 📁 File Explorer    |
| Windows + C    | 💻 Visual Studio Code |
| Windows + T    | 🖥️ Terminal         |

---

## 📋 TODO
1. 🔄 Support MQTT with HTTP fallback for IoT devices  
2. 💡 Manage Lighting: Use a Smart Switch (API: Turn On/Off) and a Smart Bulb (API: Set Brightness & Change Color)

---

# 📁 Special Folders

Useful Windows shell commands for quick access:

1. **Startup Folder**  
   `shell:startup` → `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup`

2. **User Programs Folder**  
   `shell:programs` → `%APPDATA%\Microsoft\Windows\Start Menu\Programs`

3. **Common Programs Folder**  
   `shell:common programs` → `%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs`

4. **Apps Folder**  
   `shell:appsfolder` → `explorer.exe shell:::{4234d49b-0245-4df3-B780-3893943456e1}`

🔗 **Reference Video:** [Special Folders Overview](https://www.youtube.com/watch?v=Sxt8WrtlUno)

---

## 🧾 Script Setup

1. **Navigate to Startup Folder**  
   `C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`

2. **Compile the Script**  
   🛠️ Compile your automation script into an executable file.

3. **Add Executable to Startup**  
   📂 Move the file into the Startup folder to enable auto-launch at login.

---

## 🌐 Extensions
- 🧩 Stylus  
- 🧩 StyleBot  
- 🧩 Violentmonkey  
- 📥 Image Downloader  
- 🖱️ Smooth Key Scroll  
- 🔗 MAL Sync  
- 🔄 Redirector  
- 🎨 PWA Theme Selector  
- 🧸 AniMouto  

---

## 🎨 Theme
- ⚫ Black Theme  
- ⚫ PWA Black Theme  

---

## 🖱️ Cursor
- ⚫ Black Cursor  
  *(Set via Windows → Mouse Settings)*

---

## 📜 Scrolls
- 🔃 Mousewheel Up/Down  
  *(Windows Settings: 3/4/5 lines per scroll)*  
- 💫 Smooth Scrolling  
  *(Enable in Brave: `brave://flags` → Smooth Scrolling)*  
- 🔼🔽 Arrow Keys  
  *(Extension Chrome → 30px)*

---

## 🧑‍🎨 Scrollbar Customization (Stylus)
- Hide Scrollbar, but keep its functionality (Stylus)
```css
/* Chrome, Edge, Safari */
::-webkit-scrollbar {
  width: 2px !important;
  background: transparent !important;
}
::-webkit-scrollbar-track {
  background: transparent !important;
}
::-webkit-scrollbar-thumb {
  background: transparent !important;
}

/* Firefox */
html, body, * {
  /* keeps it usable but thin */
  scrollbar-width: thin;  
  scrollbar-color: transparent transparent;
}
```

- Force Dark Mode
```css
/* Force dark mode */
body, * {
  background: black !important;
}
```

- Margin for images
```css
/* Add Margin to images for breathing room */
img {
  margin: 5px auto auto;
}
```

---

## 🧩 Chrome Extension

![Downloader](img/downloader.png)

## 🌐 Brave / Chrome — Create a Standalone App Shortcut

When a site doesn't provide a native PWA install, you can make a shortcut that opens the site in a minimal window using the browser's --app flag.

How to
1. Open the Taskbar pins folder: Win+R → `%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar`
2. Create a new shortcut (.lnk) in that folder. For Target use the quoted exe then the --app flag, e.g.:
   `"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe" --app=https://mihon.org`
3. Run the shortcut once, then right‑click its taskbar icon → Pin to taskbar.
4. In the TaskBar folder, open the new .lnk it created and ensure the Target includes the `--app=...` argument.
5. Change the icon via Properties → Change Icon.
`%USERPROFILE%\AppData\Local\BraveSoftware\Brave-Browser\User Data\Profile 3\Web Applications\_crx_mimlljilfkleecloapbpkbnghcekcjpj\Suwayomi.ico`
6. Change the name of the shortcut to your liking.
7. Restart the File Explorer process or log out/in to refresh the taskbar icons.

Quick JS (DevTools) to find the page favicon
```js
const favicon = document.querySelector('link[rel~="icon"]');
console.log(favicon ? favicon.href : "Missing");
```
