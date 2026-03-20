#!/usr/bin/env bash
# task-planner - Terminal-based task management tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="3.0.1"
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

    python3 - "$TASKS_FILE" "$text" "$priority" "$due" "$created" << 'PYEOF'
import json, sys

tasks_file, text, priority, due, created = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]

with open(tasks_file) as f:
    tasks = json.load(f)

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
print(f"  Added task #{next_id}: {text} [{priority}]{due_str}")
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

    python3 - "$TASKS_FILE" "$status" "$priority" << 'PYEOF'
import json, sys

tasks_file, status_filter, priority_filter = sys.argv[1], sys.argv[2], sys.argv[3]

with open(tasks_file) as f:
    tasks = json.load(f)

if status_filter != "all":
    tasks = [t for t in tasks if t["status"] == status_filter]

if priority_filter:
    tasks = [t for t in tasks if t["priority"] == priority_filter]

if not tasks:
    print("  No tasks found.")
    sys.exit(0)

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
    marker = "✓" if t["status"] == "done" else " "
    print(f"  {tid}  {pri}  {status}  {due}  [{marker}] {t['text']}")
PYEOF
}

cmd_done() {
    local id="${1:-}"
    if [[ -z "$id" ]]; then
        echo "Error: task ID is required" >&2
        echo "Usage: task-planner done <id>" >&2
        exit 1
    fi

    python3 - "$TASKS_FILE" "$id" << 'PYEOF'
import json, sys

tasks_file, target_id = sys.argv[1], int(sys.argv[2])

with open(tasks_file) as f:
    tasks = json.load(f)

found = False
for t in tasks:
    if t["id"] == target_id:
        if t["status"] == "done":
            print(f"  Task #{target_id} is already done.")
            sys.exit(0)
        t["status"] = "done"
        found = True
        print(f"  Task #{target_id} marked as done: {t['text']}")
        break

if not found:
    print(f"  Error: task #{target_id} not found.", file=sys.stderr)
    sys.exit(1)

with open(tasks_file, "w") as f:
    json.dump(tasks, f, indent=2)
PYEOF
}

cmd_remove() {
    local id="${1:-}"
    if [[ -z "$id" ]]; then
        echo "Error: task ID is required" >&2
        echo "Usage: task-planner remove <id>" >&2
        exit 1
    fi

    python3 - "$TASKS_FILE" "$id" << 'PYEOF'
import json, sys

tasks_file, target_id = sys.argv[1], int(sys.argv[2])

with open(tasks_file) as f:
    tasks = json.load(f)

new_tasks = [t for t in tasks if t["id"] != target_id]

if len(new_tasks) == len(tasks):
    print(f"  Error: task #{target_id} not found.", file=sys.stderr)
    sys.exit(1)

removed = [t for t in tasks if t["id"] == target_id][0]
print(f"  Removed task #{target_id}: {removed['text']}")

with open(tasks_file, "w") as f:
    json.dump(new_tasks, f, indent=2)
PYEOF
}

cmd_edit() {
    local id="${1:-}"
    local field="${2:-}"
    local value="${3:-}"

    if [[ -z "$id" || -z "$field" || -z "$value" ]]; then
        echo "Error: id, field, and value are all required" >&2
        echo "Usage: task-planner edit <id> <field> <value>" >&2
        exit 1
    fi

    case "$field" in
        text|priority|due|status) ;;
        *)
            echo "Error: field must be one of: text, priority, due, status" >&2
            exit 1
            ;;
    esac

    if [[ "$field" == "priority" ]]; then
        case "$value" in
            high|medium|low) ;;
            *)
                echo "Error: priority must be high, medium, or low" >&2
                exit 1
                ;;
        esac
    fi

    if [[ "$field" == "status" ]]; then
        case "$value" in
            pending|done) ;;
            *)
                echo "Error: status must be pending or done" >&2
                exit 1
                ;;
        esac
    fi

    python3 - "$TASKS_FILE" "$id" "$field" "$value" << 'PYEOF'
import json, sys

tasks_file, target_id, field, value = sys.argv[1], int(sys.argv[2]), sys.argv[3], sys.argv[4]

with open(tasks_file) as f:
    tasks = json.load(f)

found = False
for t in tasks:
    if t["id"] == target_id:
        old_value = t.get(field, "")
        t[field] = value
        found = True
        print(f"  Task #{target_id}: {field} changed from '{old_value}' to '{value}'")
        break

if not found:
    print(f"  Error: task #{target_id} not found.", file=sys.stderr)
    sys.exit(1)

with open(tasks_file, "w") as f:
    json.dump(tasks, f, indent=2)
PYEOF
}

cmd_search() {
    local keyword="${1:-}"
    if [[ -z "$keyword" ]]; then
        echo "Error: search keyword is required" >&2
        echo "Usage: task-planner search <keyword>" >&2
        exit 1
    fi

    python3 - "$TASKS_FILE" "$keyword" << 'PYEOF'
import json, sys

tasks_file, keyword = sys.argv[1], sys.argv[2]
keyword_lower = keyword.lower()

with open(tasks_file) as f:
    tasks = json.load(f)

matches = [t for t in tasks if keyword_lower in t["text"].lower()]

if not matches:
    print(f"  No tasks matching '{keyword}'.")
    sys.exit(0)

print(f"  Found {len(matches)} task(s) matching '{keyword}':")
print()
for t in matches:
    status_mark = "✓" if t["status"] == "done" else "○"
    due = f" (due: {t['due']})" if t.get("due") else ""
    print(f"  {status_mark} #{t['id']} [{t['priority']}] {t['text']}{due}")
PYEOF
}

