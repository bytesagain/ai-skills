#!/usr/bin/env bash
# Agent Ops Framework — Multi-agent team orchestration
# Usage: bash ops.sh <command> [options]
set -euo pipefail

STATE_DIR="${OPS_STATE_DIR:-$HOME/.agent-ops}"
STATE_FILE="$STATE_DIR/state.json"
LOG_FILE="$STATE_DIR/ops.log"
ALERT_FILE="$STATE_DIR/alerts.log"

# ──────────── Helpers ────────────
timestamp() { date -u '+%Y-%m-%dT%H:%M:%SZ'; }
log() { echo "[$(timestamp)] $*" >> "$LOG_FILE"; }

ensure_state() {
    mkdir -p "$STATE_DIR"
    if [ ! -f "$STATE_FILE" ]; then
        echo "Error: No project initialized. Run: bash ops.sh init --project <name>" >&2
        exit 1
    fi
}

read_state() { cat "$STATE_FILE"; }

write_state() {
    local tmp="$STATE_FILE.tmp"
    cat > "$tmp"
    mv "$tmp" "$STATE_FILE"
}

# ──────────── INIT ────────────
cmd_init() {
    local project="default"
    while [ $# -gt 0 ]; do
        case "$1" in
            --project) project="$2"; shift 2;;
            --state-dir) STATE_DIR="$2"; STATE_FILE="$STATE_DIR/state.json"; LOG_FILE="$STATE_DIR/ops.log"; shift 2;;
            *) shift;;
        esac
    done
    mkdir -p "$STATE_DIR"
    if [ -f "$STATE_FILE" ]; then
        echo "Project already exists at $STATE_FILE"
        echo "Use --force to reinitialize"
        return 0
    fi
    python3 << PYEOF
import json
state = {
    "project": "$project",
    "created": "$(timestamp)",
    "agents": {},
    "tasks": {},
    "pipelines": {
        "default": ["backlog", "assigned", "in-progress", "review", "done", "deployed"]
    },
    "gates": {
        "review": {"requires": "deliverable_exists", "desc": "Output file/dir must exist"},
        "done": {"requires": "agent_approval", "approver_role": "reviewer"},
        "deployed": {"requires": "script_success", "desc": "Deploy script must exit 0"}
    },
    "quotas": {},
    "metrics": {
        "last_check": None,
        "alerts": []
    },
    "config": {
        "stale_hours": 24,
        "max_retries": 3,
        "alert_channels": ["file"]
    }
}
with open("$STATE_FILE", "w") as f:
    json.dump(state, f, indent=2)
PYEOF
    log "INIT project=$project state=$STATE_FILE"
    echo "✅ Project '$project' initialized at $STATE_FILE"
}

# ──────────── AGENT ────────────
cmd_agent() {
    ensure_state
    local subcmd="${1:-list}"; shift 2>/dev/null || true
    case "$subcmd" in
        add)
            local name="" role="" desc=""
            while [ $# -gt 0 ]; do
                case "$1" in
                    --name) name="$2"; shift 2;;
                    --role) role="$2"; shift 2;;
                    --desc) desc="$2"; shift 2;;
                    *) shift;;
                esac
            done
            [ -z "$name" ] && { echo "Error: --name required"; exit 1; }
            python3 << PYEOF
import json
with open("$STATE_FILE") as f: state = json.load(f)
state["agents"]["$name"] = {
    "role": "$role",
    "description": "$desc",
    "registered": "$(timestamp)",
    "last_active": None,
    "tasks_completed": 0,
    "tasks_failed": 0,
    "status": "idle"
}
with open("$STATE_FILE", "w") as f: json.dump(state, f, indent=2)
PYEOF
            log "AGENT ADD name=$name role=$role"
            echo "✅ Agent '$name' registered (role: $role)"
            ;;
        list)
            python3 << PYEOF
import json
with open("$STATE_FILE") as f: state = json.load(f)
agents = state.get("agents", {})
if not agents:
    print("No agents registered")
else:
    print("{:<12} {:<12} {:<8} {:<6} {:<20}".format("NAME", "ROLE", "STATUS", "DONE", "LAST ACTIVE"))
    print("-" * 60)
    for name, info in sorted(agents.items()):
        print("{:<12} {:<12} {:<8} {:<6} {:<20}".format(
            name,
            info.get("role", "?"),
            info.get("status", "?"),
            info.get("tasks_completed", 0),
            str(info.get("last_active", "never"))[:20]
        ))
