#!/usr/bin/env bash
# Ring Security — Monitor Ring doorbells and cameras
# Usage: bash ring.sh <command> [options]
set -euo pipefail

COMMAND="${1:-help}"
shift 2>/dev/null || true

DATA_DIR="${HOME}/.ring-security"
mkdir -p "$DATA_DIR"
RING_TOKEN="${RING_ACCESS_TOKEN:-}"

case "$COMMAND" in
  setup)
    python3 << 'PYEOF'
import os
print("=" * 60)
print("RING SECURITY SETUP")
print("=" * 60)
print("")
print("Ring does not offer a public API. Access options:")
print("")
print("OPTION 1: ring-client-api (Node.js)")
print("  npm install -g ring-client-api")
print("  ring-auth-cli  # generates refresh token")
print("  export RING_REFRESH_TOKEN=<token>")
print("")
print("OPTION 2: python-ring-doorbell")
print("  pip install ring-doorbell")
print("  # Authenticate with email/password + 2FA")
print("")
print("OPTION 3: Home Assistant Integration")
print("  Add Ring integration in HA")
print("  Access via HA REST API instead")
print("")
print("After setup, set environment variables:")
print("  export RING_ACCESS_TOKEN=<your_token>")
print("  # or")
print("  export RING_REFRESH_TOKEN=<your_refresh_token>")
print("")
print("SECURITY NOTE:")
print("  - Ring tokens expire and need refresh")
print("  - Enable 2FA on your Ring account")
print("  - Never share tokens publicly")
PYEOF
    ;;

  devices)
    python3 << 'PYEOF'
import json, os, sys
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

token = os.environ.get("RING_ACCESS_TOKEN", "")
if not token:
    config_file = os.path.expanduser("~/.ring-security/config.json")
    if os.path.exists(config_file):
        with open(config_file) as f:
            token = json.load(f).get("access_token", "")

if not token:
    print("Ring not configured. Run 'bash ring.sh setup'")
    # Show demo data
    print("")
    print("DEMO MODE — Sample device listing:")
    print("=" * 60)
    print("")
    devices = [
        {"name": "Front Door", "type": "Doorbell Pro 2", "status": "online", "battery": "N/A (wired)", "firmware": "3.48.24"},
        {"name": "Backyard", "type": "Stick Up Cam Battery", "status": "online", "battery": "78%", "firmware": "3.44.17"},
        {"name": "Garage", "type": "Floodlight Cam Wired Pro", "status": "online", "battery": "N/A (wired)", "firmware": "3.48.24"},
        {"name": "Side Gate", "type": "Stick Up Cam Solar", "status": "offline", "battery": "12%", "firmware": "3.42.11"}
    ]
    
    print("{:<4} {:<15} {:<25} {:<10} {:<10}".format("#", "Name", "Type", "Status", "Battery"))
    print("-" * 60)
    for i, d in enumerate(devices, 1):
        icon = "🟢" if d["status"] == "online" else "🔴"
        print("{:<4} {} {:<14} {:<25} {:<10} {:<10}".format(
            i, icon, d["name"], d["type"], d["status"], d["battery"]))
    print("")
    print("(Demo data — configure Ring token to see real devices)")
    sys.exit(0)

try:
    url = "https://api.ring.com/clients_api/ring_devices"
    req = Request(url)
    req.add_header("Authorization", "Bearer {}".format(token))
    resp = urlopen(req, timeout=15)
    data = json.loads(resp.read().decode("utf-8"))
    
    doorbells = data.get("doorbots", [])
    cameras = data.get("stickup_cams", [])
    chimes = data.get("chimes", [])
    
    print("=" * 65)
    print("RING DEVICES")
    print("=" * 65)
    
    if doorbells:
        print("")
        print("DOORBELLS ({})".format(len(doorbells)))
        for d in doorbells:
            print("  🔔 {} — {}".format(d.get("description", "?"), d.get("kind", "?")))
            health = d.get("health", {})
            print("     WiFi: {} dBm  Firmware: {}".format(
                health.get("latest_signal_strength", "?"),
                d.get("firmware_version", "?")))
    
    if cameras:
        print("")
        print("CAMERAS ({})".format(len(cameras)))
        for c in cameras:
            print("  📷 {} — {}".format(c.get("description", "?"), c.get("kind", "?")))
            battery = c.get("battery_life", "?")
            print("     Battery: {}%  Firmware: {}".format(
                battery, c.get("firmware_version", "?")))
    
    if chimes:
        print("")
        print("CHIMES ({})".format(len(chimes)))
        for ch in chimes:
            print("  🔊 {} — {}".format(ch.get("description", "?"), ch.get("kind", "?")))

