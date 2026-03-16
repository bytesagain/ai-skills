#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# License: MIT — independent, not derived from any third-party source
# Time tracker — track time on tasks & projects
set -euo pipefail
TT_DIR="${TT_DIR:-$HOME/.timetrack}"
mkdir -p "$TT_DIR"
DB="$TT_DIR/entries.json"
[ ! -f "$DB" ] && echo '[]' > "$DB"
STATE="$TT_DIR/current.json"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Time Tracker — track where your time goes
Commands:
  start <task> [project]  Start timer
  stop                    Stop current timer
  status                  Current timer status
  log [days]              Time log (default 7 days)
  report [days]           Summary report
  projects                List projects
  today                   Today's breakdown
  week                    This week summary
  export [format]         Export (csv/json/md)
  info                    Version info
Powered by BytesAgain | bytesagain.com";;
start)
    task="${1:-work}"; project="${2:-default}"
    python3 << PYEOF
import json, time
state = {"task":"$task","project":"$project","start":time.time(),"start_str":time.strftime("%H:%M")}
with open("$STATE","w") as f: json.dump(state, f)
print("⏱ Started: $task ($project) at {}".format(state["start_str"]))
PYEOF
;;
stop)
    [ ! -f "$STATE" ] && { echo "No timer running"; exit 0; }
    python3 << PYEOF
import json, time, os
with open("$STATE") as f: state = json.load(f)
elapsed = time.time() - state["start"]
hours = elapsed / 3600
with open("$DB") as f: entries = json.load(f)
entries.append({
    "task": state["task"], "project": state["project"],
    "date": time.strftime("%Y-%m-%d"), "start": state["start_str"],
    "end": time.strftime("%H:%M"), "hours": round(hours, 2)
})
with open("$DB","w") as f: json.dump(entries, f, indent=2)
os.remove("$STATE")
print("⏹ Stopped: {} — {:.1f}h".format(state["task"], hours))
PYEOF
;;
status)
    if [ -f "$STATE" ]; then
        python3 -c "
import json, time
with open('$STATE') as f: s = json.load(f)
elapsed = time.time() - s['start']
print('⏱ Running: {} ({}) — {:.1f}h since {}'.format(s['task'],s['project'],elapsed/3600,s['start_str']))
"
    else echo "⏹ No timer running"; fi;;
log)
    days="${1:-7}"
    python3 << PYEOF
import json, time
with open("$DB") as f: entries = json.load(f)
cutoff = time.strftime("%Y-%m-%d", time.localtime(time.time() - int("$days")*86400))
recent = [e for e in entries if e["date"] >= cutoff]
print("📋 Time Log (last $days days):")
for e in recent[-20:]:
    print("  {} {}-{} {:5.1f}h  {:15s} [{}]".format(
        e["date"], e["start"], e["end"], e["hours"], e["task"][:15], e["project"]))
total = sum(e["hours"] for e in recent)
print("  Total: {:.1f}h".format(total))
PYEOF
;;
report)
    days="${1:-7}"
    python3 << PYEOF
import json, time
from collections import defaultdict
with open("$DB") as f: entries = json.load(f)
cutoff = time.strftime("%Y-%m-%d", time.localtime(time.time() - int("$days")*86400))
recent = [e for e in entries if e["date"] >= cutoff]
by_project = defaultdict(float)
by_task = defaultdict(float)
for e in recent:
    by_project[e["project"]] += e["hours"]
    by_task[e["task"]] += e["hours"]
total = sum(e["hours"] for e in recent)
print("📊 Time Report ($days days)")
print("  Total: {:.1f}h ({:.1f}h/day avg)".format(total, total/max(1,int("$days"))))
print("\n  By Project:")
for p, h in sorted(by_project.items(), key=lambda x:-x[1]):
    pct = h*100/max(total,0.01)
    bar = "█" * int(pct/5) + "░" * (20-int(pct/5))
    print("    {:15s} [{}] {:.1f}h ({:.0f}%)".format(p[:15], bar, h, pct))
print("\n  By Task:")
for t, h in sorted(by_task.items(), key=lambda x:-x[1])[:10]:
    print("    {:15s} {:.1f}h".format(t[:15], h))
PYEOF
;;
projects)
    python3 -c "
import json
from collections import defaultdict
with open('$DB') as f: entries = json.load(f)
projects = defaultdict(float)
for e in entries: projects[e['project']] += e['hours']
print('📂 Projects:')
for p, h in sorted(projects.items(), key=lambda x:-x[1]):
    print('  {:20s} {:.1f}h total'.format(p, h))
";;
today)
    python3 << PYEOF
import json, time
from collections import defaultdict
with open("$DB") as f: entries = json.load(f)
today = time.strftime("%Y-%m-%d")
todays = [e for e in entries if e["date"] == today]
total = sum(e["hours"] for e in todays)
print("📅 Today ({})".format(today))
if todays:
    for e in todays:
        print("  {}-{} {:.1f}h {} [{}]".format(e["start"],e["end"],e["hours"],e["task"],e["project"]))
    print("  Total: {:.1f}h".format(total))
else: print("  No entries yet")
PYEOF
;;
week)
    bash "$0" report 7;;
export)
    fmt="${1:-csv}"
    python3 -c "
import json
with open('$DB') as f: entries = json.load(f)
fmt = '$fmt'
if fmt == 'csv':
    print('date,start,end,hours,task,project')
    for e in entries:
        print('{},{},{},{},{},{}'.format(e['date'],e['start'],e['end'],e['hours'],e['task'],e['project']))
elif fmt == 'md':
    print('| Date | Start | End | Hours | Task | Project |')
    print('|------|-------|-----|-------|------|---------|')
    for e in entries:
        print('| {} | {} | {} | {:.1f} | {} | {} |'.format(e['date'],e['start'],e['end'],e['hours'],e['task'],e['project']))
else:
    print(json.dumps(entries, indent=2))
";;
info) echo "Time Tracker v1.0.0"; echo "Track where your time goes"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
