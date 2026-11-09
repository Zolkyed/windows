;────────────────────────────────────────────────────────────
; AUTOHOTKEY v2.0
;────────────────────────────────────────────────────────────
#Requires AutoHotkey v2.0
#SingleInstance Force

;────────────────────────────────────────────────────────────
; SMART CTRL+C FOR THE VISUAL STUDIO TERMINAL
;────────────────────────────────────────────────────────────
; text selected    -> copy
; nothing selected -> real Ctrl+C (interrupts Claude Code / copies in editor)
;
; Setup: in Visual Studio, Tools > Options > Environment > Keyboard,
; bind the terminal Copy command to Ctrl+Alt+Shift+C (terminal scope).
; If Visual Studio runs as administrator, run this script as administrator too.
#HotIf WinActive("ahk_exe devenv.exe")
$^c:: {
    saved := ClipboardAll()
    A_Clipboard := ""
    Send "^+c"              ; terminal copy (bound in Visual Studio)
    if ClipWait(0.15)        ; text was selected, so it copied
        return
    A_Clipboard := saved     ; nothing selected: restore clipboard
    Send "^c"                ; editor copy, or interrupt in terminal
}
#HotIf
