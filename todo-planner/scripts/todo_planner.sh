#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Todo planner — task management with priorities and due dates
set -euo pipefail
TODO_DIR="${TODO_DIR:-$HOME/.todos}"
mkdir -p "$TODO_DIR"
DB="$TODO_DIR/tasks.json"
[ ! -f "$DB" ] && echo '[]' > "$DB"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Todo Planner — manage tasks with priorities
Commands:
  add <task> [priority]   Add task (priority: 1-high 2-med 3-low)
  done <id>               Mark task complete
  list [filter]           List tasks (all/today/overdue/done)
  edit <id> <text>        Edit task text
  priority <id> <1-3>     Change priority
  due <id> <date>         Set due date (YYYY-MM-DD)
  tag <id> <tag>          Add tag
  filter <tag>            Filter by tag
  clear-done              Remove completed tasks
  stats                   Task statistics
  export [format]         Export (md/csv/json)
  info                    Version info
Powered by BytesAgain | bytesagain.com";;
add)
    task="${1:-}"; pri="${2:-2}"
    [ -z "$task" ] && { echo "Usage: add <task> [1|2|3]"; exit 1; }
    python3 << PYEOF
import json, time
with open("$DB") as f: tasks = json.load(f)
tid = max([t.get("id",0) for t in tasks]+[0]) + 1
tasks.append({"id":tid,"task":"$task","priority":int("$pri"),"done":False,
              "created":time.strftime("%Y-%m-%d"),"due":"","tags":[]})
with open("$DB","w") as f: json.dump(tasks, f, indent=2)
icons = {1:"🔴",2:"🟡",3:"🟢"}
print("{} Task #{} added: $task".format(icons.get(int("$pri"),"📌"), tid))
PYEOF
;;
done)
    id="${1:-}"; [ -z "$id" ] && { echo "Usage: done <id>"; exit 1; }
    python3 -c "
import json, time
with open('$DB') as f: tasks = json.load(f)
for t in tasks:
    if t['id'] == int('$id'):
        t['done'] = True
        t['completed'] = time.strftime('%Y-%m-%d')
        print('✅ Done: {} #{}'.format(t['task'], t['id']))
        break
with open('$DB','w') as f: json.dump(tasks, f, indent=2)
";;
list)
    filt="${1:-all}"
    python3 << PYEOF
import json, time
with open("$DB") as f: tasks = json.load(f)
today = time.strftime("%Y-%m-%d")
if "$filt" == "today":
    tasks = [t for t in tasks if t.get("due","") == today and not t["done"]]
elif "$filt" == "overdue":
    tasks = [t for t in tasks if t.get("due","") and t["due"] < today and not t["done"]]
elif "$filt" == "done":
    tasks = [t for t in tasks if t["done"]]
elif "$filt" == "all":
    tasks = [t for t in tasks if not t["done"]]
icons = {1:"🔴",2:"🟡",3:"🟢"}
print("📋 Tasks ({})".format("$filt"))
for t in sorted(tasks, key=lambda x: x.get("priority",2)):
    icon = icons.get(t.get("priority",2), "📌")
    status = "✅" if t["done"] else icon
    due = " 📅{}".format(t["due"]) if t.get("due") else ""
    tags = " ".join(["#"+tag for tag in t.get("tags",[])])
    print("  {} #{:<3d} {:30s}{}  {}".format(status, t["id"], t["task"][:30], due, tags))
if not tasks: print("  (empty)")
PYEOF
;;
edit)
    id="${1:-}"; shift 2>/dev/null || true; text="$*"
    [ -z "$id" ] && { echo "Usage: edit <id> <text>"; exit 1; }
    python3 -c "
import json
with open('$DB') as f: tasks = json.load(f)
for t in tasks:
    if t['id'] == int('$id'): t['task'] = '$text'; print('✏️ Updated #{}'.format(t['id']))
with open('$DB','w') as f: json.dump(tasks, f, indent=2)
";;
priority)
    id="${1:-}"; pri="${2:-2}"
    python3 -c "
import json
with open('$DB') as f: tasks = json.load(f)
for t in tasks:
    if t['id'] == int('$id'): t['priority'] = int('$pri'); print('Priority #{} → {}'.format(t['id'],'$pri'))
with open('$DB','w') as f: json.dump(tasks, f, indent=2)
";;
due)
    id="${1:-}"; date="${2:-}"
    python3 -c "
import json
with open('$DB') as f: tasks = json.load(f)
for t in tasks:
    if t['id'] == int('$id'): t['due'] = '$date'; print('📅 Due #{} → $date'.format(t['id']))
with open('$DB','w') as f: json.dump(tasks, f, indent=2)
";;
tag)
    id="${1:-}"; tag="${2:-}"
    python3 -c "
import json
with open('$DB') as f: tasks = json.load(f)
for t in tasks:
    if t['id'] == int('$id'):
        if '$tag' not in t.get('tags',[]): t.setdefault('tags',[]).append('$tag')
        print('🏷 Tagged #{} with #$tag'.format(t['id']))
with open('$DB','w') as f: json.dump(tasks, f, indent=2)
";;
filter)
    tag="${1:-}"
    python3 -c "
import json
with open('$DB') as f: tasks = json.load(f)
found = [t for t in tasks if '$tag' in t.get('tags',[])]
print('🏷 #$tag ({} tasks):'.format(len(found)))
for t in found:
    status = '✅' if t['done'] else '⬜'
    print('  {} #{} {}'.format(status, t['id'], t['task'][:40]))
";;
clear-done)
    python3 -c "
import json
with open('$DB') as f: tasks = json.load(f)
active = [t for t in tasks if not t['done']]
removed = len(tasks) - len(active)
with open('$DB','w') as f: json.dump(active, f, indent=2)
print('🗑 Cleared {} completed tasks'.format(removed))
";;
stats)
    python3 << PYEOF
import json, time
with open("$DB") as f: tasks = json.load(f)
total = len(tasks)
done = len([t for t in tasks if t["done"]])
active = total - done
today = time.strftime("%Y-%m-%d")
overdue = len([t for t in tasks if t.get("due","") and t["due"] < today and not t["done"]])
print("📊 Task Stats:")
print("  Total: {}  Active: {}  Done: {}  Overdue: {}".format(total, active, done, overdue))
if total > 0:
    print("  Completion: {:.0f}%".format(done*100/total))
    from collections import Counter
    by_pri = Counter(t.get("priority",2) for t in tasks if not t["done"])
    print("  By Priority: 🔴High:{} 🟡Med:{} 🟢Low:{}".format(by_pri.get(1,0),by_pri.get(2,0),by_pri.get(3,0)))
PYEOF
;;
export)
    fmt="${1:-md}"
    python3 -c "
import json
with open('$DB') as f: tasks = json.load(f)
if '$fmt' == 'csv':
    print('id,task,priority,done,due,tags')
    for t in tasks:
        print('{},{},{},{},{},{}'.format(t['id'],t['task'],t.get('priority',2),t['done'],t.get('due',''),';'.join(t.get('tags',[]))))
elif '$fmt' == 'md':
    print('# Todo List\n')
    for t in tasks:
        check = 'x' if t['done'] else ' '
        print('- [{}] {} (P{})'.format(check, t['task'], t.get('priority',2)))
else:
    print(json.dumps(tasks, indent=2))
";;
info) echo "Todo Planner v1.0.0"; echo "Task management with priorities and due dates"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
