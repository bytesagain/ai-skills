#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# License: MIT — independent, not derived from any third-party source
# Water reminder — track daily water intake
set -euo pipefail
WATER_DIR="${WATER_DIR:-$HOME/.water}"
mkdir -p "$WATER_DIR"
DB="$WATER_DIR/intake.json"
[ ! -f "$DB" ] && echo '[]' > "$DB"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Water Reminder — track daily hydration
Commands:
  drink [ml]          Log water (default 250ml)
  cup                 Quick log one cup (250ml)
  bottle              Quick log one bottle (500ml)
  today               Today's intake
  goal [ml]           Set daily goal (default 2000ml)
  check               Check if on track
  week                Weekly summary
  history [n]         Intake history (default 7)
  stats               Hydration statistics
  remind              Hydration tips
  info                Version info
Powered by BytesAgain | bytesagain.com";;
drink)
    ml="${1:-250}"
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
data.append({"ml":int("$ml"),"date":time.strftime("%Y-%m-%d"),"time":time.strftime("%H:%M")})
with open("$DB","w") as f: json.dump(data, f, indent=2)
today_total = sum(d["ml"] for d in data if d["date"] == time.strftime("%Y-%m-%d"))
goal = 2000
pct = today_total * 100 // goal
bar = "💧" * (pct // 10) + "⬜" * max(0, 10 - pct // 10)
print("💧 +{}ml (total today: {}ml)".format("$ml", today_total))
print("   [{}] {}%".format(bar, min(pct, 100)))
if today_total >= goal: print("   🎉 Daily goal reached!")
PYEOF
;;
cup) bash "$0" drink 250;;
bottle) bash "$0" drink 500;;
today)
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
today = time.strftime("%Y-%m-%d")
todays = [d for d in data if d["date"] == today]
total = sum(d["ml"] for d in todays)
goal = 2000
pct = total * 100 // goal
bar = "💧" * (pct // 10) + "⬜" * max(0, 10 - pct // 10)
print("💧 Today's Intake: {}ml / {}ml".format(total, goal))
print("   [{}] {}%".format(bar, min(pct, 100)))
for d in todays:
    print("   {} +{}ml".format(d["time"], d["ml"]))
remaining = max(0, goal - total)
if remaining > 0:
    cups = remaining // 250
    print("   Need {} more cups to reach goal".format(cups))
else: print("   🎉 Goal reached!")
PYEOF
;;
goal)
    ml="${1:-2000}"
    echo "$ml" > "$WATER_DIR/goal.txt"
    echo "🎯 Daily goal set: ${ml}ml";;
check)
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
today = time.strftime("%Y-%m-%d")
total = sum(d["ml"] for d in data if d["date"] == today)
hour = int(time.strftime("%H"))
try:
    with open("$WATER_DIR/goal.txt") as f: goal = int(f.read().strip())
except: goal = 2000
if hour > 0:
    expected = goal * hour // 16  # assume 16 waking hours
    if total >= expected:
        print("✅ On track! {}ml / {}ml expected by now".format(total, expected))
    else:
        behind = expected - total
        print("⚠ Behind! {}ml / {}ml expected ({} behind)".format(total, expected, behind))
        print("  Drink {} cups to catch up".format(behind // 250 + 1))
PYEOF
;;
week)
    python3 << PYEOF
import json, time
from collections import defaultdict
with open("$DB") as f: data = json.load(f)
by_day = defaultdict(int)
for d in data: by_day[d["date"]] += d["ml"]
print("📊 This Week:")
for i in range(6, -1, -1):
    date = time.strftime("%Y-%m-%d", time.localtime(time.time()-i*86400))
    day = time.strftime("%a", time.localtime(time.time()-i*86400))
    ml = by_day.get(date, 0)
    bar = "█" * (ml // 200) + "░" * max(0, 10 - ml // 200)
    ok = "✅" if ml >= 2000 else "⚠"
    print("  {} {} [{}] {}ml {}".format(day, date, bar, ml, ok))
avg = sum(by_day.values()) / max(len(by_day), 1)
print("\n  Avg: {:.0f}ml/day".format(avg))
PYEOF
;;
history)
    n="${1:-7}"
    python3 << PYEOF
import json
from collections import defaultdict
with open("$DB") as f: data = json.load(f)
by_day = defaultdict(int)
for d in data: by_day[d["date"]] += d["ml"]
print("📋 Hydration History:")
for date in sorted(by_day.keys(), reverse=True)[:int("$n")]:
    ml = by_day[date]
    glasses = ml // 250
    print("  {} {}ml ({} glasses)".format(date, ml, glasses))
PYEOF
;;
stats)
    python3 << PYEOF
import json
from collections import defaultdict
with open("$DB") as f: data = json.load(f)
by_day = defaultdict(int)
for d in data: by_day[d["date"]] += d["ml"]
if not by_day: print("No data yet"); exit()
days = len(by_day)
total = sum(by_day.values())
avg = total / days
best = max(by_day.items(), key=lambda x: x[1])
goal_met = len([v for v in by_day.values() if v >= 2000])
print("📊 Hydration Stats:")
print("  Days tracked: {}".format(days))
print("  Total intake: {:.1f}L".format(total/1000))
print("  Daily average: {:.0f}ml".format(avg))
print("  Best day: {} ({}ml)".format(best[0], best[1]))
print("  Goal met: {}/{} days ({:.0f}%)".format(goal_met, days, goal_met*100/days))
PYEOF
;;
remind)
    python3 -c "
import random
tips = [
    '💧 Drink a glass of water first thing in the morning',
    '💧 Keep a water bottle at your desk',
    '💧 Drink before you feel thirsty',
    '💧 Add lemon or cucumber for flavor',
    '💧 Set hourly reminders on your phone',
    '💧 Drink a glass before each meal',
    '💧 Herbal tea counts toward your intake',
    '💧 Eat water-rich foods (watermelon, cucumber)',
    '💧 Match every coffee with a glass of water',
    '💧 Drink more when exercising or in hot weather',
]
print('💡 Hydration Tips:')
for t in random.sample(tips, 3): print('  ' + t)
";;
info) echo "Water Reminder v1.0.0"; echo "Track daily hydration and stay healthy"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
