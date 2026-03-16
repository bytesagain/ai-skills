---
version: "2.0.0"
name: ring-security
description: "Monitor and manage Ring doorbells and security cameras. Query device status, review motion events, manage modes, and export event history. Use when you need ring security capabilities. Triggers on: ring security."
author: BytesAgain
---

# Ring Security

Your Ring doorbell and camera system, accessible from the command line.

## Overview

This skill connects to Ring's cloud API to give you visibility into your home security system. Check doorbell and camera status, review motion detection events, manage security modes, and pull historical event data for analysis.

> **Note:** Ring does not offer an official public API. This tool uses the same endpoints as the Ring mobile app. Functionality may change if Ring updates their API.

## Getting Started

### Credentials

Ring uses email + password authentication with 2FA support:

```bash
export RING_EMAIL="you@example.com"
export RING_PASSWORD="your-password"
```

On first run, you'll be prompted for your 2FA code. The script caches the refresh token locally at `~/.ring-security/token.json`.

### First Connection

```bash
bash scripts/ring-security.sh auth login
# Enter 2FA code when prompted
# Token cached for future use

bash scripts/ring-security.sh auth check
# Verify token is valid
```

---

## Feature Walkthrough

### Device Discovery

When you first connect, the script maps all Ring devices on your account:

```bash
$ bash scripts/ring-security.sh devices

Ring Devices Found:
┌──────────────────────┬─────────────────┬──────────┬─────────┐
│ Name                 │ Type            │ Battery  │ Status  │
├──────────────────────┼─────────────────┼──────────┼─────────┤
│ Front Door           │ Doorbell Pro 2  │ N/A      │ Online  │
│ Backyard             │ Spotlight Cam   │ 87%      │ Online  │
│ Garage               │ Stick Up Cam    │ 45%      │ Online  │
│ Side Gate            │ Floodlight Cam  │ N/A      │ Offline │
└──────────────────────┴─────────────────┴──────────┴─────────┘
```

### Live Status

```bash
# All devices at a glance
bash scripts/ring-security.sh status

# Specific device details
bash scripts/ring-security.sh status "Front Door"

# Battery levels across all devices
bash scripts/ring-security.sh battery

# Wi-Fi signal strength
bash scripts/ring-security.sh signal
```

### Motion & Ring Events

This is the core of Ring monitoring — reviewing what happened and when.

```bash
# Recent events (last 20)
bash scripts/ring-security.sh events

# Events for a specific device
bash scripts/ring-security.sh events "Front Door" --limit 50

# Events in a time range
bash scripts/ring-security.sh events --from "2024-01-15 08:00" --to "2024-01-15 18:00"

# Motion events only
bash scripts/ring-security.sh events --type motion

# Ding (doorbell press) events only
bash scripts/ring-security.sh events --type ding

# Event details with snapshot URL
bash scripts/ring-security.sh event <event_id>
```

### Security Modes

Control your Ring alarm system modes (requires Ring Alarm):

```bash
# Current mode
bash scripts/ring-security.sh mode

# Set mode
bash scripts/ring-security.sh mode home
bash scripts/ring-security.sh mode away
bash scripts/ring-security.sh mode disarmed

# Mode history
bash scripts/ring-security.sh mode history
```

### Light Control

For Ring devices with built-in lights (Floodlight Cam, Spotlight Cam):

```bash
# Toggle lights
bash scripts/ring-security.sh light on "Backyard"
bash scripts/ring-security.sh light off "Backyard"

# Siren
bash scripts/ring-security.sh siren on "Backyard"
bash scripts/ring-security.sh siren off "Backyard"
```

### Event Export & Analysis

```bash
# Export events as CSV
bash scripts/ring-security.sh export csv events_jan.csv --days 30

# Export as JSON
bash scripts/ring-security.sh export json events_jan.json --days 30

# Activity summary (events per device per day)
bash scripts/ring-security.sh analytics --days 7

# Peak activity hours
bash scripts/ring-security.sh analytics hourly --days 30
```

## Example Output: Analytics

```
Activity Summary (Last 7 Days):
────────────────────────────────
Front Door:    ████████████████████ 47 events
Backyard:      █████████████ 31 events
Garage:        ██████ 14 events

Peak Hours:
  08:00-09:00  ████████ 18 events (morning deliveries)
  17:00-18:00  ██████████ 23 events (arrivals home)
  22:00-23:00  ████ 9 events (wildlife/wind)

Most Active Day: Tuesday (avg 15.2 events)
Quietest Day:   Sunday (avg 4.8 events)
```

## Automation Ideas

**Daily security digest email:**
```bash
0 8 * * * bash /path/to/ring-security.sh analytics --days 1 | mail -s "Ring Daily Digest" you@email.com
```

**Low battery alert:**
```bash
bash scripts/ring-security.sh battery --below 20
# Outputs only devices below 20%, exit code 1 if any found
```

**Motion spike detection:**
```bash
# Alert if more than 20 events in the last hour
COUNT=$(bash scripts/ring-security.sh events --hours 1 --count)
if [ "$COUNT" -gt 20 ]; then
  echo "Unusual activity: $COUNT events in the last hour"
fi
```

## Caveats

- Ring API is unofficial — updates to the Ring app may temporarily break functionality
- 2FA is required for new logins; the cached token typically lasts 2-4 weeks
- Video downloads require a Ring Protect subscription
- API rate limits are not publicly documented; the script includes conservative delays
- Snapshot URLs expire after a few minutes — download them promptly
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

Run `ring-security help` to see all available commands.
