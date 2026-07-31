## 📘 Home Assistant REST API Quick Reference

Official Docs: [Home Assistant REST API](https://developers.home-assistant.io/docs/api/rest/)

### 🔍 Get Entity State

Retrieve the current state and attributes of a specific entity.

```
GET /api/states/<entity_id>
```

- **Example**:  
  `/api/states/light.living_room`

- **Returns**: JSON object with state and attributes.
```json
{
    "entity_id": "light.gabriel_desk_light",
    "state": "off",
    "attributes": {
        "min_color_temp_kelvin": 1500,
        "max_color_temp_kelvin": 9000,
        "min_mireds": 111,
        "max_mireds": 666,
        "effect_list": [
            "effect_colorloop",
            "effect_pulse",
            "effect_stop"
        ],
        "supported_color_modes": [
            "color_temp",
            "hs"
        ],
        "effect": null,
        "color_mode": null,
        "brightness": null,
        "color_temp_kelvin": null,
        "color_temp": null,
        "hs_color": null,
        "rgb_color": null,
        "xy_color": null,
        "friendly_name": "Gabriel Desk Light",
        "supported_features": 36
    },
    "last_changed": "2025-04-24T15:47:53.485888+00:00",
    "last_reported": "2025-04-24T17:36:11.477523+00:00",
    "last_updated": "2025-04-24T15:47:53.485888+00:00",
    "context": {
        "id": "01JSM7QTGDA6R2W774DDPM8NES",
        "parent_id": null,
        "user_id": null
    }
}
```

---

### ⚙️ Call a Service

Trigger a service within a specific domain (e.g., turning on a light, sending a notification).

```
POST /api/services/<domain>/<service>
```

- **Example**:  
  `/api/services/light/turn_on`

- **Payload** (JSON body):

```json
{
  "entity_id": "light.gabriel_desk_light"
}
```

---

### 💡 Smart Light

#### Smart Switch
- Requires a **Newer Home** with a **Neutral Wire**  
- API request to turn the light **on/off** → **Smart Switch**
- API request to adjust **brightness** → **Smart Light**

> Recommended Smart Light

#### Dumb Switch
- Compatible with **Old or New Homes**  
- API request to turn the light **on/off** → **Smart Light**
- API request to adjust **brightness** → **Smart Light**

> Recommended Smart Light

#### Smart Dimmer Switch
- API request to turn the light **on/off** → **Smart Dimmer Switch**
- API request to adjust **brightness** → **Smart Dimmer Switch**

> Recommended Dumb Light

#### Dumb Dimmer Switch
- **Philips Hue Smart Dimmer**
- Integrated with **Home Assistant** via **Zigbee2MQTT**
- **Automations**:
  - Turn **on/off** the light using the dimmer -> **Smart Light**
  - **Increase/decrease brightness** using the dimmer -> **Smart Light**
- API request to turn the light **on/off** → **Smart Light**
- API request to adjust **brightness** → **Smart Light**

> Recommended Smart Light

https://community.home-assistant.io/t/philips-hue-dimmer-switch-zigbee2mqtt-custom-actions/308654

---

 ❌ **Warning:**  
- Avoid using a **Dumb Dimmer Switch** directly with a **Smart Light**.  
- This can cause unpredictable behavior or damage to the light due to incompatible dimming control.
