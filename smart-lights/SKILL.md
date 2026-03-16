---
version: "2.0.0"
name: smart-lights
description: "Control Philips Hue lights, rooms, zones, and scenes through the Hue Bridge API. Supports color effects, scheduling, and dynamic light shows. Use when you need philips hue capabilities. Triggers on: philips hue."
---

# Philips Hue Controller

Control your Philips Hue lighting system directly from the terminal. Set colors, create dynamic effects, manage schedules, and orchestrate multi-room scenes — all without the Hue app.

## Setup

### Step 1: Find Your Bridge

The script can auto-discover your Hue Bridge on the local network via mDNS/UPnP:

```bash
bash scripts/hue-control.sh discover
```

Or set it manually:

```bash
export HUE_BRIDGE_IP="192.168.1.50"
```

### Step 2: Authenticate

Press the physical button on your Hue Bridge, then within 30 seconds run:

```bash
bash scripts/hue-control.sh register
```

This creates an API username and saves it. Or set it directly:

```bash
export HUE_API_USER="your-api-username-here"
```

### Step 3: Verify

```bash
bash scripts/hue-control.sh info
```

You should see your bridge model, API version, and connected light count.

---

## Usage Guide

### Listing Resources

```bash
# All lights with current state
bash scripts/hue-control.sh lights

# All rooms/groups
bash scripts/hue-control.sh rooms

# All scenes
bash scripts/hue-control.sh scenes

# All schedules
bash scripts/hue-control.sh schedules
```

### Controlling Individual Lights

```bash
# Turn light on/off (by ID or name)
bash scripts/hue-control.sh on 1
bash scripts/hue-control.sh off "Desk Lamp"

# Set brightness (0-254)
bash scripts/hue-control.sh brightness 1 200

# Set color by name, hex, or temperature
bash scripts/hue-control.sh color 1 red
bash scripts/hue-control.sh color 1 "#FF6B35"
bash scripts/hue-control.sh color 1 warm       # 2700K
bash scripts/hue-control.sh color 1 cool       # 6500K

# Set color temperature in Kelvin
bash scripts/hue-control.sh temp 1 3500
```

### Room/Group Control

```bash
# Control entire room
bash scripts/hue-control.sh room on "Living Room"
bash scripts/hue-control.sh room brightness "Bedroom" 100
bash scripts/hue-control.sh room color "Office" blue
```

### Scene Activation

```bash
# Activate a scene in a group
bash scripts/hue-control.sh scene "Relax" "Living Room"

# List scenes for a specific room
bash scripts/hue-control.sh scenes "Bedroom"
```

### Dynamic Effects

```bash
# Color loop — cycles through all hues
bash scripts/hue-control.sh effect colorloop 1

# Breathe — single slow fade in/out
bash scripts/hue-control.sh effect breathe 1

# Alert — flash the light
bash scripts/hue-control.sh alert 1

# Candle flicker simulation
bash scripts/hue-control.sh effect candle 1 30    # 30 seconds

# Sunrise simulation over N minutes
bash scripts/hue-control.sh sunrise "Bedroom" 20  # 20-minute sunrise

# Party mode — random colors across all lights
bash scripts/hue-control.sh party "Living Room" 60 # 60 seconds
```

### Scheduling

```bash
# Create a schedule
bash scripts/hue-control.sh schedule create "Bedtime" "22:30" off "Bedroom"
bash scripts/hue-control.sh schedule create "Morning" "07:00" on "Kitchen" --brightness 200

# Delete a schedule
bash scripts/hue-control.sh schedule delete 1

# List active schedules
bash scripts/hue-control.sh schedules
```

---

## Color Reference

The script supports multiple color input formats:

| Format | Example | Notes |
|--------|---------|-------|
| Named colors | `red`, `blue`, `green`, `purple`, `orange`, `pink`, `cyan`, `white` | 12 built-in presets |
| Hex codes | `#FF6B35`, `#00FF00` | Standard web hex |
| Temperature names | `warm`, `neutral`, `cool`, `daylight` | Mapped to Kelvin values |
| Kelvin values | `2700`, `4000`, `6500` | Via `temp` command |
| Hue + Saturation | `hue:25000 sat:200` | Raw Hue API values |

---

## Practical Recipes

**Movie night setup:**
```bash
bash scripts/hue-control.sh room brightness "Living Room" 30
bash scripts/hue-control.sh color 3 "#1a0a2e"
bash scripts/hue-control.sh room off "Kitchen"
```

**Gentle wake-up alarm:**
```bash
bash scripts/hue-control.sh schedule create "WakeUp" "06:45" sunrise "Bedroom" --duration 15
```

**Working hours indicator:**
```bash
# Green = available, Red = in meeting
bash scripts/hue-control.sh color "Status Light" green
```

---

## Limitations

- Hue Bridge supports max 100 API calls per second — the script includes built-in rate limiting
- Entertainment API (sync with music/video) requires the Hue Sync app and is not covered here
- Maximum 50 lights per bridge; for larger setups, multiple bridges are needed
- Schedules are stored on the bridge (max 100) — check capacity with `schedules` command
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
