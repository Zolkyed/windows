;────────────────────────────────────────────────────────────
; AUTOHOTKEY v2.0
;────────────────────────────────────────────────────────────
#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"

;────────────────────────────────────────────────────────────
; INCLUDES
;────────────────────────────────────────────────────────────
#Include ./Devices/fan.ahk
#Include ./Devices/light.ahk
#Include ./Devices/phone.ahk
#Include ./VD.ahk

; Ensure the configured virtual desktops exist before registering their hotkeys.
VD.createUntil(4)

;────────────────────────────────────────────────────────────
; VIRTUAL DESKTOPS
;────────────────────────────────────────────────────────────
; Switch desktops with Win + number.
#1::VD.goToDesktopNum(1)
#2::VD.goToDesktopNum(2)
#3::VD.goToDesktopNum(3)
#4::VD.goToDesktopNum(4)

; Move the active window with Win + Shift + number.
#+1::VD.MoveWindowToDesktopNum("A", 1)
#+2::VD.MoveWindowToDesktopNum("A", 2)
#+3::VD.MoveWindowToDesktopNum("A", 3)
#+4::VD.MoveWindowToDesktopNum("A", 4)

; Move the active window and follow it with Win + Ctrl + number.
#^1::VD.MoveWindowToDesktopNum("A", 1).follow()
#^2::VD.MoveWindowToDesktopNum("A", 2).follow()
#^3::VD.MoveWindowToDesktopNum("A", 3).follow()
#^4::VD.MoveWindowToDesktopNum("A", 4).follow()

; Create a desktop or remove the current desktop.
#^d::VD.createDesktop(true)
#^Backspace::VD.removeDesktop(VD.getCurrentDesktopNum())

;────────────────────────────────────────────────────────────
; SUSPEND
;────────────────────────────────────────────────────────────
#SuspendExempt True
*F10:: {
    Suspend()
}
#SuspendExempt False

;────────────────────────────────────────────────────────────
; TRAY ICON
;────────────────────────────────────────────────────────────
SetTrayIcon(IconTip, IconURL) {
    iconPath := A_ScriptDir "\tray-icon.png"
    if !FileExist(iconPath) {
        try Download(IconURL, iconPath)
    }
    try TraySetIcon(iconPath)
    try A_IconTip := IconTip
    try (FileExist(iconPath)) ? FileDelete(iconPath) : "" ; Optional cleanup
}
SetTrayIcon("manga", "https://images.icon-icons.com/37/PNG/96/keyboard_4316.png")

;────────────────────────────────────────────────────────────
; DISABLE LOCK LIGHTS
;────────────────────────────────────────────────────────────
SetScrollLockState("AlwaysOff")
SetCapsLockState("AlwaysOff")
SetNumLockState("Off")

;────────────────────────────────────────────────────────────
; LIST OF SCANCODES FOR NUMPAD
;────────────────────────────────────────────────────────────
; https://www.reddit.com/r/MechanicalKeyboards/comments/ldp4rt/how_to_disable_numlock_light_on_keyboard/
; https://www.reddit.com/r/AutoHotkey/comments/cu3mro/help_with_shift_numpad_keys_disabling_windows_os/
; AHK Icon -> Open -> View -> Key History and Script Info
; SC053::NumpadDot
; SC052::Numpad0
; SC04F::Numpad1
; SC050::Numpad2
; SC051::Numpad3
; SC04B::Numpad4
; SC04C::Numpad5
; SC04D::Numpad6
; SC047::Numpad7
; SC048::Numpad8
; SC049::Numpad9

;────────────────────────────────────────────────────────────
; NUMPAD KEYBINDINGS (0-9, .)
;────────────────────────────────────────────────────────────
; https://www.autohotkey.com/docs/v2/KeyList.htm#numpad
; Numpad OFF -> Web Navigation Controls
; Numpad ON -> IoT Device Controls
; Using (Numpad1 / Numpad 7) (Numpad2 / Numpad 8) (Numpad3 / Numpad 9) for increments (4,5,6) to turn on/off
NumpadDot::
NumpadDel:: {
    if !GetKeyState("NumLock", "T") {
        return
    }
    else {
        GetPhoneBattery("http://192.168.2.212:8080/battery")
    }
}

