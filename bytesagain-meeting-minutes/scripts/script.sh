#!/usr/bin/env bash
# bytesagain-meeting-minutes — Meeting notes manager
set -euo pipefail

CMD="${1:-help}"
shift || true

STORE="$HOME/.bytesagain-meetings"
mkdir -p "$STORE"

show_help() {
    echo "bytesagain-meeting-minutes — Terminal meeting minutes manager"
    echo ""
    echo "Usage:"
    echo "  bytesagain-meeting-minutes new \"<title>\"                           Create meeting"
    echo "  bytesagain-meeting-minutes add-action <id> \"<task>\" <owner> <due>  Add action item"
    echo "  bytesagain-meeting-minutes add-decision <id> \"<decision>\"          Record decision"
    echo "  bytesagain-meeting-minutes list                                    List all meetings"
    echo "  bytesagain-meeting-minutes view <id>                               View meeting details"
    echo "  bytesagain-meeting-minutes export <id>                             Export as Markdown"
    echo "  bytesagain-meeting-minutes done <id> <action_index>               Mark action complete"
    echo ""
}

next_id() {
    local max=0
    for f in "$STORE"/*.json; do
        [ -f "$f" ] || continue
        num=$(basename "$f" .json | sed 's/^0*//')
        [ -n "$num" ] && [ "$num" -gt "$max" ] && max=$num
    done
    printf "%03d" $((max + 1))
}

