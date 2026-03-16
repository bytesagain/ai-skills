#!/bin/bash
# Mood Ring - Emotional wellbeing tracker
# Powered by BytesAgain | bytesagain.com

DATA_DIR="$HOME/.moodring"
DATA_FILE="$DATA_DIR/moods.json"
JOURNAL_FILE="$DATA_DIR/journal.json"
mkdir -p "$DATA_DIR"
[ ! -f "$DATA_FILE" ] && echo "[]" > "$DATA_FILE"
[ ! -f "$JOURNAL_FILE" ] && echo "[]" > "$JOURNAL_FILE"

get_today() { date +%Y-%m-%d; }
get_time() { date +%H:%M; }
get_weekday() { date +%A; }

cmd_log() {
    local score=$1; shift
    local note="$*"
    if ! [[ "$score" =~ ^[1-5]$ ]]; then
        echo "Error: Mood score must be 1-5 (1=terrible, 5=amazing)"
        return 1
    fi
    local labels=("" "😞 Terrible" "😕 Bad" "😐 Okay" "😊 Good" "🤩 Amazing")
    python3 << PYEOF
import json, sys
entry = {"date": "$(get_today)", "time": "$(get_time)", "weekday": "$(get_weekday)", "score": $score, "note": "$note"}
try:
    with open("$DATA_FILE") as f: data = json.load(f)
except: data = []
data.append(entry)
with open("$DATA_FILE", "w") as f: json.dump(data, f, indent=2)
PYEOF
    echo "Logged: ${labels[$score]} ($score/5)"
    [ -n "$note" ] && echo "Note: $note"
}

cmd_today() {
    local today=$(get_today)
    python3 << PYEOF
import json
try:
    with open("$DATA_FILE") as f: data = json.load(f)
except: data = []
todays = [e for e in data if e.get("date") == "$today"]
if not todays:
    print("No moods logged today. Use: moodring log <1-5> [note]")
else:
    labels = {1:"😞",2:"😕",3:"😐",4:"😊",5:"🤩"}
    print("Today's moods ({}):\n".format("$today"))
    for e in todays:
        icon = labels.get(e["score"],"?")
        note = " - {}".format(e.get("note","")) if e.get("note") else ""
        print("  {} {}/5 @ {}{}".format(icon, e["score"], e["time"], note))
    avg = sum(e["score"] for e in todays) / len(todays)
    print("\n  Average: {:.1f}/5".format(avg))
PYEOF
}

cmd_week() {
    python3 << PYEOF
import json, datetime
try:
    with open("$DATA_FILE") as f: data = json.load(f)
except: data = []
today = datetime.date.today()
week_data = {}
for i in range(7):
    d = (today - datetime.timedelta(days=6-i)).strftime("%Y-%m-%d")
    week_data[d] = []
for e in data:
    if e["date"] in week_data:
        week_data[e["date"]].append(e["score"])
print("Weekly Mood Chart:")
print("-" * 40)
bars = {1:"█",2:"██",3:"███",4:"████",5:"█████"}
for d in sorted(week_data.keys()):
    scores = week_data[d]
    if scores:
        avg = sum(scores)/len(scores)
        bar = bars.get(round(avg),"?")
        print("  {} | {} {:.1f}".format(d[-5:], bar, avg))
    else:
        print("  {} | (no data)".format(d[-5:]))
all_scores = [s for ss in week_data.values() for s in ss]
if all_scores:
    print("-" * 40)
    print("  Weekly avg: {:.1f}/5".format(sum(all_scores)/len(all_scores)))
PYEOF
}

cmd_history() {
    local days=${1:-14}
    python3 << PYEOF
import json, datetime
try:
    with open("$DATA_FILE") as f: data = json.load(f)
except: data = []
cutoff = (datetime.date.today() - datetime.timedelta(days=$days)).strftime("%Y-%m-%d")
recent = [e for e in data if e["date"] >= cutoff]
labels = {1:"😞",2:"😕",3:"😐",4:"😊",5:"🤩"}
print("Mood History (last $days days):")
print("-" * 50)
for e in sorted(recent, key=lambda x: x["date"]+x["time"]):
    icon = labels.get(e["score"],"?")
    note = " - {}".format(e.get("note","")) if e.get("note") else ""
    print("  {} {} {}/5 @ {}{}".format(e["date"], icon, e["score"], e["time"], note))
print("-" * 50)
print("Total entries: {}".format(len(recent)))
PYEOF
}

cmd_stats() {
    python3 << PYEOF
import json
try:
    with open("$DATA_FILE") as f: data = json.load(f)
except: data = []
if not data:
    print("No mood data yet.")
else:
    scores = [e["score"] for e in data]
    dist = {i: scores.count(i) for i in range(1,6)}
    labels = {1:"😞 Terrible",2:"😕 Bad",3:"😐 Okay",4:"😊 Good",5:"🤩 Amazing"}
    print("Mood Statistics:")
    print("-" * 40)
    print("  Total entries: {}".format(len(scores)))
    print("  Average: {:.1f}/5".format(sum(scores)/len(scores)))
    print("  Best day: {}".format(max(scores)))
    print("  Worst day: {}".format(min(scores)))
    print("\n  Distribution:")
    for i in range(5,0,-1):
        pct = dist[i]/len(scores)*100
        bar = "█" * int(pct/5)
        print("    {} {:2d} ({:4.1f}%) {}".format(labels[i], dist[i], pct, bar))
PYEOF
}