Numpad0::
NumpadIns:: {
    if !GetKeyState("NumLock", "T") {
        return
    }
    else {
        return
    }
}

Numpad1::
NumpadEnd:: {
    if !GetKeyState("NumLock", "T") {
        return
    }
    else {
        return
    }
}

Numpad2::
NumpadDown:: {
    if !GetKeyState("NumLock", "T") {
        NavigateToBottom()
    }
    else {
        AdjustBrightnessLight(entityIDLight, -30)
    }
}

Numpad3::
NumpadPgDn:: {
    if !GetKeyState("NumLock", "T") {
        return
    }
    else {
        return
    }
}

Numpad4::
NumpadLeft:: {
    if !GetKeyState("NumLock", "T") {
        return
    }
    else {
        ToggleFan(entityIDFan)
    }
}

Numpad5::
NumpadClear:: {
    if !GetKeyState("NumLock", "T") {
        return
    }
    else {
        ToggleLight(entityIDLight)
    }
}
Numpad6::
NumpadRight:: {
    if !GetKeyState("NumLock", "T") {
        return
    }
    else {
        MsgBox("Turn On/Off")
    }
}

Numpad7::
NumpadHome:: {
    if !GetKeyState("NumLock", "T") {
        return
    }
    else {
        return
    }
}

Numpad8::
NumpadUp:: {
    if !GetKeyState("NumLock", "T") {
        NavigateToTop()
    }
    else {
        AdjustBrightnessLight(entityIDLight, 30)
    }
}

Numpad9::
NumpadPgUp:: {
    if !GetKeyState("NumLock", "T") {
        return
    }
    else {
        return
    }
}

;────────────────────────────────────────────────────────────
; SECOND NUMPAD KEYBINDINGS FOR (/,*) & (-,+) & (Enter)
;────────────────────────────────────────────────────────────
~NumpadDiv:: {
    if !GetKeyState("NumLock", "T") {
        return
    }
    else {
        return
    }
}

~NumpadMult:: {
    if !GetKeyState("NumLock", "T") {
        return
    }
    else {
        return
    }
}

NumpadSub:: {
    return
}

NumpadAdd:: {
    return
}

NumpadEnter:: {
    if !GetKeyState("NumLock", "T") {
        return
    }
    else {
        SendWebhookPhone("https://trigger.macrodroid.com/98a1a60c-632c-47ca-b33e-7e40ad3f23ab/findPhone")
    }
}

;────────────────────────────────────────────────────────────
; MEDIA VOLUME CONTROL
;────────────────────────────────────────────────────────────
; Media Keys Volume (+10/-10)
; https://www.reddit.com/r/AutoHotkey/comments/aeeir1/adjust_volume_by_5_with_ahk_win_10/
*Volume_Up:: {
    currentVolume := SoundGetVolume()       ; Get the current volume level
    ;SendInput("{Volume_Up}")               ; Show the Windows OSD for Volume Up
    newVolume := Round(currentVolume + 10)  ; Increase volume by 10, but don't exceed 100
    SoundSetVolume(newVolume)               ; Set the new volume level
    return
}

*Volume_Down:: {
    currentVolume := SoundGetVolume()       ; Get the current volume level
    ;SendInput("{Volume_Down}")             ; Show the Windows OSD for Volume Down
    newVolume := Round(currentVolume - 10)  ; Decrease volume by 10, but don't go below 0
    SoundSetVolume(newVolume)               ; Set the new volume level
    return
}

*Volume_Mute:: {
    ;SendInput("{Volume_Mute}")             ; Show the Windows OSD for Mute/Unmute
    SoundSetMute(-1)                        ; Mute/Unmute the system volume
    return
}

