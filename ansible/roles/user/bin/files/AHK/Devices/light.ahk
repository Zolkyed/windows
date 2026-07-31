#Requires AutoHotkey v2.0
#Include env.ahk

ToggleLight(entityIDLight) {
    global bearerToken, baseUrl

    lightStatus := GetLightStatus(entityIDLight)
    state := lightStatus.state

    if (state = "on") {
        url := baseUrl "/services/light/turn_off"
    } else {
        url := baseUrl "/services/light/turn_on"
    }

    body := "{`"entity_id`": `" " entityIDLight " `" }"

    http := ComObject("WinHttp.WinHttpRequest.5.1")
    http.Open("POST", url, false)
    http.SetRequestHeader("Content-Type", "application/json")
    http.SetRequestHeader("Authorization", "Bearer " bearerToken)
    http.Send(body)
}

AdjustBrightnessLight(entityIDLight, step) {
    global bearerToken

    lightStatus := GetLightStatus(entityIDLight)

    if (lightStatus.brightness = "" || lightStatus.brightness = "null") {
        return
    }

    currentBrightness := lightStatus.brightness
    newBrightness := currentBrightness + step
    newBrightness := Max(1, Min(255, newBrightness))

    SetLightBrightness(entityIDLight, newBrightness)
}

SetLightBrightness(entityIDLight, brightness) {
    global bearerToken, baseUrl

    url := baseUrl "/services/light/turn_on"
    body := "{`"entity_id`":`"" entityIDLight "`", `"brightness`":" brightness "}"

    http := ComObject("WinHttp.WinHttpRequest.5.1")
    http.Open("POST", url, false)
    http.SetRequestHeader("Content-Type", "application/json")
    http.SetRequestHeader("Authorization", "Bearer " bearerToken)
    http.Send(body)
}

GetLightStatus(entityIDLight) {
    global bearerToken, baseUrl

    url := baseUrl "/states/" entityIDLight

    http := ComObject("WinHttp.WinHttpRequest.5.1")
    http.Open("GET", url, false)
    http.SetRequestHeader("Authorization", "Bearer " bearerToken)
    http.SetRequestHeader("Content-Type", "application/json")
    http.Send()

    response := http.ResponseText

    lightStatus := {}
    RegExMatch(response, '"state"\s*:\s*"([^"]+)"', &stateMatch)
    RegExMatch(response, '"brightness"\s*:\s*(\d+|null)', &brightnessMatch)

    lightStatus.state := stateMatch[1] ? stateMatch[1] : ""
    lightStatus.brightness := (brightnessMatch[1] != "null") ? brightnessMatch[1] : ""

    return lightStatus
}
