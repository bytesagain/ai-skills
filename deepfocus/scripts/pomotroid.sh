#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# License: MIT — independent, not derived from any third-party source
# Pomodoro timer — focus sessions with breaks
set -euo pipefail
POMO_DIR="${POMO_DIR:-$HOME/.pomodoro}"
mkdir -p "$POMO_DIR"
LOG="$POMO_DIR/log.json"
[ ! -f "$LOG" ] && echo '[]' > "$LOG"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Pomodoro Timer — focus with timed sessions
Commands:
  start [min] [task]    Start session (default 25min)
  break [min]           Short break (default 5min)
  long-break [min]      Long break (default 15min)
  status                Current session
  log [n]               Recent sessions
  stats                 Pomodoro statistics
  today                 Today's sessions
  streak                Current day streak
  info                  Version info
Powered by BytesAgain | bytesagain.com";;
start)
    mins="${1:-25}"; task="${2:-focus}"
    python3 << PYEOF
import json, time
entry = {"type":"pomodoro","task":"$task","minutes":int("$mins"),
         "start":time.strftime("%Y-%m-%d %H:%M"),"date":time.strftime("%Y-%m-%d")}
with open("$POMO_DIR/current.json","w") as f: json.dump(entry, f)
print("🍅 Pomodoro started: $task ($mins min)")
print("   End at: {}".format(time.strftime("%H:%M", time.localtime(time.time()+int("$mins")*60))))
PYEOF
;;
break)
    mins="${1:-5}"
    echo "☕ Break: $mins minutes"
    echo "   Back at: $(date -d "+$mins minutes" '+%H:%M' 2>/dev/null || echo '?')";;
long-break)
    mins="${1:-15}"
    echo "🌴 Long break: $mins minutes";;
status)
    if [ -f "$POMO_DIR/current.json" ]; then
        python3 -c "
import json, time
with open('$POMO_DIR/current.json') as f: s = json.load(f)
print('🍅 {} ({} min) started at {}'.format(s['task'],s['minutes'],s['start']))
"
    else echo "⏹ No session active"; fi;;
log)
    n="${1:-10}"
    python3 << PYEOF
import json
with open("$LOG") as f: entries = json.load(f)
print("📋 Recent Pomodoros:")
for e in entries[-int("$n"):]:
    print("  🍅 {} {}min — {} [{}]".format(e["start"],e["minutes"],e["task"],e.get("type","?")))
print("  Total: {} sessions".format(len(entries)))
PYEOF
;;
stats)
    python3 << PYEOF
import json
from collections import Counter, defaultdict
with open("$LOG") as f: entries = json.load(f)
total = len(entries)
total_min = sum(e.get("minutes",25) for e in entries)
by_task = Counter(e["task"] for e in entries)
print("📊 Pomodoro Stats:")
print("  Total sessions: {}".format(total))
print("  Total time: {:.1f}h".format(total_min/60))
print("  Avg/day: {:.1f}".format(total/max(1,len(set(e["date"] for e in entries)))))
print("\n  By Task:")
for t, c in by_task.most_common(5):
    print("    {:15s} {} sessions".format(t[:15], c))
PYEOF
;;
today)
    python3 << PYEOF
import json, time
with open("$LOG") as f: entries = json.load(f)
today = time.strftime("%Y-%m-%d")
todays = [e for e in entries if e.get("date") == today]
total_min = sum(e.get("minutes",25) for e in todays)
print("📅 Today: {} pomodoros ({:.1f}h)".format(len(todays), total_min/60))
for e in todays:
    print("  🍅 {} — {} ({}min)".format(e["start"].split(" ")[-1],e["task"],e["minutes"]))
PYEOF
;;
streak)
    python3 << PYEOF
import json, time
with open("$LOG") as f: entries = json.load(f)
dates = sorted(set(e.get("date","") for e in entries), reverse=True)
streak = 0
today = time.strftime("%Y-%m-%d")
for i, d in enumerate(dates):
    expected = time.strftime("%Y-%m-%d", time.localtime(time.time() - i*86400))
    if d == expected: streak += 1
    else: break
print("🔥 Current streak: {} days".format(streak))
bar = "🍅" * min(streak, 20)
print("   {}".format(bar if bar else "Start your first session!"))
PYEOF
;;
info) echo "Pomodoro Timer v1.0.0"; echo "Focus with timed work sessions"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
