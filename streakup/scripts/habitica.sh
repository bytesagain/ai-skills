#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Habitica-style habit tracker
set -euo pipefail
DATA="${HABIT_DIR:-$HOME/.habits}"
mkdir -p "$DATA"
DB="$DATA/habits.json"
[ ! -f "$DB" ] && echo '{"habits":[],"log":[]}' > "$DB"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Habit Tracker — build better habits
Commands:
  add <name> [freq]     Add habit (daily/weekly/custom)
  check <name>          Mark habit done today
  list                  List all habits with streaks
  streak <name>         Show streak for habit
  stats                 Overall statistics
  calendar <name>       Visual calendar view
  reset <name>          Reset streak
  remove <name>         Remove habit
  report [days]         Progress report
  info                  Version info
Powered by BytesAgain | bytesagain.com";;
add)
    name="${1:-}"; freq="${2:-daily}"
    [ -z "$name" ] && { echo "Usage: add <name> [daily|weekly]"; exit 1; }
    python3 << PYEOF
import json
with open("$DB") as f: data = json.load(f)
data["habits"].append({"name":"$name","freq":"$freq","created":"$(date +%Y-%m-%d)","streak":0})
with open("$DB","w") as f: json.dump(data, f, indent=2)
print("✅ Habit added: $name ($freq)")
PYEOF
;;
check)
    name="${1:-}"; [ -z "$name" ] && { echo "Usage: check <name>"; exit 1; }
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
today = time.strftime("%Y-%m-%d")
found = False
for h in data["habits"]:
    if h["name"] == "$name":
        h["streak"] = h.get("streak", 0) + 1
        h["last_check"] = today
        found = True
        data["log"].append({"habit":"$name","date":today,"action":"check"})
        print("✅ {} checked! Streak: {} days 🔥".format(h["name"], h["streak"]))
        break
if not found: print("❌ Habit '$name' not found")
with open("$DB","w") as f: json.dump(data, f, indent=2)
PYEOF
;;
list)
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
today = time.strftime("%Y-%m-%d")
print("📋 Habits:")
for h in data["habits"]:
    streak = h.get("streak", 0)
    last = h.get("last_check", "never")
    done = "✅" if last == today else "⬜"
    fire = "🔥" if streak >= 7 else ("💪" if streak >= 3 else "")
    print("  {} {:20s} Streak: {:>3d} {} {}".format(done, h["name"], streak, fire, h["freq"]))
if not data["habits"]: print("  (no habits yet — use 'add' to start)")
PYEOF
;;
streak)
    name="${1:-}"; [ -z "$name" ] && { echo "Usage: streak <name>"; exit 1; }
    python3 << PYEOF
import json
with open("$DB") as f: data = json.load(f)
for h in data["habits"]:
    if h["name"] == "$name":
        s = h.get("streak", 0)
        bar = "█" * min(s, 30) + "░" * max(0, 30-s)
        print("🔥 {} — {} day streak".format(h["name"], s))
        print("   [{}]".format(bar))
        break
else: print("Not found: $name")
PYEOF
;;
stats)
    python3 << PYEOF
import json
with open("$DB") as f: data = json.load(f)
habits = data["habits"]
logs = data["log"]
total = len(habits)
active = len([h for h in habits if h.get("streak",0) > 0])
max_streak = max([h.get("streak",0) for h in habits]) if habits else 0
best = [h["name"] for h in habits if h.get("streak",0) == max_streak][:1]
print("📊 Habit Stats:")
print("  Total habits: {}".format(total))
print("  Active streaks: {}".format(active))
print("  Best streak: {} ({})".format(max_streak, ", ".join(best) if best else "-"))
print("  Total check-ins: {}".format(len(logs)))
PYEOF
;;
calendar)
    name="${1:-}"; [ -z "$name" ] && { echo "Usage: calendar <name>"; exit 1; }
    python3 << PYEOF
import json
with open("$DB") as f: data = json.load(f)
checks = set(l["date"] for l in data["log"] if l["habit"] == "$name")
import time
print("📅 {} — Last 30 days:".format("$name"))
row = "  "
for i in range(29, -1, -1):
    t = time.time() - i * 86400
    d = time.strftime("%Y-%m-%d", time.localtime(t))
    row += "🟩" if d in checks else "⬜"
    if (30 - i) % 7 == 0: row += " "
print(row)
print("  🟩 = done  ⬜ = missed")
PYEOF
;;
reset)
    name="${1:-}"; [ -z "$name" ] && { echo "Usage: reset <name>"; exit 1; }
    python3 << PYEOF
import json
with open("$DB") as f: data = json.load(f)
for h in data["habits"]:
    if h["name"] == "$name": h["streak"] = 0; print("🔄 Reset: $name"); break
with open("$DB","w") as f: json.dump(data, f, indent=2)
PYEOF
;;
remove)
    name="${1:-}"; [ -z "$name" ] && { echo "Usage: remove <name>"; exit 1; }
    python3 << PYEOF
import json
with open("$DB") as f: data = json.load(f)
data["habits"] = [h for h in data["habits"] if h["name"] != "$name"]
with open("$DB","w") as f: json.dump(data, f, indent=2)
print("🗑 Removed: $name")
PYEOF
;;
report)
    days="${1:-7}"
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
cutoff = time.time() - int("$days") * 86400
cutoff_str = time.strftime("%Y-%m-%d", time.localtime(cutoff))
recent = [l for l in data["log"] if l["date"] >= cutoff_str]
print("📊 {}-Day Report:".format("$days"))
print("  Check-ins: {}".format(len(recent)))
from collections import Counter
by_habit = Counter(l["habit"] for l in recent)
for h, c in by_habit.most_common():
    pct = c * 100 // int("$days")
    bar = "█" * (pct // 5) + "░" * (20 - pct // 5)
    print("  {:15s} [{}] {}%".format(h, bar, pct))
PYEOF
;;
info) echo "Habit Tracker v1.0.0"; echo "Build better habits, one day at a time"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