cmd_new() {
    local title="${1:-Untitled Meeting}"
    local id
    id=$(next_id)
    local now
    now=$(date '+%Y-%m-%d %H:%M')

    MM_FILE="$file" MM_TITLE="$title" MM_STORE="$STORE" python3 << 'PYEOF'
import json, os

data = {
    "id": "$id",
    "title": "$title",
    "date": "$now",
    "attendees": [],
    "agenda": [],
    "decisions": [],
    "actions": [],
    "notes": ""
}
path = os.path.expanduser("~/.bytesagain-meetings/$id.json")
with open(path, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
print(f"✅ Meeting created: [$id] $title")
print(f"   Date: $now")
print(f"   File: {path}")
print(f"")
print(f"Next steps:")
print(f"  bytesagain-meeting-minutes add-decision $id \"Your decision here\"")
print(f"  bytesagain-meeting-minutes add-action $id \"Task\" owner 2024-12-31")
PYEOF
}

cmd_add_action() {
    local id="${1:-}"
    local task="${2:-}"
    local owner="${3:-unassigned}"
    local due="${4:-TBD}"
    [ -z "$id" ] && echo "Usage: add-action <id> \"<task>\" <owner> <due_date>" && exit 1
    local file="$STORE/$id.json"
    [ ! -f "$file" ] && echo "Meeting $id not found" && exit 1

    MM_FILE="$file" MM_TITLE="$title" MM_STORE="$STORE" python3 << 'PYEOF'
import json

import os; path = os.environ.get("MM_FILE","")
with open(path) as f:
    data = json.load(f)

action = {
    "index": len(data["actions"]) + 1,
    "task": "$task",
    "owner": "$owner",
    "due": "$due",
    "status": "open"
}
data["actions"].append(action)
with open(path, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
print(f"✅ Action #{action['index']} added to meeting $id")
print(f"   Task:  $task")
print(f"   Owner: $owner | Due: $due")
PYEOF
}

cmd_add_decision() {
    local id="${1:-}"
    local decision="${2:-}"
    [ -z "$id" ] && echo "Usage: add-decision <id> \"<decision>\"" && exit 1
    local file="$STORE/$id.json"
    [ ! -f "$file" ] && echo "Meeting $id not found" && exit 1

    MM_FILE="$file" MM_TITLE="$title" MM_STORE="$STORE" python3 << 'PYEOF'
import json

import os; path = os.environ.get("MM_FILE","")
with open(path) as f:
    data = json.load(f)

data["decisions"].append("$decision")
with open(path, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
print(f"✅ Decision recorded in meeting $id")
print(f"   → $decision")
PYEOF
}

cmd_list() {
    MM_FILE="$file" MM_TITLE="$title" MM_STORE="$STORE" python3 << 'PYEOF'
import json, os, glob

store = os.path.expanduser("~/.bytesagain-meetings")
files = sorted(glob.glob(f"{store}/*.json"))

if not files:
    print("No meetings found. Create one:")
    print("  bytesagain-meeting-minutes new \"Team Standup\"")
    exit(0)

print(f"\n{'ID':>4}  {'Date':<17}  {'Title':<30}  {'Decisions':>9}  {'Actions':>7}  {'Open':>4}")
print("─" * 80)
for path in files:
    with open(path) as f:
        d = json.load(f)
    open_actions = sum(1 for a in d.get("actions", []) if a.get("status") == "open")
    print(f"[{d['id']}]  {d['date']:<17}  {d['title'][:30]:<30}  "
          f"{len(d.get('decisions',['])):>9}  {len(d.get('actions',[])):>7}  {open_actions:>4}")
print()
PYEOF
}

cmd_view() {
    local id="${1:-}"
    [ -z "$id" ] && echo "Usage: view <id>" && exit 1
    local file="$STORE/$id.json"
    [ ! -f "$file" ] && echo "Meeting $id not found" && exit 1

    MM_FILE="$file" MM_TITLE="$title" MM_STORE="$STORE" python3 << 'PYEOF'
import json

with open("$file") as f:
    d = json.load(f)

print(f"\n{'='*60}")
print(f"  [{d['id']}] {d['title']}")
print(f"  Date: {d['date']}")
print(f"{'='*60}")

if d.get("decisions"):
    print(f"\n📋 DECISIONS ({len(d['decisions'])}):")
    for i, dec in enumerate(d["decisions"], 1):
        print(f"  {i}. {dec}")

if d.get("actions"):
    print(f"\n✅ ACTION ITEMS ({len(d['actions'])}):")
    print(f"  {'#':>2}  {'Task':<30}  {'Owner':<12}  {'Due':<12}  Status")
    print(f"  {'─'*2}  {'─'*30}  {'─'*12}  {'─'*12}  {'─'*6}")
    for a in d["actions"]:
        status = "✅" if a["status"] == "done" else "🔲"
        print(f"  {a['index']:>2}  {a['task'][:30]:<30}  {a['owner']:<12}  {a['due']:<12}  {status}")

if not d.get("decisions") and not d.get("actions"):
    print("\n  (No decisions or actions recorded yet)")
print()
PYEOF
}

cmd_export() {
    local id="${1:-}"
    [ -z "$id" ] && echo "Usage: export <id>" && exit 1
    local file="$STORE/$id.json"
    [ ! -f "$file" ] && echo "Meeting $id not found" && exit 1

    MM_FILE="$file" MM_TITLE="$title" MM_STORE="$STORE" python3 << 'PYEOF'
import json

with open("$file") as f:
    d = json.load(f)

lines = []
lines.append(f"# Meeting Minutes: {d['title']}")
lines.append(f"")
lines.append(f"**Date:** {d['date']}")
lines.append(f"**Meeting ID:** {d['id']}")
lines.append(f"")

if d.get("decisions"):
    lines.append("## Decisions")
    lines.append("")
    for i, dec in enumerate(d["decisions"], 1):
        lines.append(f"{i}. {dec}")
    lines.append("")

if d.get("actions"):
    lines.append("## Action Items")
    lines.append("")
    lines.append("| # | Task | Owner | Due Date | Status |")
    lines.append("|---|------|-------|----------|--------|")
    for a in d["actions"]:
        status = "✅ Done" if a["status"] == "done" else "🔲 Open"
        lines.append(f"| {a['index']} | {a['task']} | {a['owner']} | {a['due']} | {status} |")
    lines.append("")

output = "\n".join(lines)
print(output)

out_path = f"/tmp/meeting-{d['id']}.md"
with open(out_path, "w", encoding="utf-8") as f:
    f.write(output)
print(f"\n---")
print(f"Exported to: {out_path}")
PYEOF
}

cmd_done() {
    local id="${1:-}"
    local idx="${2:-}"
    [ -z "$id" ] || [ -z "$idx" ] && echo "Usage: done <meeting_id> <action_index>" && exit 1
    local file="$STORE/$id.json"
    [ ! -f "$file" ] && echo "Meeting $id not found" && exit 1

    MM_FILE="$file" MM_TITLE="$title" MM_STORE="$STORE" python3 << 'PYEOF'
import json

with open("$file") as f:
    d = json.load(f)

idx = int("$idx")
found = False
for a in d["actions"]:
    if a["index"] == idx:
        a["status"] = "done"
        found = True
        print(f"✅ Action #{idx} marked as done: {a['task']}")
        break

if not found:
    print(f"Action #{idx} not found in meeting $id")
else:
    with open("$file", "w") as f:
        json.dump(d, f, indent=2, ensure_ascii=False)
PYEOF
}

case "$CMD" in
    new)          cmd_new "$@" ;;
    add-action)   cmd_add_action "$@" ;;
    add-decision) cmd_add_decision "$@" ;;
    list)         cmd_list ;;
    view)         cmd_view "$@" ;;
    export)       cmd_export "$@" ;;
    done)         cmd_done "$@" ;;
    help|--help|-h) show_help ;;
    *) echo "Unknown command: $CMD"; show_help; exit 1 ;;
esac
