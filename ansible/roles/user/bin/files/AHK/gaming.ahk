#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe League of Legends.exe")

LShift::=

toggle := false

$c::
{
    global toggle
    toggle := !toggle

    if toggle
        Send "{c down}"
    else
        Send "{c up}"
}