;────────────────────────────────────────────────────────────
; CHROME EXTENSIONS SHORTCUTS
;────────────────────────────────────────────────────────────
; Image Downloader
ScrollLock:: {
    SendInput("^{Delete}")
}

;────────────────────────────────────────────────────────────
; APPLICATION LAUNCH SHORTCUTS
;────────────────────────────────────────────────────────────
; --- Shortcut Applications Not On Windows Taskbar ---
; #F1:: HandleApp("Brave")
; #F2:: HandleApp("Suwayomi")
; #F3:: HandleApp2("Hayase")
; #F4:: HandleApp2("Spotify")

; --- Shortcut Applications On Windows Taskbar ---
F1:: {
    SendInput("#^{1}")
}

F2:: {
    SendInput("#^{2}")
}

F3:: {
    SendInput("#^{3}")
}

F4:: {
    SendInput("#^{4}")
}

; --- Shortcut Spotify Playlists ---
Playlists := {
    Manga: "spotify:playlist:6qhXWOPKB8o9xM1zRMLiJn",
    Quality: "spotify:playlist:1QanwoLXN5nEDrXdvY1V1w",
    Creepy: "spotify:playlist:5tWi1kvdZL4oNOasrYQdFe",
    Extra: "spotify:playlist:1bFImNx4XN90RHyfdiedlU"
}

+F1:: {
    Run(Playlists.Manga)
}

+F2:: {
    Run(Playlists.Quality)
}

+F3:: {
    Run(Playlists.Creepy)
}

+F4:: {
    Run(Playlists.Extra)
}

;────────────────────────────────────────────────────────────
; MOUSE NAVIGATION CHAPTERS
;────────────────────────────────────────────────────────────
*XButton1:: {
    SendInput("{Left}")
}

*XButton2:: {
    SendInput("{Right}")
}

;────────────────────────────────────────────────────────────
; MISCELLANEOUS SHORTCUTS
;────────────────────────────────────────────────────────────
; Close & Lock Monitor
#l:: {
    DllCall("LockWorkStation")
    Sleep(250)
    SendMessage(0x112, 0xF170, 2, , "Program Manager")
}

;────────────────────────────────────────────────────────────
; LAUNCH OR FOCUS
;────────────────────────────────────────────────────────────
; Terminal
#t:: LaunchOrFocus("wt.exe", "CASCADIA_HOSTING_WINDOW_CLASS")
#HotIf WinActive("ahk_exe WindowsTerminal.exe")
^t:: {
    SendInput("^+{t}")
}
^w:: {
    SendInput("^+{w}")
}
#HotIf

; File Explorer
#e:: LaunchOrFocus("explorer.exe", "CabinetWClass")
#HotIf WinActive("ahk_class CabinetWClass")
^e:: {
    SendInput("!{d}")
}
#HotIf

; Visual Studio Code
#c:: LaunchOrFocus("Code.exe", "Chrome_WidgetWin_1 ahk_exe Code.exe")

;────────────────────────────────────────────────────────────
; TAB SWITCHING: Chrome / Notepad / Explorer / Windows Terminal
;────────────────────────────────────────────────────────────
#HotIf (WinActive("ahk_class Chrome_WidgetWin_1") or
WinActive("ahk_class Notepad") or
WinActive("ahk_class CabinetWClass") or
WinActive("ahk_exe WindowsTerminal.exe")) and
!WinActive("ahk_exe Code.exe")
^Right:: {
    SendInput("^{Tab}")
}

^Left:: {
    SendInput("^+{Tab}")
}
#HotIf

;────────────────────────────────────────────────────────────
; WEB NAVIGATION
;────────────────────────────────────────────────────────────
; Navigate to the top of the webpage
NavigateToTop() {
    SendInput("{Home}")
}

; Navigate to the bottom of the webpage
NavigateToBottom() {
    SendInput("{End}")
}

