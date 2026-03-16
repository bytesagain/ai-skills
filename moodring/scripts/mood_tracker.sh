#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# License: MIT — independent, not derived from any third-party source
# Mood tracker — monitor emotional wellbeing
set -euo pipefail
MOOD_DIR="${MOOD_DIR:-$HOME/.moods}"
mkdir -p "$MOOD_DIR"
DB="$MOOD_DIR/moods.json"
[ ! -f "$DB" ] && echo '[]' > "$DB"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Mood Tracker — monitor emotional wellbeing
Commands:
  log <1-5> [note]     Log mood (1=terrible 5=amazing)
  today                Today's moods
  week                 Weekly mood chart
  history [n]          Mood history (default 14)
  stats                Mood statistics
  patterns             Identify mood patterns
  triggers [mood]      Common triggers by mood
  streak               Positive mood streak
  journal [text]       Mood journal entry
  insights             AI-style mood insights
  info                 Version info
Powered by BytesAgain | bytesagain.com";;
log)
    score="${1:-3}"; note="${2:-}"
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
emojis = {1:"😢",2:"😕",3:"😐",4:"🙂",5:"😄"}
labels = {1:"Terrible",2:"Not Great",3:"Okay",4:"Good",5:"Amazing"}
data.append({"score":int("$score"),"emoji":emojis.get(int("$score"),"😐"),
             "label":labels.get(int("$score"),"?"),"note":"$note",
             "date":time.strftime("%Y-%m-%d"),"time":time.strftime("%H:%M"),
             "weekday":time.strftime("%A")})
with open("$DB","w") as f: json.dump(data, f, indent=2)
print("{} Mood: {} ({}/5) {}".format(emojis.get(int("$score")), labels.get(int("$score")), "$score", "$note"))
PYEOF
;;
today)
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
today = time.strftime("%Y-%m-%d")
todays = [d for d in data if d["date"] == today]
if todays:
    avg = sum(d["score"] for d in todays) / len(todays)
    print("📅 Today's Moods:")
    for d in todays:
        print("  {} {} {}/5 {}".format(d["time"], d["emoji"], d["score"], d.get("note","")))
    print("  Average: {:.1f}/5".format(avg))
else: print("No mood logged today. Use 'log' to start.")
PYEOF
;;
week)
    python3 << PYEOF
import json, time
from collections import defaultdict
with open("$DB") as f: data = json.load(f)
by_day = defaultdict(list)
for d in data: by_day[d["date"]].append(d["score"])
emojis = {1:"😢",2:"😕",3:"😐",4:"🙂",5:"😄"}
print("📊 This Week:")
for i in range(6, -1, -1):
    date = time.strftime("%Y-%m-%d", time.localtime(time.time()-i*86400))
    day = time.strftime("%a", time.localtime(time.time()-i*86400))
    scores = by_day.get(date, [])
    if scores:
        avg = sum(scores) / len(scores)
        emoji = emojis.get(round(avg), "😐")
        bar = "█" * int(avg*4) + "░" * (20-int(avg*4))
        print("  {} {} [{}] {:.1f} {}".format(day, date, bar, avg, emoji))
    else:
        print("  {} {} [░░░░░░░░░░░░░░░░░░░░] -".format(day, date))
PYEOF
;;
history)
    n="${1:-14}"
    python3 << PYEOF
import json
with open("$DB") as f: data = json.load(f)
print("📋 Mood History:")
for d in data[-int("$n"):][::-1]:
    print("  {} {} {} {}/5 {}".format(d["date"], d["time"], d["emoji"], d["score"], d.get("note","")))
PYEOF
;;
stats)
    python3 << PYEOF
import json
from collections import Counter
with open("$DB") as f: data = json.load(f)
if not data: print("No data yet"); exit()
avg = sum(d["score"] for d in data) / len(data)
dist = Counter(d["score"] for d in data)
print("📊 Mood Stats ({} entries):".format(len(data)))
print("  Average: {:.1f}/5".format(avg))
print("  Distribution:")
for s in range(5, 0, -1):
    count = dist.get(s, 0)
    emojis = {1:"😢",2:"😕",3:"😐",4:"🙂",5:"😄"}
    bar = "█" * count
    print("    {} {}/5: {} ({})".format(emojis[s], s, bar, count))