PYEOF
            ;;
        remove)
            local name="$1"
            python3 -c "
import json
with open('$STATE_FILE') as f: state = json.load(f)
if '$name' in state['agents']:
    del state['agents']['$name']
    with open('$STATE_FILE', 'w') as f: json.dump(state, f, indent=2)
    print('Removed agent: $name')
else:
    print('Agent not found: $name')
"
            log "AGENT REMOVE name=$name"
            ;;
    esac
}

# ──────────── TASK ────────────
cmd_task() {
    ensure_state
    local subcmd="${1:-list}"; shift 2>/dev/null || true
    case "$subcmd" in
        add)
            local id="" title="" assign="" priority="medium" pipeline="default" tags=""
            while [ $# -gt 0 ]; do
                case "$1" in
                    --id) id="$2"; shift 2;;
                    --title) title="$2"; shift 2;;
                    --assign) assign="$2"; shift 2;;
                    --priority) priority="$2"; shift 2;;
                    --pipeline) pipeline="$2"; shift 2;;
                    --tags) tags="$2"; shift 2;;
                    *) shift;;
                esac
            done
            [ -z "$id" ] && { echo "Error: --id required"; exit 1; }
            [ -z "$title" ] && { echo "Error: --title required"; exit 1; }
            python3 << PYEOF
import json
with open("$STATE_FILE") as f: state = json.load(f)
if "$id" in state["tasks"]:
    print("Task $id already exists")
else:
    state["tasks"]["$id"] = {
        "title": "$title",
        "status": "backlog" if not "$assign" else "assigned",
        "assigned": "$assign" or None,
        "pipeline": "$pipeline",
        "priority": "$priority",
        "tags": "$tags".split(",") if "$tags" else [],
        "created": "$(timestamp)",
        "output": None,
        "retries": 0,
        "history": [
            {"status": "backlog" if not "$assign" else "assigned",
             "at": "$(timestamp)", "by": "orchestrator"}
        ]
    }
    if "$assign":
        a = state["agents"].get("$assign", {})
        a["status"] = "busy"
        a["last_active"] = "$(timestamp)"
    with open("$STATE_FILE", "w") as f: json.dump(state, f, indent=2)
    print("✅ Task $id created: $title")
PYEOF
            log "TASK ADD id=$id title=$title assign=$assign priority=$priority"
            ;;
        move)
            local id="" to="" output="" notes="" approved_by="" deploy_ref=""
            while [ $# -gt 0 ]; do
                case "$1" in
                    --id) id="$2"; shift 2;;
                    --to) to="$2"; shift 2;;
                    --output) output="$2"; shift 2;;
                    --notes) notes="$2"; shift 2;;
                    --approved-by) approved_by="$2"; shift 2;;
                    --deploy-ref) deploy_ref="$2"; shift 2;;
                    *) shift;;
                esac
            done
            python3 << PYEOF
import json, sys
with open("$STATE_FILE") as f: state = json.load(f)
task = state["tasks"].get("$id")
if not task:
    print("Task not found: $id"); sys.exit(1)

new_status = "$to"
old_status = task["status"]

# Gate checks
gates = state.get("gates", {})
gate = gates.get(new_status, {})
if gate:
    req = gate.get("requires", "")
    if req == "deliverable_exists" and "$output":
        import os
        if not os.path.exists("$output"):
            print("GATE FAIL: Output path does not exist: $output"); sys.exit(1)
    elif req == "agent_approval" and not "$approved_by":
        print("GATE FAIL: Requires --approved-by for '{}' transition".format(new_status)); sys.exit(1)

task["status"] = new_status
entry = {"status": new_status, "at": "$(timestamp)", "by": "$approved_by" or "agent"}
if "$output": entry["output"] = "$output"; task["output"] = "$output"
if "$notes": entry["notes"] = "$notes"
if "$deploy_ref": entry["deploy_ref"] = "$deploy_ref"
task["history"].append(entry)

# Update agent stats
if new_status == "done":
    agent = state["agents"].get(task.get("assigned", ""), {})
    agent["tasks_completed"] = agent.get("tasks_completed", 0) + 1
    agent["status"] = "idle"
    agent["last_active"] = "$(timestamp)"

