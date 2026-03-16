#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# License: MIT — independent, not derived from any third-party source
# Fitness log — track workouts and progress
set -euo pipefail
FIT_DIR="${FIT_DIR:-$HOME/.fitness}"
mkdir -p "$FIT_DIR"
DB="$FIT_DIR/workouts.json"
[ ! -f "$DB" ] && echo '[]' > "$DB"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Fitness Log — track workouts & progress
Commands:
  log <type> <dur> [note]  Log workout (type=run/gym/yoga/swim/bike)
  weight <kg>              Log body weight
  today                    Today's activity
  week                     Weekly summary
  history [n]              Workout history (default 10)
  stats                    Overall statistics
  streak                   Workout streak
  plan <goal>              Generate workout plan
  progress                 Weight progress chart
  personal-best            Personal records
  export [format]          Export (csv/json)
  info                     Version info
Powered by BytesAgain | bytesagain.com";;
log)
    type="${1:-workout}"; dur="${2:-30}"; note="${3:-}"
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
cals = {"run":10,"gym":8,"yoga":4,"swim":9,"bike":7,"walk":4,"hiit":12,"stretch":3}
cal = cals.get("$type", 6) * int("$dur")
data.append({"type":"$type","duration":int("$dur"),"calories":cal,
             "note":"$note","date":time.strftime("%Y-%m-%d"),"time":time.strftime("%H:%M")})
with open("$DB","w") as f: json.dump(data, f, indent=2)
icons = {"run":"🏃","gym":"🏋️","yoga":"🧘","swim":"🏊","bike":"🚴","walk":"🚶","hiit":"💪","stretch":"🤸"}
print("{} Logged: {} {}min ~{}cal".format(icons.get("$type","💪"), "$type", "$dur", cal))
PYEOF
;;
weight)
    w="${1:-}"; [ -z "$w" ] && { echo "Usage: weight <kg>"; exit 1; }
    echo "$(date +%Y-%m-%d)|$w" >> "$FIT_DIR/weight.csv"
    echo "⚖️ Weight: ${w}kg ($(date +%Y-%m-%d))";;
today)
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
today = time.strftime("%Y-%m-%d")
todays = [w for w in data if w["date"] == today]
total_min = sum(w["duration"] for w in todays)
total_cal = sum(w["calories"] for w in todays)
print("📅 Today's Activity:")
for w in todays:
    print("  {} {}min ~{}cal {}".format(w["type"], w["duration"], w["calories"], w.get("note","")))
print("  Total: {}min {}cal".format(total_min, total_cal))
if not todays: print("  No workouts yet today")
PYEOF
;;
week)
    python3 << PYEOF
import json, time
from collections import defaultdict
with open("$DB") as f: data = json.load(f)
cutoff = time.strftime("%Y-%m-%d", time.localtime(time.time()-7*86400))
week = [w for w in data if w["date"] >= cutoff]
by_type = defaultdict(lambda: {"count":0,"min":0,"cal":0})
for w in week:
    by_type[w["type"]]["count"] += 1
    by_type[w["type"]]["min"] += w["duration"]
    by_type[w["type"]]["cal"] += w["calories"]
print("📊 This Week:")
for t, s in sorted(by_type.items(), key=lambda x:-x[1]["min"]):
    print("  {} {}x {}min {}cal".format(t, s["count"], s["min"], s["cal"]))
print("  Total: {} workouts, {}min, {}cal".format(
    len(week), sum(w["duration"] for w in week), sum(w["calories"] for w in week)))
days_active = len(set(w["date"] for w in week))
print("  Active days: {}/7".format(days_active))
PYEOF
;;
history)
    n="${1:-10}"
    python3 << PYEOF
import json
with open("$DB") as f: data = json.load(f)
print("📋 Workout History:")
for w in data[-int("$n"):][::-1]:
    print("  {} {} {}min {}cal {}".format(w["date"], w["type"], w["duration"], w["calories"], w.get("note","")))
PYEOF
;;
stats)
    python3 << PYEOF
import json
from collections import Counter
with open("$DB") as f: data = json.load(f)
total = len(data)
total_min = sum(w["duration"] for w in data)
total_cal = sum(w["calories"] for w in data)
types = Counter(w["type"] for w in data)
print("📊 Fitness Stats:")
print("  Total workouts: {}".format(total))
print("  Total time: {:.1f}h".format(total_min/60))
print("  Total calories: {}".format(total_cal))
print("  Favorite: {} ({}x)".format(types.most_common(1)[0][0] if types else "-", types.most_common(1)[0][1] if types else 0))
if total > 0:
    avg_dur = total_min / total
    print("  Avg duration: {:.0f}min".format(avg_dur))
PYEOF
;;
streak)
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
dates = set(w["date"] for w in data)
streak = 0
for i in range(365):
    d = time.strftime("%Y-%m-%d", time.localtime(time.time()-i*86400))
    if d in dates: streak += 1
    elif i > 0: break
print("🔥 Workout streak: {} days".format(streak))
print("   " + "💪" * min(streak, 20))
PYEOF
;;
plan)
    goal="${1:-general}"
    python3 << PYEOF
plans = {
    "general": [("Mon","Run 30min"),("Tue","Gym 45min"),("Wed","Rest"),("Thu","Yoga 30min"),("Fri","Gym 45min"),("Sat","Bike 60min"),("Sun","Rest")],
    "weight-loss": [("Mon","HIIT 30min"),("Tue","Run 40min"),("Wed","Swim 30min"),("Thu","HIIT 30min"),("Fri","Bike 45min"),("Sat","Run 40min"),("Sun","Walk 60min")],
    "muscle": [("Mon","Gym-Upper 60min"),("Tue","Gym-Lower 60min"),("Wed","Rest"),("Thu","Gym-Push 60min"),("Fri","Gym-Pull 60min"),("Sat","Gym-Legs 60min"),("Sun","Rest")],
    "flexibility": [("Mon","Yoga 45min"),("Tue","Stretch 30min"),("Wed","Yoga 45min"),("Thu","Rest"),("Fri","Yoga 45min"),("Sat","Stretch 30min"),("Sun","Walk 30min")],
}
plan = plans.get("$goal", plans["general"])
print("📋 Workout Plan: $goal")
for day, activity in plan:
    print("  {} {}".format(day, activity))
PYEOF
;;
progress)
    echo "⚖️ Weight Progress:"
    if [ -f "$FIT_DIR/weight.csv" ]; then
        tail -14 "$FIT_DIR/weight.csv" | while IFS='|' read -r date w; do
            bar=$(python3 -c "print('█' * int(float('$w')/5))" 2>/dev/null || echo "")
            echo "  $date ${w}kg $bar"
        done
    else echo "  No weight data yet"; fi;;
personal-best)
    python3 << PYEOF
import json
from collections import defaultdict
with open("$DB") as f: data = json.load(f)
best = defaultdict(lambda: 0)
for w in data:
    if w["duration"] > best[w["type"]]:
        best[w["type"]] = w["duration"]
print("🏆 Personal Bests:")
for t, d in sorted(best.items(), key=lambda x:-x[1]):
    print("  {} {} — {}min".format("🥇", t, d))
PYEOF
;;
export)
    fmt="${1:-csv}"
    python3 -c "
import json
with open('$DB') as f: data = json.load(f)
if '$fmt'=='csv':
    print('date,type,duration,calories,note')
    for w in data: print('{},{},{},{},{}'.format(w['date'],w['type'],w['duration'],w['calories'],w.get('note','')))
else: print(json.dumps(data,indent=2))
";;
info) echo "Fitness Log v1.0.0"; echo "Track workouts and progress"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
