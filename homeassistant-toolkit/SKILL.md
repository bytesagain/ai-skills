---
version: "2.0.0"
name: homeassistant-toolkit
description: "Deep integration with Home Assistant via REST API. Control devices, manage automations, query entity states, and manage scenes/scripts from the command line. Use when you need homeassistant toolkit capabilities. Triggers on: homeassistant toolkit."
author: BytesAgain
---

# Home Assistant Toolkit

> Full-featured CLI for Home Assistant power users. Control your smart home without opening a browser.

## Prerequisites

| Requirement | Details |
|---|---|
| Home Assistant | 2023.1+ with REST API enabled |
| Long-Lived Access Token | Generate at `/profile` → Long-Lived Access Tokens |
| Python 3.6+ | Pre-installed on most systems |
| `curl` | For direct API calls (fallback) |

## Environment Variables

```bash
export HA_URL="[configured-endpoint]    # Your HA instance URL
export HA_TOKEN="eyJ0eXAiOiJKV..."           # Long-Lived Access Token
```

## Quick Start

```bash
# Check connection & server info
bash scripts/ha-toolkit.sh status

# List all entities
bash scripts/ha-toolkit.sh entities

# Turn on a light
bash scripts/ha-toolkit.sh call light.turn_on light.living_room

# Get entity state
bash scripts/ha-toolkit.sh state sensor.temperature_outdoor

# Fire an automation
bash scripts/ha-toolkit.sh automation trigger automation.morning_routine

# List all scenes and activate one
bash scripts/ha-toolkit.sh scenes
bash scripts/ha-toolkit.sh scene activate scene.movie_night
```

## Commands Reference

### Device Control

| Command | Description |
|---|---|
| `call <service> <entity_id> [json_data]` | Call any HA service with optional JSON payload |
| `toggle <entity_id>` | Toggle an entity on/off |
| `state <entity_id>` | Get full state + attributes of an entity |
| `entities [domain]` | List entities, optionally filtered by domain |
| `history <entity_id> [hours]` | Fetch state history (default: 24h) |

### Automation Management

| Command | Description |
|---|---|
| `automations` | List all automations with status |
| `automation trigger <automation_id>` | Manually trigger an automation |
| `automation enable <automation_id>` | Enable a disabled automation |
| `automation disable <automation_id>` | Disable an automation |

### Scenes & Scripts

| Command | Description |
|---|---|
| `scenes` | List all configured scenes |
| `scene activate <scene_id>` | Activate a scene |
| `scripts` | List all scripts |
| `script run <script_id>` | Run a script |

### System & Diagnostics

| Command | Description |
|---|---|
| `status` | HA server info (version, location, timezone) |
| `config` | Show full HA configuration |
| `logs [lines]` | Fetch recent HA log entries |
| `services [domain]` | List available services |
| `dashboard` | Interactive overview of key entities |

## Advanced Usage

### Bulk Operations

```bash
# Turn off all lights
bash scripts/ha-toolkit.sh call light.turn_off all

# Set multiple attributes
bash scripts/ha-toolkit.sh call light.turn_on light.bedroom '{"brightness": 128, "color_temp": 350}'
```

### Monitoring Mode

```bash
# Watch an entity for changes (polls every 5 seconds)
bash scripts/ha-toolkit.sh watch sensor.power_consumption 5
```

### Integration with Cron

```bash
# Check garage door every 30 min, notify if open
*/30 * * * * bash /path/to/ha-toolkit.sh state cover.garage_door | grep -q "open" && echo "Garage is open!" | mail -s "Alert" you@example.com
```

## Error Handling

The toolkit validates:
- `HA_URL` and `HA_TOKEN` are set before any API call
- HTTP response codes (401 unauthorized, 404 not found, etc.)
- JSON parsing with graceful fallback
- Network connectivity with timeout controls

## Troubleshooting

**"Connection refused"** — Verify HA is running and the URL is correct. Check firewall rules.

**"401 Unauthorized"** — Your token may be expired or invalid. Generate a new one from the HA profile page.

**"Entity not found"** — Use `entities` command to list valid entity IDs. Check domain prefix (e.g., `light.` vs `switch.`).

## Security Notes

- Tokens are read from environment variables only — never stored on disk by the script
- All API calls use HTTPS when your HA instance supports it
- Consider using a dedicated HA user with limited permissions for automation scripts
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