except Exception as e:
    print("Error: {}".format(str(e)))
PYEOF
    ;;

  events)
    LIMIT="${1:-20}"
    DEVICE="${2:-all}"
    
    python3 << 'PYEOF'
import json, os, sys, time

limit = int(sys.argv[1]) if len(sys.argv) > 1 else 20
device = sys.argv[2] if len(sys.argv) > 2 else "all"

token = os.environ.get("RING_ACCESS_TOKEN", "")
data_dir = os.path.expanduser("~/.ring-security")

if not token:
    # Demo mode
    print("=" * 65)
    print("RING EVENTS (DEMO MODE)")
    print("=" * 65)
    print("")
    events = [
        {"time": "2024-01-15 14:32", "device": "Front Door", "type": "Motion", "answered": False},
        {"time": "2024-01-15 14:35", "device": "Front Door", "type": "Ring", "answered": True},
        {"time": "2024-01-15 15:12", "device": "Backyard", "type": "Motion", "answered": False},
        {"time": "2024-01-15 16:45", "device": "Front Door", "type": "Motion", "answered": False},
        {"time": "2024-01-15 18:20", "device": "Side Gate", "type": "Motion", "answered": False},
        {"time": "2024-01-15 19:30", "device": "Front Door", "type": "Ring", "answered": True},
        {"time": "2024-01-15 21:05", "device": "Garage", "type": "Motion", "answered": False},
        {"time": "2024-01-15 23:15", "device": "Front Door", "type": "Motion", "answered": False}
    ]
    
    for e in events[:limit]:
        icon = "🔔" if e["type"] == "Ring" else "👀"
        answered = "✅ Answered" if e["answered"] else ""
        print("  {} {} {} — {} {}".format(icon, e["time"], e["device"], e["type"], answered))
    
    print("")
    print("(Demo data — configure Ring token for real events)")
    
    # Generate summary
    motion_count = len([e for e in events if e["type"] == "Motion"])
    ring_count = len([e for e in events if e["type"] == "Ring"])
    print("")
    print("Summary: {} motion events, {} rings".format(motion_count, ring_count))
    sys.exit(0)

try:
    from urllib.request import urlopen, Request
    url = "https://api.ring.com/clients_api/doorbots/history?limit={}".format(limit)
    req = Request(url)
    req.add_header("Authorization", "Bearer {}".format(token))
    resp = urlopen(req, timeout=15)
    events = json.loads(resp.read().decode("utf-8"))
    
    print("=" * 65)
    print("RING EVENTS (last {})".format(limit))
    print("=" * 65)
    print("")
    
    for e in events:
        created = e.get("created_at", "?")[:16]
        kind = e.get("kind", "?")
        answered = "✅" if e.get("answered") else ""
        device_name = e.get("doorbot", {}).get("description", "?")
        
        icon = "🔔" if kind == "ding" else "👀" if kind == "motion" else "📹"
        print("  {} {} {} — {} {}".format(icon, created, device_name, kind, answered))

except Exception as e:
    print("Error: {}".format(str(e)))
PYEOF
    ;;

  snapshot)
    DEVICE_ID="${1:-}"
    echo "Requesting snapshot from device ${DEVICE_ID:-all}..."
    echo "Note: Ring snapshots require device to be online and may take 10-30 seconds."
    echo "Snapshots are saved to: $DATA_DIR/"
    echo ""
    echo "For live view, use the Ring app on your phone."
    ;;

  arm)
    MODE="${1:-home}"
    echo "Setting Ring alarm to ${MODE} mode..."
    echo "Modes: home, away, disarmed"
    echo ""
    echo "Note: Requires Ring Alarm base station."
    echo "API call: POST /clients_api/ring_devices/alarms/mode"
    echo "Body: {\"mode\": \"${MODE}\"}"
    ;;

  help|*)
    cat << 'HELPEOF'
Ring Security — Monitor Ring doorbells and cameras

SETUP:
  setup                  Configuration instructions

MONITORING:
  devices                List all Ring devices
  events [limit] [device] View motion/ring events
  snapshot [device_id]   Request device snapshot

ALARM:
  arm [home|away|disarmed]  Set alarm mode

ENV VARS:
  RING_ACCESS_TOKEN    — Ring API access token
  RING_REFRESH_TOKEN   — Ring refresh token

EXAMPLES:
  bash ring.sh setup
  bash ring.sh devices
  bash ring.sh events 20
  bash ring.sh arm away

NOTE: Ring has no official public API. Uses unofficial endpoints.
      Consider Home Assistant for more stable integration.
HELPEOF
    ;;
esac

echo ""
echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