best_day = max(data, key=lambda x: x["score"])
print("  Best: {}/5 on {}".format(best_day["score"], best_day["date"]))
PYEOF
;;
patterns)
    python3 << PYEOF
import json
from collections import defaultdict
with open("$DB") as f: data = json.load(f)
by_weekday = defaultdict(list)
by_hour = defaultdict(list)
for d in data:
    by_weekday[d.get("weekday","?")].append(d["score"])
    h = int(d.get("time","12:00").split(":")[0])
    period = "Morning" if h < 12 else ("Afternoon" if h < 18 else "Evening")
    by_hour[period].append(d["score"])
print("🔍 Mood Patterns:")
print("  By Day:")
for day in ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]:
    scores = by_weekday.get(day, [])
    if scores:
        avg = sum(scores)/len(scores)
        print("    {:10s} {:.1f}/5 ({} logs)".format(day, avg, len(scores)))
print("\n  By Time:")
for period in ["Morning","Afternoon","Evening"]:
    scores = by_hour.get(period, [])
    if scores:
        avg = sum(scores)/len(scores)
        print("    {:10s} {:.1f}/5".format(period, avg))
PYEOF
;;
triggers)
    mood="${1:-}"
    python3 -c "
import json
from collections import Counter
with open('$DB') as f: data = json.load(f)
target = int('$mood') if '$mood' else None
filtered = [d for d in data if d.get('note') and (target is None or d['score'] == target)]
notes = Counter(d['note'] for d in filtered)
label = 'Mood {}'.format(target) if target else 'All moods'
print('🔍 Common triggers ({}):'.format(label))
for note, count in notes.most_common(10):
    print('  {} ({})'.format(note, count))
";;
streak)
    python3 << PYEOF
import json, time
from collections import defaultdict
with open("$DB") as f: data = json.load(f)
by_day = defaultdict(list)
for d in data: by_day[d["date"]].append(d["score"])
streak = 0
for i in range(365):
    date = time.strftime("%Y-%m-%d", time.localtime(time.time()-i*86400))
    scores = by_day.get(date, [])
    if scores and sum(scores)/len(scores) >= 3.5:
        streak += 1
    elif i > 0: break
print("😄 Positive mood streak: {} days".format(streak))
print("   " + "🌟" * min(streak, 15))
PYEOF
;;
journal)
    text="${*:-}"
    [ -z "$text" ] && { echo "Usage: journal <text>"; exit 1; }
    f="$MOOD_DIR/journal-$(date +%Y-%m-%d).md"
    echo -e "\n## $(date +%H:%M)\n$text" >> "$f"
    echo "📝 Journal entry saved";;
insights)
    python3 << PYEOF
import json
from collections import defaultdict
with open("$DB") as f: data = json.load(f)
if len(data) < 5:
    print("Need at least 5 entries for insights")
    exit()
recent = data[-14:]
avg = sum(d["score"] for d in recent) / len(recent)
trend_first = sum(d["score"] for d in recent[:len(recent)//2]) / max(len(recent)//2, 1)
trend_last = sum(d["score"] for d in recent[len(recent)//2:]) / max(len(recent)//2, 1)
print("💡 Mood Insights:")
print("  Recent average: {:.1f}/5".format(avg))
if trend_last > trend_first + 0.3:
    print("  📈 Your mood is trending UP — keep doing what you're doing!")
elif trend_last < trend_first - 0.3:
    print("  📉 Your mood is trending DOWN — consider what changed")
else:
    print("  ➡️ Your mood is stable")
if avg >= 4:
    print("  🌟 You're doing great! Your average is above 4/5")
elif avg <= 2:
    print("  💛 Your average is below 2/5 — please reach out to someone you trust")
PYEOF
;;
info) echo "Mood Tracker v1.0.0"; echo "Monitor emotional wellbeing"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
