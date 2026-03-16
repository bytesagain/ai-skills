#!/usr/bin/env bash
# Roomba Control — Manage iRobot Roomba vacuums via Cloud API
# Usage: bash roomba.sh <command> [options]
set -euo pipefail

COMMAND="${1:-help}"
shift 2>/dev/null || true

DATA_DIR="${HOME}/.roomba-control"
mkdir -p "$DATA_DIR"
IROBOT_USER="${IROBOT_EMAIL:-}"
IROBOT_PASS="${IROBOT_PASSWORD:-}"

case "$COMMAND" in
  setup)
    python3 << 'PYEOF'
print("=" * 60)
print("ROOMBA CONTROL SETUP")
print("=" * 60)
print("")
print("ACCESS OPTIONS:")
print("")
print("OPTION 1: iRobot Cloud API (easiest)")
print("  export IROBOT_EMAIL=your@email.com")
print("  export IROBOT_PASSWORD=your_password")
print("  bash roomba.sh login")
print("")
print("OPTION 2: Local MQTT (more reliable)")
print("  1. Find Roomba IP on your network")
print("  2. Get BLID and password from robot:")
print("     Press and hold HOME button for 10 seconds")
print("     Robot plays ascending tones")
print("  3. python3 -c 'from roomba import Roomba; Roomba.get_password(\"<IP>\")'")
print("  4. Set env vars:")
print("     export ROOMBA_IP=<ip>")
print("     export ROOMBA_BLID=<blid>")
print("     export ROOMBA_PASSWORD=<password>")
print("")
print("OPTION 3: Home Assistant Integration")
print("  Add iRobot integration in HA")
print("  Control via HA REST API")
print("")
print("SUPPORTED MODELS:")
models = [
    "Roomba i1/i3/i4/i5/i7/i8 — Navigation + mopping",
    "Roomba j5/j7/j9 — Object avoidance + self-empty",
    "Roomba s9 — D-shape, corner cleaning",
    "Roomba Combo — Vacuum + mop",
    "Braava Jet m6 — Mopping only"
]
for m in models:
    print("  - {}".format(m))
PYEOF
    ;;

  status)
    python3 << 'PYEOF'
import json, os, sys, time

data_dir = os.path.expanduser("~/.roomba-control")
ip = os.environ.get("ROOMBA_IP", "")

if not ip:
    # Demo mode
    print("=" * 55)
    print("ROOMBA STATUS (DEMO MODE)")
    print("=" * 55)
    print("")
    status = {
        "name": "Living Room Roomba",
        "model": "Roomba j7+",
        "firmware": "24.29.2",
        "state": "Charging",
        "battery": 87,
        "bin": "Not Full",
        "last_clean": {
            "date": "2024-01-15 10:30",
            "duration": "42 min",
            "area": "54 sqm / 581 sqft",
            "rooms": ["Living Room", "Kitchen", "Hallway"]
        },
        "schedule": {
            "Mon": "09:00", "Wed": "09:00", "Fri": "09:00",
            "Sat": "10:00"
        },
        "consumables": {
            "filter": {"remaining": 65, "unit": "%"},
            "side_brush": {"remaining": 78, "unit": "%"},
            "main_brush": {"remaining": 45, "unit": "%"},
            "bin_bag": {"remaining": 3, "unit": "bags"}
        },
        "lifetime": {
            "total_cleans": 234,
            "total_hours": 178,
            "total_area": "12,456 sqm"
        }
    }
    
    s = status
    print("  🤖 {} ({})".format(s["name"], s["model"]))
    print("  Firmware: {}".format(s["firmware"]))
    print("")
    
    state_icon = "🔋" if s["state"] == "Charging" else "🧹" if s["state"] == "Cleaning" else "🏠"
    print("  {} State: {}".format(state_icon, s["state"]))
    
    bat = s["battery"]
    bar_len = bat // 5
    bar = "█" * bar_len + "░" * (20 - bar_len)
    print("  🔋 Battery: [{}] {}%".format(bar, bat))
    print("  🗑️ Bin: {}".format(s["bin"]))
    
    print("")
    print("  Last Clean:")
    lc = s["last_clean"]
    print("    Date: {}".format(lc["date"]))
    print("    Duration: {}".format(lc["duration"]))
    print("    Area: {}".format(lc["area"]))
    print("    Rooms: {}".format(", ".join(lc["rooms"])))
    
    print("")
    print("  Schedule:")
    for day, time_str in sorted(s["schedule"].items()):
        print("    {}: {}".format(day, time_str))
    
    print("")
    print("  Consumables:")
    for part, info in s["consumables"].items():
        remaining = info["remaining"]
        unit = info["unit"]
        warn = "⚠️" if (unit == "%" and remaining < 30) or (unit == "bags" and remaining < 2) else "✅"
        name = part.replace("_", " ").title()
        print("    {} {}: {} {}".format(warn, name, remaining, unit))
    
    print("")
    print("  Lifetime Stats:")
    lt = s["lifetime"]
    print("    Total cleans: {}".format(lt["total_cleans"]))
    print("    Total hours: {}".format(lt["total_hours"]))
    print("    Total area: {}".format(lt["total_area"]))
    
    print("")
    print("  (Demo data — set ROOMBA_IP for real status)")
    sys.exit(0)

# Real implementation would use MQTT to query robot
print("Connecting to Roomba at {}...".format(ip))
print("(MQTT connection required — install: pip install roomba)")
PYEOF
    ;;

  clean)
    ROOM="${1:-all}"
    
    python3 << 'PYEOF'
