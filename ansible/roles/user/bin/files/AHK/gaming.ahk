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

~$RButton::
{
    While GetKeyState("RButton", "P")
    {
        Click("right")
        Sleep(150)
    }
}

#HotIf