cmd_patterns() {
    python3 << PYEOF
import json
from collections import defaultdict
try:
    with open("$DATA_FILE") as f: data = json.load(f)
except: data = []
if len(data) < 3:
    print("Need at least 3 entries to identify patterns.")
else:
    by_day = defaultdict(list)
    by_hour = defaultdict(list)
    for e in data:
        by_day[e.get("weekday","?")].append(e["score"])
        h = int(e["time"].split(":")[0])
        period = "Morning" if h < 12 else "Afternoon" if h < 17 else "Evening"
        by_hour[period].append(e["score"])
    print("Mood Patterns:")
    print("-" * 40)
    print("  By day of week:")
    for day in ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]:
        if day in by_day:
            avg = sum(by_day[day])/len(by_day[day])
            print("    {}: {:.1f}/5 ({} entries)".format(day[:3], avg, len(by_day[day])))
    print("\n  By time of day:")
    for period in ["Morning","Afternoon","Evening"]:
        if period in by_hour:
            avg = sum(by_hour[period])/len(by_hour[period])
            print("    {}: {:.1f}/5 ({} entries)".format(period, avg, len(by_hour[period])))
PYEOF
}

cmd_triggers() {
    local mood_filter=${1:-""}
    python3 << PYEOF
import json
from collections import Counter
try:
    with open("$DATA_FILE") as f: data = json.load(f)
except: data = []
filtered = [e for e in data if e.get("note")]
if "$mood_filter":
    try:
        mf = int("$mood_filter")
        filtered = [e for e in filtered if e["score"] == mf]
    except: pass
if not filtered:
    print("No notes found. Log moods with notes: moodring log 4 feeling great after exercise")
else:
    words = []
    for e in filtered:
        words.extend(e["note"].lower().split())
    common = Counter(words).most_common(10)
    print("Common triggers/themes:")
    for w, c in common:
        if len(w) > 2:
            print("  {} ({}x)".format(w, c))
PYEOF
}

cmd_streak() {
    python3 << PYEOF
import json, datetime
try:
    with open("$DATA_FILE") as f: data = json.load(f)
except: data = []
by_date = {}
for e in data:
    d = e["date"]
    if d not in by_date or e["score"] > by_date[d]:
        by_date[d] = e["score"]
dates = sorted(by_date.keys(), reverse=True)
streak = 0
for d in dates:
    if by_date[d] >= 4:
        streak += 1
    else:
        break
if streak > 0:
    print("🔥 Positive streak: {} day(s)!".format(streak))
else:
    print("No current positive streak. Log a mood of 4+ to start one!")
PYEOF
}

cmd_journal() {
    local text="$*"
    if [ -z "$text" ]; then
        echo "Usage: moodring journal <your journal entry>"
        return 1
    fi
    python3 << PYEOF
import json
entry = {"date": "$(get_today)", "time": "$(get_time)", "text": "$text"}
try:
    with open("$JOURNAL_FILE") as f: data = json.load(f)
except: data = []
data.append(entry)
with open("$JOURNAL_FILE", "w") as f: json.dump(data, f, indent=2)
print("Journal entry saved for $(get_today) $(get_time)")
PYEOF
}

cmd_insights() {
    python3 << PYEOF
import json, datetime
try:
    with open("$DATA_FILE") as f: data = json.load(f)
except: data = []
if len(data) < 5:
    print("Need at least 5 entries for insights. Keep logging!")
else:
    scores = [e["score"] for e in data]
    avg = sum(scores)/len(scores)
    recent = scores[-7:] if len(scores) >= 7 else scores
    recent_avg = sum(recent)/len(recent)
    trend = "improving" if recent_avg > avg else "declining" if recent_avg < avg else "stable"
    print("Mood Insights:")
    print("-" * 40)
    print("  Overall average: {:.1f}/5".format(avg))
    print("  Recent trend: {} ({:.1f}/5)".format(trend, recent_avg))
    if trend == "improving":
        print("  💪 Great progress! Keep doing what works.")
    elif trend == "declining":
        print("  💙 Consider what might be affecting you.")
    else:
        print("  ✨ Consistent mood. Stability is valuable.")
    high_days = sum(1 for s in scores if s >= 4)
    pct = high_days/len(scores)*100
    print("  Good days (4+): {:.0f}%".format(pct))
PYEOF
}

cmd_info() {
    echo "Mood Ring v1.0.0"
    echo "Emotional wellbeing tracker"
    echo "Powered by BytesAgain | bytesagain.com"
}

cmd_help() {
    echo "Mood Ring - Emotional Wellbeing Tracker"
    echo "Usage: moodring <command> [arguments]"
    echo ""
    echo "Commands:"
    echo "  log <1-5> [note]  Log mood (1=terrible, 5=amazing)"
    echo "  today             Today's moods"
    echo "  week              Weekly mood chart"
    echo "  history [n]       Mood history (default 14 days)"
    echo "  stats             Mood statistics"
    echo "  patterns          Identify mood patterns"
    echo "  triggers [mood]   Common triggers by mood level"
    echo "  streak            Positive mood streak"
    echo "  journal <text>    Write mood journal entry"
    echo "  insights          AI-style mood insights"
    echo "  info              Version info"
    echo "  help              Show this help"
    echo ""
    echo "Example: moodring log 4 feeling great after exercise"
}

case "$1" in
    log) shift; cmd_log "$@";;
    today) cmd_today;;
    week) cmd_week;;
    history) shift; cmd_history "$@";;
    stats) cmd_stats;;
    patterns) cmd_patterns;;
    triggers) shift; cmd_triggers "$@";;
    streak) cmd_streak;;
    journal) shift; cmd_journal "$@";;
    insights) cmd_insights;;
    info) cmd_info;;
    help|"") cmd_help;;
    *) echo "Unknown command: $1"; cmd_help; exit 1;;
esac
