#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# License: MIT — independent, not derived from any third-party source
# Sleep diary — track sleep quality and patterns
set -euo pipefail
SLEEP_DIR="${SLEEP_DIR:-$HOME/.sleep}"
mkdir -p "$SLEEP_DIR"
DB="$SLEEP_DIR/sleep.json"
[ ! -f "$DB" ] && echo '[]' > "$DB"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Sleep Diary — track sleep quality & patterns
Commands:
  log <hours> [quality]    Log sleep (quality 1-5)
  bedtime <HH:MM>          Log bedtime
  wakeup <HH:MM>           Log wake time
  today                    Last night's sleep
  week                     Weekly sleep summary
  history [n]              Sleep history (default 7)
  stats                    Sleep statistics
  trend                    Sleep trend chart
  tips                     Sleep improvement tips
  score                    Sleep health score
  info                     Version info
Powered by BytesAgain | bytesagain.com";;
log)
    hours="${1:-7}"; quality="${2:-3}"
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
stars = "⭐" * int("$quality")
data.append({"date":time.strftime("%Y-%m-%d"),"hours":float("$hours"),
             "quality":int("$quality"),"bedtime":"","wakeup":"",
             "notes":""})
with open("$DB","w") as f: json.dump(data, f, indent=2)
rating = "Poor" if int("$quality") <= 2 else ("OK" if int("$quality") == 3 else ("Good" if int("$quality") == 4 else "Great"))
print("😴 Sleep logged: {}h {} {}".format("$hours", stars, rating))
PYEOF
;;
bedtime)
    t="${1:-}"; [ -z "$t" ] && { echo "Usage: bedtime <HH:MM>"; exit 1; }
    echo "$(date +%Y-%m-%d)|bedtime|$t" >> "$SLEEP_DIR/times.csv"
    echo "🌙 Bedtime: $t";;
wakeup)
    t="${1:-}"; [ -z "$t" ] && { echo "Usage: wakeup <HH:MM>"; exit 1; }
    echo "$(date +%Y-%m-%d)|wakeup|$t" >> "$SLEEP_DIR/times.csv"
    echo "☀️ Wakeup: $t";;
today)
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
today = time.strftime("%Y-%m-%d")
for d in reversed(data):
    if d["date"] == today or d["date"] == time.strftime("%Y-%m-%d", time.localtime(time.time()-86400)):
        stars = "⭐" * d["quality"]
        print("😴 Last night ({})".format(d["date"]))
        print("   Hours: {}h".format(d["hours"]))
        print("   Quality: {} ({}/5)".format(stars, d["quality"]))
        if d.get("bedtime"): print("   Bedtime: {}".format(d["bedtime"]))
        if d.get("wakeup"): print("   Wakeup: {}".format(d["wakeup"]))
        break
else: print("No sleep data for today")
PYEOF
;;
week)
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
cutoff = time.strftime("%Y-%m-%d", time.localtime(time.time()-7*86400))
week = [d for d in data if d["date"] >= cutoff]
if week:
    avg_hours = sum(d["hours"] for d in week) / len(week)
    avg_quality = sum(d["quality"] for d in week) / len(week)
    print("📊 This Week ({} nights):".format(len(week)))
    for d in week:
        bar = "█" * int(d["hours"]) + "░" * max(0, 8-int(d["hours"]))
        print("  {} [{}] {:.1f}h {}".format(d["date"], bar, d["hours"], "⭐"*d["quality"]))
    print("\n  Avg: {:.1f}h sleep, {:.1f}/5 quality".format(avg_hours, avg_quality))
    if avg_hours < 7: print("  ⚠ Below recommended 7-9 hours")
    else: print("  ✅ Good sleep duration")
else: print("No data this week")
PYEOF
;;
history)
    n="${1:-7}"
    python3 << PYEOF
import json
with open("$DB") as f: data = json.load(f)
print("📋 Sleep History:")
for d in data[-int("$n"):][::-1]:
    print("  {} {:.1f}h quality:{}/5".format(d["date"], d["hours"], d["quality"]))
PYEOF
;;
stats)
    python3 << PYEOF
import json
with open("$DB") as f: data = json.load(f)
if not data: print("No data yet"); exit()
avg_h = sum(d["hours"] for d in data) / len(data)
avg_q = sum(d["quality"] for d in data) / len(data)
best = max(data, key=lambda x: x["hours"])
worst = min(data, key=lambda x: x["hours"])
print("📊 Sleep Stats ({} nights):".format(len(data)))
print("  Avg hours: {:.1f}h".format(avg_h))
print("  Avg quality: {:.1f}/5".format(avg_q))
print("  Best night: {}h ({})".format(best["hours"], best["date"]))
print("  Worst night: {}h ({})".format(worst["hours"], worst["date"]))
good = len([d for d in data if d["hours"] >= 7 and d["quality"] >= 4])
print("  Good nights: {}/{} ({:.0f}%)".format(good, len(data), good*100/len(data)))
PYEOF
;;
trend)
    python3 << PYEOF
import json
with open("$DB") as f: data = json.load(f)
print("📈 Sleep Trend (last 14 nights):")
for d in data[-14:]:
    bar = "█" * int(d["hours"]*2) + "░" * max(0, 18-int(d["hours"]*2))
    ok = "✅" if d["hours"] >= 7 else "⚠"
    print("  {} [{}] {:.1f}h {}".format(d["date"], bar, d["hours"], ok))
PYEOF
;;
tips)
    python3 -c "
import random
tips = [
    '🌙 Keep a consistent bedtime — even on weekends',
    '📱 No screens 1 hour before bed',
    '🌡 Keep bedroom cool (18-20°C / 65-68°F)',
    '☕ No caffeine after 2 PM',
    '🏃 Exercise regularly, but not too close to bedtime',
    '🍷 Limit alcohol — it disrupts sleep quality',
    '📖 Read a book instead of scrolling',
    '🧘 Try deep breathing or meditation before sleep',
    '🌅 Get morning sunlight to set circadian rhythm',
    '🛏 Use bed only for sleep (not work/TV)',
    '🔇 Use white noise or earplugs for noise',
    '🥗 Avoid heavy meals 3 hours before bed',
]
selected = random.sample(tips, min(5, len(tips)))
print('💡 Sleep Tips:')
for t in selected: print('  ' + t)
";;
score)
    python3 << PYEOF
import json
with open("$DB") as f: data = json.load(f)
if len(data) < 3:
    print("Need at least 3 nights of data")
    exit()
recent = data[-7:]
avg_h = sum(d["hours"] for d in recent) / len(recent)
avg_q = sum(d["quality"] for d in recent) / len(recent)
consistency = 1 - (max(d["hours"] for d in recent) - min(d["hours"] for d in recent)) / 10
duration_score = min(avg_h / 8 * 40, 40)
quality_score = avg_q / 5 * 40
consistency_score = consistency * 20
total = int(duration_score + quality_score + consistency_score)
grade = "A" if total >= 80 else ("B" if total >= 60 else ("C" if total >= 40 else "D"))
print("💤 Sleep Health Score: {}/100 ({})".format(total, grade))
print("   Duration: {:.0f}/40 (avg {:.1f}h)".format(duration_score, avg_h))
print("   Quality: {:.0f}/40 (avg {:.1f}/5)".format(quality_score, avg_q))
print("   Consistency: {:.0f}/20".format(consistency_score))
PYEOF
;;
info) echo "Sleep Diary v1.0.0"; echo "Track sleep quality and patterns"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