;────────────────────────────────────────────────────────────
; Hide Windows Cursor Automatically
;────────────────────────────────────────────────────────────
; SystemCursor("Get") avoid Cursor Flicker not necessary in Main()
; Goal: Hide the cursor only on the active fullscreen window.
; Other fullscreen windows should not affect this behavior (Escape).
global fullScreenActive := 0
SetTimer(Main, 5)
Main() {
    global fullScreenActive

    if (IsFullscreen()) {
        currentActive := WinGetID("A")
        if (currentActive = fullScreenActive) {
            if (SystemCursor("Get")) {
                BlockInput("MouseMove")
                SystemCursor("Hide")
            }
        }
    }
    else {
        if (!SystemCursor("Get")) {
            BlockInput("MouseMoveOff")
            SystemCursor("Show")
        }
    }
}

~F11:: {
    if !IsFullscreen() {
        global fullScreenActive := WinGetID("A") ; Entering fullscreen
        SetTimer(Main, 5) ; Restart timer in case it was stopped by Esc
    }
    else {
        global fullScreenActive := 0 ; Exiting fullscreen
    }
}

~Esc:: {
    if IsFullscreen() {
        KeyWait("Esc")
        currentActive := WinGetID("A")

        if (currentActive = fullScreenActive) {
            if (SystemCursor("Get")) {
                ; Hide cursor again and continue timer
                SetTimer(Main, 5)
                BlockInput("MouseMove")
                SystemCursor("Hide")
            } else {
                ; Show cursor and stop timer
                SetTimer(Main, 0)
                BlockInput("MouseMoveOff")
                SystemCursor("Show")
            }
        }
    }
}

#HotIf !SystemCursor("Get")
RButton:: {
    return ; Disable right click when cursor is hidden
}
LButton:: {
    return ; Disable left click when cursor is hidden
}
#HotIf 
;────────────────────────────────────────────────────────────
; Hide Windows Cursor
;────────────────────────────────────────────────────────────
; Autohide Cursor
; https://www.autohotkey.com/boards/viewtopic.php?t=119211
OnExit (*) => SystemCursor("Show")  ; Ensure the cursor is made visible when the script exits.

SystemCursor(cmd)  ; cmd = "Show|Hide|Toggle|Reload|Get"
{
    static visible := true, c := Map()
    static sys_cursors := [32512, 32513, 32514, 32515, 32516, 32642, 32643, 32644, 32645, 32646, 32648, 32649, 32650]
    if (cmd = "Reload" or !c.Count)  ; Reload when requested or at first call.
    {
        for i, id in sys_cursors {
            h_cursor := DllCall("LoadCursor", "Ptr", 0, "Ptr", id)
            h_default := DllCall("CopyImage", "Ptr", h_cursor, "UInt", 2
                , "Int", 0, "Int", 0, "UInt", 0)
            h_blank := DllCall("CreateCursor", "Ptr", 0, "Int", 0, "Int", 0
                , "Int", 32, "Int", 32
                , "Ptr", Buffer(32 * 4, 0xFF)
                , "Ptr", Buffer(32 * 4, 0))
            c[id] := { default: h_default, blank: h_blank }
        }
    }

    switch cmd {
        case "Get": return visible
        case "Show": visible := true
        case "Hide": visible := false
        case "Toggle": visible := !visible
        default: return
    }
    for id, handles in c {
        h_cursor := DllCall("CopyImage"
            , "Ptr", visible ? handles.default : handles.blank
            , "UInt", 2, "Int", 0, "Int", 0, "UInt", 0)
        DllCall("SetSystemCursor", "Ptr", h_cursor, "UInt", id)
    }
}
;────────────────────────────────────────────────────────────
; Check if Active Window is Fullscreen
;────────────────────────────────────────────────────────────
IsFullscreen() {
    try {
        WinGetPos &x, &y, &w, &h, "A"
        return (w = A_ScreenWidth && h = A_ScreenHeight)
    }
    catch {
        return false
    }
}