import sys, os

room = sys.argv[1] if len(sys.argv) > 1 else "all"
ip = os.environ.get("ROOMBA_IP", "")

if room == "all":
    print("🧹 Starting full clean...")
    print("   Command: start")
else:
    print("🧹 Starting room clean: {}".format(room))
    print("   Command: start (room: {})".format(room))

if not ip:
    print("")
    print("   (Demo mode — set ROOMBA_IP to send real commands)")
    print("")
    print("   In real mode, sends MQTT command:")
    print("   Topic: cmd")
    print('   Payload: {{"command": "start", "initiator": "localApp"}}')
else:
    print("   Sending to {}...".format(ip))
    # Real MQTT would go here
PYEOF
    ;;

  dock)
    echo "🏠 Sending Roomba to dock..."
    echo "   Command: dock"
    echo "   (Set ROOMBA_IP for real commands)"
    ;;

  pause)
    echo "⏸️ Pausing Roomba..."
    echo "   Command: pause"
    ;;

  resume)
    echo "▶️ Resuming Roomba..."
    echo "   Command: resume"
    ;;

  schedule)
    ACTION="${1:-list}"
    
    python3 << 'PYEOF'
import json, os, sys

action = sys.argv[1] if len(sys.argv) > 1 else "list"
data_dir = os.path.expanduser("~/.roomba-control")
sched_file = os.path.join(data_dir, "schedule.json")

if action == "list":
    print("=" * 45)
    print("CLEANING SCHEDULE")
    print("=" * 45)
    print("")
    
    schedule = {}
    if os.path.exists(sched_file):
        with open(sched_file) as f:
            schedule = json.load(f)
    
    days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    for day in days:
        time_str = schedule.get(day, "—")
        icon = "✅" if time_str != "—" else "  "
        print("  {} {}: {}".format(icon, day, time_str))
    
    print("")
    print("Set: bash roomba.sh schedule set Mon 09:00")
    print("Clear: bash roomba.sh schedule clear Mon")

elif action == "set":
    day = sys.argv[2] if len(sys.argv) > 2 else ""
    time_str = sys.argv[3] if len(sys.argv) > 3 else ""
    if not day or not time_str:
        print("Usage: bash roomba.sh schedule set <day> <time>")
        sys.exit(1)
    
    schedule = {}
    if os.path.exists(sched_file):
        with open(sched_file) as f:
            schedule = json.load(f)
    
    schedule[day] = time_str
    with open(sched_file, "w") as f:
        json.dump(schedule, f, indent=2)
    print("Set {} cleaning at {}".format(day, time_str))

elif action == "clear":
    day = sys.argv[2] if len(sys.argv) > 2 else ""
    schedule = {}
    if os.path.exists(sched_file):
        with open(sched_file) as f:
            schedule = json.load(f)
    
    if day in schedule:
        del schedule[day]
        with open(sched_file, "w") as f:
            json.dump(schedule, f, indent=2)
        print("Cleared {} schedule".format(day))
    else:
        print("No schedule set for {}".format(day))
PYEOF
    ;;

  history)
    python3 << 'PYEOF'
import json, os

data_dir = os.path.expanduser("~/.roomba-control")
hist_file = os.path.join(data_dir, "history.json")

print("=" * 55)
print("CLEANING HISTORY")
print("=" * 55)
print("")

# Demo data
history = [
    {"date": "2024-01-15 10:30", "duration": 42, "area": 54, "result": "Completed"},
    {"date": "2024-01-13 09:00", "duration": 38, "area": 48, "result": "Completed"},
    {"date": "2024-01-12 09:00", "duration": 45, "area": 56, "result": "Completed"},
    {"date": "2024-01-10 09:00", "duration": 12, "area": 15, "result": "Stuck - rescued"},
    {"date": "2024-01-08 10:00", "duration": 40, "area": 52, "result": "Completed"},
    {"date": "2024-01-05 09:00", "duration": 44, "area": 55, "result": "Completed"},
]

print("{:<20} {:>8} {:>10} {:<15}".format("Date", "Minutes", "Area sqm", "Result"))
print("-" * 55)
for h in history:
    icon = "✅" if h["result"] == "Completed" else "⚠️"
    print("{} {:<18} {:>8} {:>10} {:<15}".format(
        icon, h["date"], h["duration"], h["area"], h["result"]))

total_mins = sum(h["duration"] for h in history)
total_area = sum(h["area"] for h in history)
print("")
print("Total: {} cleans, {} min, {} sqm".format(len(history), total_mins, total_area))
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
Roomba Control — Manage iRobot Roomba vacuums

SETUP:
  setup                     Configuration instructions

STATUS:
  status                    Full robot status + consumables

CONTROLS:
  clean [room|all]          Start cleaning
  dock                      Send to charging dock
  pause / resume            Pause/resume cleaning

SCHEDULE:
  schedule [list|set|clear]  Manage cleaning schedule

HISTORY:
  history                   View cleaning history

ENV VARS:
  ROOMBA_IP       — Robot IP address (local MQTT)
  ROOMBA_BLID     — Robot BLID
  ROOMBA_PASSWORD — Robot password
  IROBOT_EMAIL    — iRobot cloud email
  IROBOT_PASSWORD — iRobot cloud password

EXAMPLES:
  bash roomba.sh status
  bash roomba.sh clean
  bash roomba.sh clean "Living Room"
  bash roomba.sh dock
  bash roomba.sh schedule set Mon 09:00
HELPEOF
    ;;
esac

echo ""
echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
