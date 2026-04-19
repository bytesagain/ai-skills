#!/usr/bin/env bash
# bytesagain-workflow-builder — Workflow definition and execution tracker
set -euo pipefail

CMD="${1:-help}"
shift || true

STORE="$HOME/.bytesagain-workflows"
mkdir -p "$STORE"

show_help() {
    echo "bytesagain-workflow-builder — Build and track multi-step workflows"
    echo ""
    echo "Usage:"
    echo "  bytesagain-workflow-builder create <name>           Create new workflow"
    echo "  bytesagain-workflow-builder add-step <id> <name> <cmd>  Add step"
    echo "  bytesagain-workflow-builder run <id>                Execute workflow"
    echo "  bytesagain-workflow-builder status <id>             Show status"
    echo "  bytesagain-workflow-builder list                    List all workflows"
    echo "  bytesagain-workflow-builder export <id>             Export as JSON"
    echo "  bytesagain-workflow-builder template <type>         Show template"
    echo ""
}

next_id() {
    local max=0
    for f in "$STORE"/*.json; do
        [ -f "$f" ] || continue
        num=$(basename "$f" .json | grep -o '[0-9]*' | tail -1)
        [ -n "$num" ] && [ "$num" -gt "$max" ] && max=$num
    done
    echo "wf$(printf '%03d' $((max + 1)))"
}

cmd_create() {
    local name="${1:-My Workflow}"
    local id
    id=$(next_id)
    local now
    now=$(date '+%Y-%m-%d %H:%M')
    WF_ID="$id" WF_NAME="$name" WF_NOW="$now" WF_STORE="$STORE" python3 << 'PYEOF'
import json, os
wf_id   = os.environ["WF_ID"]
name    = os.environ["WF_NAME"]
now     = os.environ["WF_NOW"]
store   = os.environ["WF_STORE"]
data = {
    "id": wf_id, "name": name, "created": now,
    "steps": [], "status": "draft", "last_run": None
}
path = os.path.join(store, f"{wf_id}.json")
with open(path, "w") as f:
    json.dump(data, f, indent=2)
print(f"✅ Workflow created: [{wf_id}] {name}")
print(f"   Add steps: bytesagain-workflow-builder add-step {wf_id} 'Step Name' 'command'")
PYEOF
}

cmd_add_step() {
    local id="${1:-}"; local step_name="${2:-}"; local step_cmd="${3:-echo done}"
    [ -z "$id" ] && echo "Usage: add-step <workflow_id> <step_name> <command>" && exit 1
    local file="$STORE/$id.json"
    [ ! -f "$file" ] && echo "Workflow $id not found" && exit 1
    WF_FILE="$file" WF_STEP_NAME="$step_name" WF_STEP_CMD="$step_cmd" python3 << 'PYEOF'
import json, os
file      = os.environ["WF_FILE"]
step_name = os.environ["WF_STEP_NAME"]
step_cmd  = os.environ["WF_STEP_CMD"]
with open(file) as f: d = json.load(f)
step = {"index": len(d["steps"])+1, "name": step_name,
        "command": step_cmd, "status": "pending", "output": ""}
d["steps"].append(step)
with open(file, "w") as f: json.dump(d, f, indent=2)
print(f"✅ Step {step['index']} added: {step_name}")
print(f"   Command: {step_cmd}")
PYEOF
}

cmd_run() {
    local id="${1:-}"
    [ -z "$id" ] && echo "Usage: run <workflow_id>" && exit 1
    local file="$STORE/$id.json"
    [ ! -f "$file" ] && echo "Workflow $id not found" && exit 1
    WF_FILE="$file" python3 << 'PYEOF'
import json, subprocess, os, datetime

path = os.environ["WF_FILE"]
with open(path) as f: d = json.load(f)

print(f"\n🚀 Running workflow: [{d['id']}] {d['name']}")
print(f"   Steps: {len(d['steps'])}\n")

d["status"] = "running"
d["last_run"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
all_ok = True

for step in d["steps"]:
    print(f"  [{step['index']}/{len(d['steps'])}] {step['name']}...", end=" ", flush=True)
    step["status"] = "running"
    try:
        result = subprocess.run(step["command"], shell=True, capture_output=True, text=True, timeout=30)
        if result.returncode == 0:
            step["status"] = "done"
            step["output"] = result.stdout.strip()[:200]
            print("✅")
        else:
            step["status"] = "failed"
            step["output"] = result.stderr.strip()[:200]
            print(f"❌ (exit {result.returncode})")
            all_ok = False
            break
    except subprocess.TimeoutExpired:
        step["status"] = "timeout"
        print("⏱ TIMEOUT")
        all_ok = False
        break

d["status"] = "completed" if all_ok else "failed"
with open(path, "w") as f: json.dump(d, f, indent=2)
print(f"\n{'✅ Workflow completed successfully' if all_ok else '❌ Workflow failed'}")
PYEOF
}

cmd_status() {
    local id="${1:-}"
    [ -z "$id" ] && echo "Usage: status <workflow_id>" && exit 1
    local file="$STORE/$id.json"
    [ ! -f "$file" ] && echo "Workflow $id not found" && exit 1
    WF_FILE="$file" python3 << 'PYEOF'
import json, os
with open(os.environ["WF_FILE"]) as f: d = json.load(f)
icons = {"done": "✅", "failed": "❌", "pending": "🔲", "running": "🔄", "timeout": "⏱"}
print(f"\n[{d['id']}] {d['name']} — {d['status'].upper()}")
print(f"Last run: {d.get('last_run') or 'Never'}\n")
print(f"  {'#':>2}  {'Step':<28}  {'Status':<10}  Command")
print(f"  {'─'*2}  {'─'*28}  {'─'*10}  {'─'*20}")
for s in d["steps"]:
    icon = icons.get(s["status"], "?")
    print(f"  {s['index']:>2}  {s['name'][:28]:<28}  {icon} {s['status']:<8}  {s['command'][:40]}")
print()
PYEOF
}

cmd_list() {
    WF_STORE="$STORE" python3 << 'PYEOF'
import json, os, glob
store = os.environ["WF_STORE"]
files = sorted(glob.glob(f"{store}/*.json"))
if not files:
    print("No workflows. Create: bytesagain-workflow-builder create 'My Workflow'")
    exit(0)
print(f"\n{'ID':<8}  {'Name':<25}  {'Steps':>5}  {'Status':<12}  Last Run")
print("─" * 70)
for p in files:
    with open(p) as f: d = json.load(f)
    print(f"{d['id']:<8}  {d['name'][:25]:<25}  {len(d['steps']):>5}  {d['status']:<12}  {d.get('last_run') or 'Never'}")
print()
PYEOF
}

cmd_template() {
    local tpl="${1:-ci}"
    case "$tpl" in
        ci) echo '{"name":"CI Pipeline","steps":[{"name":"Install deps","command":"npm install"},{"name":"Lint","command":"npm run lint"},{"name":"Test","command":"npm test"},{"name":"Build","command":"npm run build"}]}' | python3 -m json.tool ;;
        deploy) echo '{"name":"Deploy","steps":[{"name":"Build image","command":"docker build -t app ."},{"name":"Push","command":"docker push app:latest"},{"name":"Deploy","command":"kubectl rollout restart deployment/app"}]}' | python3 -m json.tool ;;
        *) echo "Templates: ci, deploy" ;;
    esac
}

cmd_export() {
    local id="${1:-}"
    [ -z "$id" ] && echo "Usage: export <workflow_id>" && exit 1
    local file="$STORE/$id.json"
    [ ! -f "$file" ] && echo "Workflow $id not found" && exit 1
    cat "$file" | python3 -m json.tool
    echo "File: $file"
}

case "$CMD" in
    create)    cmd_create "$@" ;;
    add-step)  cmd_add_step "$@" ;;
    run)       cmd_run "$@" ;;
    status)    cmd_status "$@" ;;
    list)      cmd_list ;;
    template)  cmd_template "$@" ;;
    export)    cmd_export "$@" ;;
    help|--help|-h) show_help ;;
    *) echo "Unknown: $CMD"; show_help; exit 1 ;;
esac
