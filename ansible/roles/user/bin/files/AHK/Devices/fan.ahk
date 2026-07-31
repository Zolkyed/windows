#Requires AutoHotkey v2.0
#Include env.ahk

ToggleFan(entityIDFan) {
    global bearerToken, baseUrl
    currentToggle := GetFanStatus(entityIDFan)

    if (currentToggle = "on") {
        url := baseUrl "/services/switch/turn_off"
    } else {
        url := baseUrl "/services/switch/turn_on"
    }

    body := "{`"entity_id`": `" " entityIDFan " `" }"

    http := ComObject("WinHttp.WinHttpRequest.5.1")
    http.Open("POST", url, false)
    http.SetRequestHeader("Content-Type", "application/json")
    http.SetRequestHeader("Authorization", "Bearer " bearerToken)
    http.Send(body)
}

GetFanStatus(entityIDFan) {
    global bearerToken, baseUrl

    url := baseUrl "/states/" entityIDFan

    http := ComObject("WinHttp.WinHttpRequest.5.1")
    http.Open("GET", url, false)
    http.SetRequestHeader("Authorization", "Bearer " bearerToken)
    http.SetRequestHeader("Content-Type", "application/json")
    http.Send()

    response := http.ResponseText
    RegExMatch(response, '"state"\s*:\s*"([^"]+)"', &stateMatch)

    if stateMatch[1] {
        return stateMatch[1]
    } else {
        return ""
    }
}