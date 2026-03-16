---
version: "2.0.0"
name: tesla-commander
description: "Command and monitor Tesla vehicles via the Fleet API. Check status, control climate/charging/locks, track location, and analyze trip history. Use when you need tesla commander capabilities. Triggers on: tesla commander."
author: BytesAgain
---

# Tesla Commander

## What Is This?

A command-line interface for Tesla vehicle owners. Query your car's status, control climate and charging, lock/enable doors, track location, and review trip history — all from a terminal or automation script.

Built on the **Tesla Fleet API** (the official successor to the Owner API).

## Before You Start

### Authentication

Tesla Fleet API uses OAuth 2.0. You need:

1. **Client ID & Secret** — Register an application at [developer.tesla.com]([configured-endpoint])
2. **Access Token** — Obtained via OAuth flow
3. **Vehicle ID** — Your car's API identifier

```bash
export TESLA_ACCESS_TOKEN="eyJ..."
export TESLA_VIN="5YJ3E1EA1NF000000"       # Optional: defaults to first vehicle
export TESLA_CLIENT_ID="your-client-id"      # For token refresh
export TESLA_CLIENT_SECRET="your-secret"     # For token refresh
```

### Token Management

The script includes built-in token refresh:

```bash
# Initial OAuth flow (opens browser for authorization)
bash scripts/tesla-cmd.sh auth login

# Refresh an expired token
bash scripts/tesla-cmd.sh auth refresh

# Check token validity
bash scripts/tesla-cmd.sh auth check
```

---

## Command Categories

### 1. Vehicle Status

Get a complete snapshot of your vehicle's current state.

```bash
# Full vehicle data dump
bash scripts/tesla-cmd.sh status

# Specific subsystems
bash scripts/tesla-cmd.sh status battery      # Battery level, range, charging state
bash scripts/tesla-cmd.sh status climate      # Interior/exterior temp, HVAC settings
bash scripts/tesla-cmd.sh status drive        # Speed, heading, GPS coordinates
bash scripts/tesla-cmd.sh status vehicle      # Doors, windows, trunk, frunk status

# Quick summary (one-line output for scripting)
bash scripts/tesla-cmd.sh summary
# Output: Model3 | 78% | 241mi | Parked | 72°F | Home | Locked
```

### 2. Location & Tracking

```bash
# Current location with address
bash scripts/tesla-cmd.sh location

# Open location in default map application
bash scripts/tesla-cmd.sh location --map

# Track location updates (poll every N seconds)
bash scripts/tesla-cmd.sh track 30

# Distance from a specific address
bash scripts/tesla-cmd.sh distance "123 Main St, City, State"
```

### 3. Climate Control

```bash
# Start/stop HVAC
bash scripts/tesla-cmd.sh climate on
bash scripts/tesla-cmd.sh climate off

# Set temperature (°F or °C)
bash scripts/tesla-cmd.sh climate temp 72        # Fahrenheit
bash scripts/tesla-cmd.sh climate temp 22 --celsius

# Seat heaters (0=off, 1=low, 2=med, 3=high)
bash scripts/tesla-cmd.sh climate seat driver 2
bash scripts/tesla-cmd.sh climate seat passenger 1
bash scripts/tesla-cmd.sh climate seat rear-left 3

# Steering wheel heater
bash scripts/tesla-cmd.sh climate wheel on

# Defrost mode
bash scripts/tesla-cmd.sh climate defrost on

# Dog mode / Camp mode
bash scripts/tesla-cmd.sh climate dog on
bash scripts/tesla-cmd.sh climate camp on
```

### 4. Charging

```bash
# Charging status
bash scripts/tesla-cmd.sh charge status

# Start/stop charging
bash scripts/tesla-cmd.sh charge start
bash scripts/tesla-cmd.sh charge stop

# Set charge limit (percent)
bash scripts/tesla-cmd.sh charge limit 80

# Open/close charge port
bash scripts/tesla-cmd.sh charge port open
bash scripts/tesla-cmd.sh charge port close

# Scheduled charging
bash scripts/tesla-cmd.sh charge schedule 23:00   # Start at 11 PM
bash scripts/tesla-cmd.sh charge schedule off      # Disable schedule
```

### 5. Security & Access

```bash
# Lock/enable
bash scripts/tesla-cmd.sh lock
bash scripts/tesla-cmd.sh enable

# Trunk / Frunk
bash scripts/tesla-cmd.sh trunk open
bash scripts/tesla-cmd.sh frunk open

# Flash lights / honk horn
bash scripts/tesla-cmd.sh flash
bash scripts/tesla-cmd.sh honk

# Sentry mode
bash scripts/tesla-cmd.sh sentry on
bash scripts/tesla-cmd.sh sentry off

# Valet mode
bash scripts/tesla-cmd.sh valet on 1234    # PIN required
bash scripts/tesla-cmd.sh valet off 1234

# Speed limit
bash scripts/tesla-cmd.sh speedlimit set 65 1234
bash scripts/tesla-cmd.sh speedlimit clear 1234
```

### 6. Trip History & Analytics

```bash
# Recent trips (last N days)
bash scripts/tesla-cmd.sh trips 7

# Trip summary with efficiency stats
bash scripts/tesla-cmd.sh trips summary --month

# Charging history
bash scripts/tesla-cmd.sh trips charges 30

# Export trip data as CSV
bash scripts/tesla-cmd.sh trips export trips_march.csv

# Efficiency report
bash scripts/tesla-cmd.sh efficiency
```

---

## Automation Examples

**Morning pre-conditioning (cron):**
```bash
# At 7:30 AM on weekdays, warm up the car
30 7 * * 1-5 bash /path/to/tesla-cmd.sh climate on && bash /path/to/tesla-cmd.sh climate temp 72
```

**Low battery alert:**
```bash
BATTERY=$(bash scripts/tesla-cmd.sh status battery --raw)
if [ "$BATTERY" -lt 20 ]; then
  echo "Tesla battery at ${BATTERY}%!" | mail -s "Low Battery" you@email.com
fi
```

**Geo-fence check:**
```bash
bash scripts/tesla-cmd.sh location --raw | python3 -c "
import sys, json
data = json.load(sys.stdin)
lat, lon = data['latitude'], data['longitude']
# Check if within home radius
HOME_LAT, HOME_LON = 37.7749, -122.4194
dist = ((lat - HOME_LAT)**2 + (lon - HOME_LON)**2) ** 0.5
if dist > 0.01:
    print('Vehicle is away from home')
"
```

---

## Rate Limits & Considerations

- Tesla Fleet API enforces rate limits — the script includes automatic backoff
- Vehicle must be "awake" for most commands; the script handles wake-up automatically
- Wake-up can take 10-30 seconds; use `--nowait` to skip waiting
- Frequent polling drains the 12V battery; keep polling intervals above 5 minutes for parked vehicles

## Privacy & Security

- Access tokens are stored in `~/.tesla-commander/` with 600 permissions
- All communication uses TLS 1.2+
- The script never logs your token to stdout
- Consider using a separate Tesla account with limited vehicle access for shared scripts
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

Run `tesla-commander help` to see all available commands.