with open("$STATE_FILE", "w") as f: json.dump(state, f, indent=2)
print("✅ Task $id: {} → {}".format(old_status, new_status))
PYEOF
            log "TASK MOVE id=$id to=$to"
            ;;
        list)
            local filter_status="" filter_agent=""
            while [ $# -gt 0 ]; do
                case "$1" in
                    --status) filter_status="$2"; shift 2;;
                    --agent) filter_agent="$2"; shift 2;;
                    *) shift;;
                esac
            done
            python3 << PYEOF
import json
with open("$STATE_FILE") as f: state = json.load(f)
tasks = state.get("tasks", {})
fs = "$filter_status"
fa = "$filter_agent"
print("{:<14} {:<10} {:<10} {:<8} {}".format("ID", "STATUS", "ASSIGNED", "PRIO", "TITLE"))
print("-" * 70)
for tid, t in sorted(tasks.items(), key=lambda x: {"critical":0,"high":1,"medium":2,"low":3}.get(x[1].get("priority","medium"),2)):
    if fs and t.get("status") != fs: continue
    if fa and t.get("assigned") != fa: continue
    print("{:<14} {:<10} {:<10} {:<8} {}".format(
        tid[:14], t.get("status","?")[:10], str(t.get("assigned",""))[:10],
        t.get("priority","med")[:8], t.get("title","")[:35]
    ))
count = len([t for t in tasks.values() if (not fs or t.get("status")==fs) and (not fa or t.get("assigned")==fa)])
print("\nTotal: {} tasks".format(count))
PYEOF
            ;;
        cancel)
            local id="$1"
            python3 -c "
import json
with open('$STATE_FILE') as f: state = json.load(f)
if '$id' in state['tasks']:
    state['tasks']['$id']['status'] = 'cancelled'
    state['tasks']['$id']['history'].append({'status':'cancelled','at':'$(timestamp)','by':'orchestrator'})
    with open('$STATE_FILE', 'w') as f: json.dump(state, f, indent=2)
    print('Task $id cancelled')
"
            log "TASK CANCEL id=$id"
            ;;
    esac
}

# ──────────── QUOTA ────────────
cmd_quota() {
    ensure_state
    local subcmd="${1:-check}"; shift 2>/dev/null || true
    case "$subcmd" in
        set)
            local name="" limit=0 period="daily"
            while [ $# -gt 0 ]; do
                case "$1" in
                    --name) name="$2"; shift 2;;
                    --limit) limit="$2"; shift 2;;
                    --period) period="$2"; shift 2;;
                    *) shift;;
                esac
            done
            python3 -c "
import json
with open('$STATE_FILE') as f: state = json.load(f)
state['quotas']['$name'] = {'limit': $limit, 'used': 0, 'period': '$period', 'reset_at': None}
with open('$STATE_FILE', 'w') as f: json.dump(state, f, indent=2)
print('Quota set: $name = $limit/$period')
"
            ;;
        use)
            local name="$1" amount="${2:-1}"
            python3 -c "
import json
with open('$STATE_FILE') as f: state = json.load(f)
q = state['quotas'].get('$name', {})
q['used'] = q.get('used', 0) + $amount
remaining = q.get('limit', 0) - q['used']
state['quotas']['$name'] = q
with open('$STATE_FILE', 'w') as f: json.dump(state, f, indent=2)
print('Quota $name: {}/{} (remaining: {})'.format(q['used'], q.get('limit',0), remaining))
if remaining <= 0: print('⚠️ QUOTA EXHAUSTED')
"
            ;;
        check)
            python3 << PYEOF
import json
with open("'$STATE_FILE'") as f: state = json.load(f)
quotas = state.get("quotas", {})
if not quotas:
    print("No quotas configured")
else:
    print("{:<20} {:<8} {:<8} {:<10} {}".format("NAME", "USED", "LIMIT", "REMAINING", "STATUS"))
    print("-" * 55)
    for name, q in sorted(quotas.items()):
        used = q.get("used", 0)
        limit = q.get("limit", 0)
        remaining = limit - used
        status = "✅" if remaining > limit * 0.2 else ("⚠️" if remaining > 0 else "🛑")
        print("{:<20} {:<8} {:<8} {:<10} {}".format(name, used, limit, remaining, status))
PYEOF
            ;;
    esac
}

