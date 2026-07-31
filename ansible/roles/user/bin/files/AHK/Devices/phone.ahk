#Requires AutoHotkey v2.0

SendWebhookPhone(url) {
    http := ComObject("WinHttp.WinHttpRequest.5.1")
    http.Open("GET", url, false)
    http.Send()
}

; Make sure PIA setting "Allow LAN Traffic" is enabled for local network requests
GetPhoneBattery(url) {
    http := ComObject("WinHttp.WinHttpRequest.5.1")
    http.Open("GET", url, false)
    http.Send()
    response := http.ResponseText
    MsgBox "Battery = " . response, "Battery Status", "Icon?"
}