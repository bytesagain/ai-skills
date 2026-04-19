#!/usr/bin/env bash
# task-planner v3.0.5 - Professional Task Manager & Scheduler
# Powered by BytesAgain | bytesagain.com
set -euo pipefail

VERSION="3.0.5"
DATA_DIR="${TASK_PLANNER_DIR:-$HOME/.task-planner}"
TASKS_FILE="$DATA_DIR/tasks.json"

mkdir -p "$DATA_DIR"

# Initialize tasks file if missing
if [[ ! -f "$TASKS_FILE" ]]; then
    echo '[]' > "$TASKS_FILE"
fi

# ─── Commands ───────────────────────────────────────────────────────

cmd_add() {
    local text=""
    local priority="medium"
    local due=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --priority)
                shift
                priority="${1:-medium}"
                if [[ "$priority" != "high" && "$priority" != "medium" && "$priority" != "low" ]]; then
                    echo "Error: priority must be high, medium, or low" >&2
                    exit 1
                fi
                ;;
            --due)
                shift
                due="${1:-}"
                ;;
            *)
                if [[ -z "$text" ]]; then
                    text="$1"
                else
                    text="$text $1"
                fi
                ;;
        esac
        shift
    done

    if [[ -z "$text" ]]; then
        echo "Error: task text is required" >&2
        echo "Usage: task-planner add <task> [--priority high|medium|low] [--due YYYY-MM-DD]" >&2
        exit 1
    fi

    local created
    created="$(date '+%Y-%m-%d %H:%M:%S')"

    python3 -u - "$TASKS_FILE" "$text" "$priority" "$due" "$created" << 'PYEOF'
import json, sys, os

tasks_file, text, priority, due, created = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]

if not os.path.exists(tasks_file):
    with open(tasks_file, 'w') as f: json.dump([], f)

with open(tasks_file, 'r') as f:
    try:
        tasks = json.load(f)
    except:
        tasks = []

next_id = max((t["id"] for t in tasks), default=0) + 1

task = {
    "id": next_id,
    "text": text,
    "priority": priority,
    "status": "pending",
    "due": due,
    "created": created
}
tasks.append(task)

with open(tasks_file, "w") as f:
    json.dump(tasks, f, indent=2)

due_str = f" (due: {due})" if due else ""
print(f"  ✅ Added task #{next_id}: {text} [{priority}]{due_str}")
PYEOF
}

cmd_list() {
    local status="pending"
    local priority=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --status)
                shift
                status="${1:-pending}"
                ;;
            --priority)
                shift
                priority="${1:-}"
                ;;
        esac
        shift
    done

    python3 -u - "$TASKS_FILE" "$status" "$priority" << 'PYEOF'
import json, sys

tasks_file, status_filter, priority_filter = sys.argv[1], sys.argv[2], sys.argv[3]

try:
    with open(tasks_file) as f:
        tasks = json.load(f)
except:
    print("  No tasks found.")
    sys.exit(0)

if status_filter != "all":
    tasks = [t for t in tasks if t["status"] == status_filter]

if priority_filter:
    tasks = [t for t in tasks if t["priority"] == priority_filter]

if not tasks:
    print("  No tasks found matching criteria.")
    sys.exit(0)

# Sort: priority then ID
pri_map = {"high": 0, "medium": 1, "low": 2}
tasks.sort(key=lambda x: (pri_map.get(x["priority"], 1), x["id"]))

id_w = max(len(str(t["id"])) for t in tasks)
id_w = max(id_w, 2)
pri_w = max(len(t["priority"]) for t in tasks)
pri_w = max(pri_w, 3)

print(f"  {'ID'.ljust(id_w)}  {'PRI'.ljust(pri_w)}  STATUS   DUE         TASK")
print(f"  {'─' * id_w}  {'─' * pri_w}  ───────  ──────────  ────────────────────")

for t in tasks:
    tid = str(t["id"]).ljust(id_w)
    pri = t["priority"].ljust(pri_w)
    status = t["status"].ljust(7)
    due = t.get("due", "") or "—"
    due = due.ljust(10)
    marker = "✓" if t["status"] == "done" else "○"
    print(f"  {tid}  {pri}  {status}  {due}  {marker} {t['text']}")
PYEOF
}

cmd_done() {
    local id="${1:-}"
    if [[ -z "$id" ]]; then
        echo "Error: task ID is required" >&2
        exit 1
    fi

    python3 -u - "$TASKS_FILE" "$id" << 'PYEOF'
import json, sys

tasks_file, target_id = sys.argv[1], int(sys.argv[2])

with open(tasks_file) as f:
    tasks = json.load(f)

found = False
for t in tasks:
    if t["id"] == target_id:
        t["status"] = "done"
        found = True
        print(f"  ✅ Task #{target_id} completed: {t['text']}")
        break

if not found:
    print(f"  Error: task #{target_id} not found.")
    sys.exit(1)

with open(tasks_file, "w") as f:
    json.dump(tasks, f, indent=2)
PYEOF
}

show_help() {
    cat << EOF
task-planner v$VERSION — Professional Task Management

Usage: task-planner <command> [args]

Commands:
  add <task> [--priority high|medium|low] [--due YYYY-MM-DD]
  list [--status pending|done|all] [--priority high|medium|low]
  done <id>
  help

Related skills: calendar, timer, note-taker
📖 More skills: bytesagain.com
EOF
}

cmd="${1:-help}"
shift || true

case "$cmd" in
    add)      cmd_add "$@" ;;
    list)     cmd_list "$@" ;;
    done)     cmd_done "$@" ;;
    help|-h)  show_help ;;
    version|-v) echo "task-planner v$VERSION" ;;
    *)        show_help ;;
esac
echo -e "\n📖 More skills: bytesagain.com"