# ──────────── DASHBOARD ────────────
cmd_dashboard() {
    ensure_state
    local fmt="${1:-text}"
    python3 << PYEOF
import json
with open("$STATE_FILE") as f: state = json.load(f)

tasks = state.get("tasks", {})
agents = state.get("agents", {})
quotas = state.get("quotas", {})
metrics = state.get("metrics", {})

# Count by status
status_counts = {}
for t in tasks.values():
    s = t.get("status", "?")
    status_counts[s] = status_counts.get(s, 0) + 1

print("=" * 60)
print("  {} — Dashboard".format(state.get("project", "Project")))
print("=" * 60)

print("\n📋 TASKS")
total = len(tasks)
for s in ["backlog", "assigned", "in-progress", "review", "done", "deployed", "cancelled", "rejected"]:
    c = status_counts.get(s, 0)
    if c > 0:
        bar = "█" * min(c, 30)
        print("  {:<14} {:>4}  {}".format(s, c, bar))
print("  {:<14} {:>4}".format("TOTAL", total))

print("\n🤖 AGENTS")
for name, info in sorted(agents.items()):
    print("  {:<12} {:<10} done:{:<4} fail:{}".format(
        name, info.get("status", "?"),
        info.get("tasks_completed", 0),
        info.get("tasks_failed", 0)
    ))

if quotas:
    print("\n📊 QUOTAS")
    for name, q in sorted(quotas.items()):
        used = q.get("used", 0)
        limit = q.get("limit", 0)
        pct = int(used / limit * 100) if limit > 0 else 0
        bar = "█" * (pct // 5) + "░" * (20 - pct // 5)
        status = "🛑" if pct >= 100 else ("⚠️" if pct >= 80 else "✅")
        print("  {:<20} {} {}/{} ({}%) {}".format(name, bar, used, limit, pct, status))

if metrics.get("alerts"):
    print("\n🚨 ALERTS")
    for a in metrics["alerts"][-5:]:
        print("  {} {}".format(a.get("at", "?"), a.get("msg", "?")))

print("")
PYEOF
}

# ──────────── MONITOR ────────────
cmd_monitor() {
    ensure_state
    python3 << PYEOF
import json, time
with open("$STATE_FILE") as f: state = json.load(f)

alerts = []
now = time.time()

# Check stale tasks
stale_hours = state.get("config", {}).get("stale_hours", 24)
for tid, t in state.get("tasks", {}).items():
    if t.get("status") in ("in-progress", "assigned"):
        last = t.get("history", [{}])[-1].get("at", "")
        if last:
            try:
                import datetime
                dt = datetime.datetime.strptime(last, "%Y-%m-%dT%H:%M:%SZ")
                age_hours = (now - dt.timestamp()) / 3600
                if age_hours > stale_hours:
                    alerts.append({"type": "stale", "task": tid, "hours": round(age_hours),
                                   "at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
                                   "msg": "Task {} stale for {}h (assigned to {})".format(tid, round(age_hours), t.get("assigned","?"))})
            except:
                pass

# Check quota exhaustion
for name, q in state.get("quotas", {}).items():
    used = q.get("used", 0)
    limit = q.get("limit", 0)
    if limit > 0 and used >= limit:
        alerts.append({"type": "quota", "quota": name,
                       "at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
                       "msg": "Quota {} exhausted ({}/{})".format(name, used, limit)})

# Check idle agents
for name, info in state.get("agents", {}).items():
    if info.get("status") == "idle":
        # Check if there are backlog tasks
        backlog = [t for t in state.get("tasks", {}).values() if t.get("status") == "backlog"]
        if backlog:
            alerts.append({"type": "idle", "agent": name,
                           "at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
                           "msg": "Agent {} idle but {} tasks in backlog".format(name, len(backlog))})

state["metrics"]["last_check"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
state["metrics"]["alerts"] = (state["metrics"].get("alerts", []) + alerts)[-50:]

with open("$STATE_FILE", "w") as f: json.dump(state, f, indent=2)

if alerts:
    print("🚨 {} alerts:".format(len(alerts)))
    for a in alerts:
        print("  - {}".format(a["msg"]))
    with open("$ALERT_FILE", "a") as f:
        for a in alerts:
            f.write("{} [{}] {}\n".format(a["at"], a["type"], a["msg"]))
else:
    print("✅ All clear")
PYEOF
    log "MONITOR check completed"
}

# ──────────── REPORT ────────────
cmd_report() {
    ensure_state
    python3 << PYEOF
import json
with open("$STATE_FILE") as f: state = json.load(f)

tasks = state.get("tasks", {})
agents = state.get("agents", {})

# Summary
total = len(tasks)
by_status = {}
for t in tasks.values():
    s = t.get("status", "?")
    by_status[s] = by_status.get(s, 0) + 1

deployed = by_status.get("deployed", 0)
done = by_status.get("done", 0)
in_progress = by_status.get("in-progress", 0)
backlog = by_status.get("backlog", 0)

print("📊 PROJECT REPORT: {}".format(state.get("project", "?")))
print("=" * 50)
print("")
print("Progress: {}/{} deployed ({:.0f}%)".format(deployed, total, deployed/total*100 if total else 0))
print("Pipeline: {} backlog → {} in-progress → {} review → {} done → {} deployed".format(
    backlog, in_progress, by_status.get("review", 0), done, deployed))
print("")

# Agent performance
print("Agent Performance:")
for name, info in sorted(agents.items()):
    completed = info.get("tasks_completed", 0)
    failed = info.get("tasks_failed", 0)
    total_a = completed + failed
    rate = completed / total_a * 100 if total_a else 0
    print("  {}: {}/{} tasks ({:.0f}% success)".format(name, completed, total_a, rate))

# Recent activity
print("\nRecent Activity:")
recent = []
for tid, t in tasks.items():
    for h in t.get("history", []):
        recent.append((h.get("at", ""), tid, h.get("status", "?"), h.get("by", "?")))
recent.sort(reverse=True)
for at, tid, status, by in recent[:10]:
    print("  {} {} → {} (by {})".format(at[:16], tid[:14], status, by))
PYEOF
}

# ──────────── HISTORY ────────────
cmd_history() {
    ensure_state
    local id="${1:-}"
    if [ -z "$id" ]; then
        echo "Usage: ops.sh history <task-id>"
        return 1
    fi
    python3 -c "
import json
with open('$STATE_FILE') as f: state = json.load(f)
t = state.get('tasks', {}).get('$id')
if not t:
    print('Task not found: $id')
else:
    print('Task: $id — {}'.format(t.get('title','')))
    print('Status: {} | Assigned: {} | Priority: {}'.format(t.get('status'), t.get('assigned'), t.get('priority')))
    print('')
    for h in t.get('history', []):
        print('  {} → {} (by {}) {}'.format(
            h.get('at','')[:16], h.get('status','?'),
            h.get('by','?'), h.get('notes','') or h.get('output','') or ''))
"
}

# ──────────── ROLLBACK ────────────
cmd_rollback() {
    ensure_state
    local id="${1:-}"
    [ -z "$id" ] && { echo "Usage: ops.sh rollback <task-id>"; return 1; }
    python3 -c "
import json
with open('$STATE_FILE') as f: state = json.load(f)
t = state.get('tasks', {}).get('$id')
if not t: print('Task not found'); exit(1)
if t.get('status') != 'deployed': print('Can only rollback deployed tasks'); exit(1)
t['status'] = 'rolled-back'
t['history'].append({'status':'rolled-back','at':'$(timestamp)','by':'orchestrator'})
with open('$STATE_FILE', 'w') as f: json.dump(state, f, indent=2)
print('⚠️ Task $id rolled back')
"
    log "ROLLBACK id=$id"
}

# ──────────── MAIN ────────────
# Fix STATE_FILE references in heredocs
fix_placeholder() {
    sed -i "s|'$STATE_FILE'|$STATE_FILE|g" /dev/stdin 2>/dev/null || true
}

cmd="${1:-help}"
shift 2>/dev/null || true

case "$cmd" in
    init) cmd_init "$@";;
    agent) cmd_agent "$@";;
    task) cmd_task "$@";;
    quota) cmd_quota "$@";;
    dashboard) cmd_dashboard "$@";;
    monitor) cmd_monitor "$@";;
    report) cmd_report "$@";;
    history) cmd_history "$@";;
    rollback) cmd_rollback "$@";;
    help|--help|-h)
        echo "Agent Ops Framework — Multi-agent team orchestration"
        echo ""
        echo "Usage: bash ops.sh <command> [options]"
        echo ""
        echo "Commands:"
        echo "  init          Initialize project state"
        echo "  agent         Manage agents (add/list/remove)"
        echo "  task          Manage tasks (add/list/move/cancel)"
        echo "  quota         Manage quotas (set/use/check)"
        echo "  dashboard     Show project dashboard"
        echo "  monitor       Run monitoring checks"
        echo "  report        Generate project report"
        echo "  history       View task history"
        echo "  rollback      Rollback deployed task"
        echo ""
        echo "State: $STATE_FILE"
        ;;
    *) echo "Unknown command: $cmd (try: bash ops.sh help)";;
esac