;────────────────────────────────────────────────────────────
; APPLICATION LAUNCH SHORTCUTS
;────────────────────────────────────────────────────────────
; HandleApp Function for Window Name
HandleApp(appName) {
    if WinActive(appName) {
        WinMinimize()
    }
    else if WinExist(appName) {
        WinActivate()
    }
    else {
        RunApp(appName)
        WinWait(appName)
        WinActivate()
    }
}

; HandleApp2 Function for Process with .exe using ahk_exe
HandleApp2(appName) {
    winProcess := appName . ".exe"
    if WinActive("ahk_exe " . winProcess) {
        WinMinimize()
    }
    else if WinExist("ahk_exe " . winProcess) {
        WinActivate()
    }
    else {
        RunApp(appName)
        WinWait("ahk_exe " . winProcess)
        WinActivate("ahk_exe " . winProcess)
    }
}

; Run Application
; https://www.youtube.com/watch?v=cRxfVYSUPiQ
RunApp(appName) {
    for app in ComObject("Shell.Application").NameSpace("shell:AppsFolder").Items
        if (app.Name = appName)
            RunWait("explorer shell:appsFolder\" app.Path)
}

;────────────────────────────────────────────────────────────
; LAUNCH OR FOCUS
;────────────────────────────────────────────────────────────
LaunchOrFocus(appExe, winClass) {
    if WinExist("ahk_class " winClass) {
        if WinActive("ahk_class " winClass) {
            WinMinimize()
        } else {
            WinActivate()
        }
    } else {
        Run(appExe)
        WinWait("ahk_class " winClass)
        WinActivate()
    }
}

;────────────────────────────────────────────────────────────
; LAPTOP
;────────────────────────────────────────────────────────────
isLaptop := false
Increments := 10
try {
    CurrentBrightness := GetCurrentBrightNess()
} catch {
    ; Not a laptop
}

for battery in ComObjGet("winmgmts:\\.\root\cimv2").ExecQuery("Select * from Win32_Battery") {
    isLaptop := true
    break
}

#HotIf isLaptop
; --- Shortcut Applications On Windows Taskbar ---
#Volume_Mute:: {
    SendInput("#^{1}")
}

#Volume_Down:: {
    SendInput("#^{2}")
}

#Volume_Up:: {
    SendInput("#^{3}")
}

; --- Shortcut Spotify Playlists ---
#+Volume_Mute:: {
    Run(Playlists.Manga)
}

#+Volume_Down:: {
    Run(Playlists.Quality)
}

#+Volume_Up:: {
    Run(Playlists.Creepy)
}

; Laptop Brightness Control
*F5:: {
    global CurrentBrightness
    CurrentBrightness -= Increments
    ChangeBrightness(&CurrentBrightness)
    return
}

; Laptop Brightness Control
*F6:: {
    global CurrentBrightness
    CurrentBrightness += Increments
    ChangeBrightness(&CurrentBrightness)
    return
}

; Toggle Fan
!F7:: {
    ToggleFan(entityIDFan)
}

; Toggle Light
!F8:: {
    ToggleLight(entityIDLight)
}

; SharpKeys Remap PrintScreen to Media Play/Pause
*PrintScreen::
*SC137:: {
    SendInput("{Media_Play_Pause}")
}
#HotIf

;────────────────────────────────────────────────────────────
; LAPTOP BRIGHTNESS
;────────────────────────────────────────────────────────────
; https://www.autohotkey.com/boards/viewtopic.php?t=83382
ChangeBrightness(&brightness := 50, timeout := 0) {
    if (brightness >= 0 && brightness <= 100) {
        for property in ComObjGet("winmgmts:\\.\root\WMI").ExecQuery("SELECT * FROM WmiMonitorBrightnessMethods")
            property.WmiSetBrightness(timeout, brightness)
    }
    else if (brightness > 100) {
        brightness := 100
    }
    else if (brightness < 0) {
        brightness := 0
    }
}

GetCurrentBrightNess() {
    for property in ComObjGet("winmgmts:\\.\root\WMI").ExecQuery("SELECT * FROM WmiMonitorBrightness")
        currentBrightness := property.CurrentBrightness
    return currentBrightness
}