cmd_today() {
    local today
    today="$(date +%Y-%m-%d)"

    python3 - "$TASKS_FILE" "$today" << 'PYEOF'
import json, sys

tasks_file, today = sys.argv[1], sys.argv[2]

with open(tasks_file) as f:
    tasks = json.load(f)

due_today = [t for t in tasks if t.get("due") == today and t["status"] == "pending"]

print(f"  Tasks due today ({today}):")
print()

if not due_today:
    print("  Nothing due today.")
    sys.exit(0)

for t in due_today:
    print(f"  ○ #{t['id']} [{t['priority']}] {t['text']}")
PYEOF
}

cmd_overdue() {
    local today
    today="$(date +%Y-%m-%d)"

    python3 - "$TASKS_FILE" "$today" << 'PYEOF'
import json, sys

tasks_file, today = sys.argv[1], sys.argv[2]

with open(tasks_file) as f:
    tasks = json.load(f)

overdue = [t for t in tasks if t.get("due") and t["due"] < today and t["status"] == "pending"]

print("  Overdue tasks:")
print()

if not overdue:
    print("  No overdue tasks.")
    sys.exit(0)

overdue.sort(key=lambda t: t["due"])

for t in overdue:
    print(f"  ⚠ #{t['id']} [{t['priority']}] {t['text']} (due: {t['due']})")
PYEOF
}

cmd_stats() {
    python3 - "$TASKS_FILE" << 'PYEOF'
import json, sys

tasks_file = sys.argv[1]

with open(tasks_file) as f:
    tasks = json.load(f)

total = len(tasks)
done_count = sum(1 for t in tasks if t["status"] == "done")
pending_count = total - done_count

high = sum(1 for t in tasks if t["priority"] == "high")
medium = sum(1 for t in tasks if t["priority"] == "medium")
low = sum(1 for t in tasks if t["priority"] == "low")

rate = (done_count / total * 100) if total > 0 else 0

print("  Task Statistics")
print("  ═══════════════")
print(f"  Total:      {total}")
print(f"  Pending:    {pending_count}")
print(f"  Completed:  {done_count}")
print(f"  Rate:       {rate:.1f}%")
print()
print("  By Priority")
print("  ───────────")
print(f"  High:       {high}")
print(f"  Medium:     {medium}")
print(f"  Low:        {low}")
PYEOF
}

cmd_export() {
    local format="${1:-}"
    if [[ -z "$format" ]]; then
        echo "Error: export format is required" >&2
        echo "Usage: task-planner export <format>  (json|csv|txt)" >&2
        exit 1
    fi

    case "$format" in
        json|csv|txt) ;;
        *)
            echo "Error: unsupported format '$format'. Use json, csv, or txt." >&2
            exit 1
            ;;
    esac

    python3 - "$TASKS_FILE" "$format" << 'PYEOF'
import json, sys, csv, io

tasks_file, fmt = sys.argv[1], sys.argv[2]

with open(tasks_file) as f:
    tasks = json.load(f)

if not tasks:
    print("  No tasks to export.", file=sys.stderr)
    sys.exit(0)

if fmt == "json":
    print(json.dumps(tasks, indent=2))

elif fmt == "csv":
    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(["id", "text", "priority", "status", "due", "created"])
    for t in tasks:
        writer.writerow([
            t["id"], t["text"], t["priority"],
            t["status"], t.get("due", ""), t.get("created", "")
        ])
    print(output.getvalue(), end="")

elif fmt == "txt":
    for t in tasks:
        mark = "✓" if t["status"] == "done" else "○"
        due = f" (due: {t['due']})" if t.get("due") else ""
        print(f"{mark} #{t['id']} [{t['priority']}] {t['text']}{due}")
PYEOF
}

show_help() {
    cat << EOF
task-planner v$VERSION — Terminal-based task management

Usage: task-planner <command> [args]

Commands:
  add <task> [--priority high|medium|low] [--due YYYY-MM-DD]
      Add a new task

  list [--status pending|done|all] [--priority high|medium|low]
      List tasks with optional filters (default: pending)

  done <id>
      Mark a task as completed

  remove <id>
      Delete a task permanently

  edit <id> <field> <value>
      Modify a task field (text, priority, due, status)

  search <keyword>
      Search tasks by keyword (case-insensitive)

  today
      Show tasks due today

  overdue
      Show pending tasks past their due date

  stats
      Display task statistics and priority breakdown

  export <format>
      Export tasks (json, csv, or txt)

  help
      Show this help message

  version
      Print version

Data directory: $DATA_DIR

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

# ─── Main dispatch ──────────────────────────────────────────────────

cmd="${1:-help}"
shift || true

case "$cmd" in
    add)      cmd_add "$@" ;;
    list)     cmd_list "$@" ;;
    done)     cmd_done "$@" ;;
    remove)   cmd_remove "$@" ;;
    edit)     cmd_edit "$@" ;;
    search)   cmd_search "$@" ;;
    today)    cmd_today "$@" ;;
    overdue)  cmd_overdue "$@" ;;
    stats)    cmd_stats "$@" ;;
    export)   cmd_export "$@" ;;
    help|-h)  show_help ;;
    version|-v) echo "task-planner v$VERSION" ;;
    *)
        echo "Error: unknown command '$cmd'" >&2
        echo "Run 'task-planner help' for usage." >&2
        exit 1
        ;;
esac
