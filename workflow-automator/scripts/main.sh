#!/usr/bin/env bash
# Workflow Automator — OpenClaw-native workflow automation engine
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

CMD="${1:-help}"
if [ $# -gt 0 ]; then shift; fi

WF_HOME="${HOME}/.workflow-automator"
WF_DIR="${WF_HOME}/workflows"
LOG_DIR="${WF_HOME}/logs"
HIST_FILE="${WF_HOME}/history.log"

ensure_dirs() {
    mkdir -p "$WF_DIR" "$LOG_DIR"
    touch "$HIST_FILE"
}

show_help() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════╗
║  Workflow Automator — Native Workflow Engine            ║
║  Powered by BytesAgain                                  ║
╚══════════════════════════════════════════════════════════╝

Usage: bash main.sh <command> [options]

Commands:
  init         Create a new workflow project with example files
  run          Execute a workflow file step by step
  validate     Check workflow file syntax
  list         List all workflows
  status       Show last run status for a workflow
  log          View run logs
  schedule     Set up cron-based scheduling
  template     Generate workflow templates (backup/deploy/monitor/report)
  export       Export workflow as portable script
  history      View execution history

Workflow file format (.wf):
  # name: my-workflow
  # description: What it does
  step.1.name=check-disk
  step.1.run=df -h
  step.2.name=backup
  step.2.run=tar czf /tmp/backup.tar.gz /data
  step.3.name=notify
  step.3.run=echo "All done"

Examples:
  bash main.sh init myproject
  bash main.sh run myproject/main.wf
  bash main.sh template backup
  bash main.sh schedule myproject/main.wf --cron "0 2 * * *"
  bash main.sh history --limit 10

EOF
}

# ──── INIT ────
cmd_init() {
    local name="${1:-my-workflow}"
    local proj_dir="$WF_DIR/$name"

    if [ -d "$proj_dir" ]; then
        echo "Error: Project '$name' already exists at $proj_dir"
        exit 1
    fi

    mkdir -p "$proj_dir"
    cat > "$proj_dir/main.wf" << 'WFEOF'
# name: main
# description: Example workflow
step.1.name=hello
step.1.run=echo "Hello from Workflow Automator!"
step.2.name=system-info
step.2.run=uname -a
step.3.name=disk-check
step.3.run=df -h | head -5
WFEOF

    echo "✅ Project '$name' created at $proj_dir"
    echo "   Main workflow: $proj_dir/main.wf"
    echo ""
    echo "   Next: bash main.sh run $name/main.wf"
}

# ──── VALIDATE ────
cmd_validate() {
    local wf_file="$1"
    [ -z "$wf_file" ] && { echo "Error: specify workflow file"; exit 1; }

    # Resolve path
    if [ ! -f "$wf_file" ] && [ -f "$WF_DIR/$wf_file" ]; then
        wf_file="$WF_DIR/$wf_file"
    fi
    [ ! -f "$wf_file" ] && { echo "Error: File not found: $wf_file"; exit 1; }

    local errors=0
    local steps=0
    local name=""

    # Check header
    name=$(grep "^# name:" "$wf_file" 2>/dev/null | head -1 | sed 's/^# name:[[:space:]]*//')
    [ -z "$name" ] && { echo "⚠️  Warning: Missing '# name:' header"; }

    # Check steps
    local max_step=0
    while IFS='=' read -r key val; do
        [ -z "$key" ] && continue
        echo "$key" | grep -q "^#" && continue
        echo "$key" | grep -q "^[[:space:]]*$" && continue

        if echo "$key" | grep -qE "^step\.[0-9]+\.name$"; then
            local num=$(echo "$key" | sed 's/step\.\([0-9]*\)\..*/\1/')
            [ "$num" -gt "$max_step" ] && max_step="$num"
            steps=$((steps + 1))
        elif echo "$key" | grep -qE "^step\.[0-9]+\.run$"; then
            [ -z "$val" ] && { echo "❌ $key has empty command"; errors=$((errors+1)); }
        elif ! echo "$key" | grep -qE "^step\.[0-9]+\.(name|run|on_fail|condition)$"; then
            echo "⚠️  Unknown key: $key"
        fi
    done < "$wf_file"

    # Check each step has both name and run
    for i in $(seq 1 $max_step); do
        grep -q "^step\.${i}\.name=" "$wf_file" || { echo "❌ step.$i.name missing"; errors=$((errors+1)); }
        grep -q "^step\.${i}\.run=" "$wf_file" || { echo "❌ step.$i.run missing"; errors=$((errors+1)); }
    done

    if [ "$errors" -eq 0 ]; then
        echo "✅ Valid workflow: ${name:-unnamed} ($steps steps)"
    else
        echo "❌ Found $errors errors"
        exit 1
    fi
}

# ──── RUN ────
cmd_run() {
    local wf_file="$1"
    [ -z "$wf_file" ] && { echo "Error: specify workflow file"; exit 1; }

    if [ ! -f "$wf_file" ] && [ -f "$WF_DIR/$wf_file" ]; then
        wf_file="$WF_DIR/$wf_file"
    fi
    [ ! -f "$wf_file" ] && { echo "Error: File not found: $wf_file"; exit 1; }

    local wf_name=$(grep "^# name:" "$wf_file" 2>/dev/null | head -1 | sed 's/^# name:[[:space:]]*//')
    [ -z "$wf_name" ] && wf_name=$(basename "$wf_file" .wf)

    local run_id=$(date +%Y%m%d_%H%M%S)_$$
    local log_file="$LOG_DIR/${wf_name}_${run_id}.log"

    echo "═══════════════════════════════════════"
    echo "  Running: $wf_name"
    echo "  Run ID:  $run_id"
    echo "═══════════════════════════════════════"
    echo ""

    # Record start
    echo "[$run_id] START $(date '+%Y-%m-%d %H:%M:%S') $wf_name $wf_file" >> "$HIST_FILE"
    echo "[$run_id] Workflow: $wf_name" > "$log_file"
    echo "[$run_id] Started: $(date '+%Y-%m-%d %H:%M:%S')" >> "$log_file"
    echo "" >> "$log_file"

    # Find max step number
    local max_step=$(grep -oE "^step\.[0-9]+" "$wf_file" | sed 's/step\.//' | sort -n | tail -1)
    [ -z "$max_step" ] && { echo "Error: No steps found"; exit 1; }

    local passed=0
    local failed=0
    local total=0

    for i in $(seq 1 "$max_step"); do
        local step_name=$(grep "^step\.${i}\.name=" "$wf_file" | head -1 | cut -d= -f2-)
        local step_run=$(grep "^step\.${i}\.run=" "$wf_file" | head -1 | cut -d= -f2-)
        local step_condition=$(grep "^step\.${i}\.condition=" "$wf_file" | head -1 | cut -d= -f2-)
        local step_on_fail=$(grep "^step\.${i}\.on_fail=" "$wf_file" | head -1 | cut -d= -f2-)

        [ -z "$step_name" ] && continue
        [ -z "$step_run" ] && continue
        total=$((total + 1))

        # Check condition if present
        if [ -n "$step_condition" ]; then
            if ! eval "$step_condition" >/dev/null 2>&1; then
                echo "  ⏭️  Step $i: $step_name (skipped — condition not met)"
                echo "[$run_id] SKIP step.$i $step_name (condition: $step_condition)" >> "$log_file"
                continue
            fi
        fi

        echo -n "  ▶️  Step $i: $step_name ... "
        echo "[$run_id] RUN step.$i $step_name: $step_run" >> "$log_file"

        local start_ts=$(date +%s)
        local output
        output=$(eval "$step_run" 2>&1) && local rc=0 || local rc=$?
        local end_ts=$(date +%s)
        local elapsed=$((end_ts - start_ts))

        echo "$output" >> "$log_file"

        if [ "$rc" -eq 0 ]; then
            echo "✅ (${elapsed}s)"
            echo "[$run_id] OK step.$i ${elapsed}s" >> "$log_file"
            passed=$((passed + 1))
        else
            echo "❌ (exit $rc, ${elapsed}s)"
            echo "[$run_id] FAIL step.$i rc=$rc ${elapsed}s" >> "$log_file"
            failed=$((failed + 1))

            if [ "$step_on_fail" = "stop" ]; then
                echo "  🛑 Stopping (on_fail=stop)"
                echo "[$run_id] STOPPED at step.$i" >> "$log_file"
                break
            elif [ "$step_on_fail" = "skip" ]; then
                echo "  ⏭️  Continuing (on_fail=skip)"
            else
                # Default: continue
                echo "  ⚠️  Continuing..."
            fi
        fi

        # Show truncated output
        if [ -n "$output" ]; then
            echo "$output" | head -3 | sed 's/^/     /'
            local lines=$(echo "$output" | wc -l)
            [ "$lines" -gt 3 ] && echo "     ... ($lines lines total)"
        fi
        echo ""
    done

    # Summary
    echo "═══════════════════════════════════════"
    local status="SUCCESS"
    [ "$failed" -gt 0 ] && status="PARTIAL"
    [ "$passed" -eq 0 ] && status="FAILED"
    echo "  Result: $status ($passed/$total passed, $failed failed)"
    echo "  Log:    $log_file"
    echo "═══════════════════════════════════════"

    echo "[$run_id] END $(date '+%Y-%m-%d %H:%M:%S') $status passed=$passed failed=$failed total=$total" >> "$HIST_FILE"
    echo "" >> "$log_file"
    echo "Result: $status ($passed/$total passed)" >> "$log_file"
}

# ──── LIST ────
cmd_list() {
    ensure_dirs
    echo "═══════════════════════════════════════"
    echo "  Workflows"
    echo "═══════════════════════════════════════"
    echo ""

    local count=0
    for proj in "$WF_DIR"/*/; do
        [ ! -d "$proj" ] && continue
        local proj_name=$(basename "$proj")
        echo "  📁 $proj_name/"
        for wf in "$proj"*.wf; do
            [ ! -f "$wf" ] && continue
            local wf_name=$(grep "^# name:" "$wf" 2>/dev/null | head -1 | sed 's/^# name:[[:space:]]*//')
            local steps=$(grep -c "^step\.[0-9]*\.name=" "$wf" 2>/dev/null || echo 0)
            local desc=$(grep "^# description:" "$wf" 2>/dev/null | head -1 | sed 's/^# description:[[:space:]]*//')
            echo "     $(basename "$wf") — ${wf_name:-unnamed} ($steps steps)"
            [ -n "$desc" ] && echo "       $desc"
            count=$((count + 1))
        done
        echo ""
    done

    [ "$count" -eq 0 ] && echo "  No workflows yet. Run: bash main.sh init myproject"
    echo "  Total: $count workflow(s)"
}

# ──── STATUS ────
cmd_status() {
    local wf_name="${1:-}"
    ensure_dirs

    echo "═══════════════════════════════════════"
    echo "  Status${wf_name:+ — $wf_name}"
    echo "═══════════════════════════════════════"
    echo ""

    if [ -n "$wf_name" ]; then
        grep "$wf_name" "$HIST_FILE" 2>/dev/null | tail -5 | while read -r line; do
            echo "  $line"
        done
    else
        echo "  Last 10 runs:"
        tail -10 "$HIST_FILE" 2>/dev/null | while read -r line; do
            echo "  $line"
        done
    fi
    [ ! -s "$HIST_FILE" ] && echo "  No runs yet."
}

# ──── LOG ────
cmd_log() {
    local target="${1:-}"
    ensure_dirs

    if [ -n "$target" ] && [ -f "$target" ]; then
        cat "$target"
    elif [ -n "$target" ] && [ -f "$LOG_DIR/$target" ]; then
        cat "$LOG_DIR/$target"
    else
        echo "═══════════════════════════════════════"
        echo "  Recent Logs"
        echo "═══════════════════════════════════════"
        echo ""
        local latest=$(ls -t "$LOG_DIR"/*.log 2>/dev/null | head -1)
        if [ -n "$latest" ]; then
            echo "  Latest: $(basename "$latest")"
            echo "  ─────────────────────────────────"
            cat "$latest" | sed 's/^/  /'
        else
            echo "  No logs yet. Run a workflow first."
        fi
    fi
}

# ──── SCHEDULE ────
cmd_schedule() {
    local wf_file=""
    local cron_expr=""

    while [ $# -gt 0 ]; do
        case "$1" in
            --cron) cron_expr="$2"; shift 2;;
            --remove)
                echo "Removing scheduled workflows..."
                crontab -l 2>/dev/null | grep -v "workflow-automator" | crontab -
                echo "✅ All workflow schedules removed"
                return
                ;;
            *) wf_file="$1"; shift;;
        esac
    done

    [ -z "$wf_file" ] && { echo "Error: specify workflow file"; exit 1; }

    if [ ! -f "$wf_file" ] && [ -f "$WF_DIR/$wf_file" ]; then
        wf_file="$WF_DIR/$wf_file"
    fi
    [ ! -f "$wf_file" ] && { echo "Error: File not found: $wf_file"; exit 1; }

    local abs_path=$(realpath "$wf_file")
    local script_path=$(realpath "$0")

    if [ -z "$cron_expr" ]; then
        echo "Current schedules:"
        crontab -l 2>/dev/null | grep "workflow-automator" | sed 's/^/  /' || echo "  None"
        echo ""
        echo "Usage: bash main.sh schedule workflow.wf --cron '0 * * * *'"
        return
    fi

    local cron_line="$cron_expr /bin/bash $script_path run $abs_path >> $LOG_DIR/cron.log 2>&1"

    (crontab -l 2>/dev/null; echo "$cron_line") | crontab -
    echo "✅ Scheduled: $cron_expr"
    echo "   Workflow: $abs_path"
    echo "   Log: $LOG_DIR/cron.log"
}

# ──── TEMPLATE ────
cmd_template() {
    local tpl="${1:-}"
    ensure_dirs

    case "$tpl" in
        backup)
            local out="$WF_DIR/backup-template.wf"
            cat > "$out" << 'TEOF'
# name: daily-backup
# description: Automated backup workflow
step.1.name=check-space
step.1.run=df -h / | tail -1
step.2.name=create-backup
step.2.run=tar czf /tmp/backup_$(date +%Y%m%d).tar.gz --exclude=node_modules --exclude=.git .
step.2.on_fail=stop
step.3.name=verify-backup
step.3.run=ls -lh /tmp/backup_$(date +%Y%m%d).tar.gz
step.4.name=cleanup-old
step.4.run=find /tmp -name "backup_*.tar.gz" -mtime +7 -delete 2>/dev/null; echo "Old backups cleaned"
TEOF
            echo "✅ Template 'backup' created: $out"
            ;;
        deploy)
            local out="$WF_DIR/deploy-template.wf"
            cat > "$out" << 'TEOF'
# name: deploy
# description: Application deployment workflow
step.1.name=pull-latest
step.1.run=git pull origin main
step.1.on_fail=stop
step.2.name=install-deps
step.2.run=npm install --production 2>/dev/null || pip install -r requirements.txt 2>/dev/null || echo "No deps to install"
step.3.name=run-tests
step.3.run=npm test 2>/dev/null || python -m pytest 2>/dev/null || echo "No tests configured"
step.4.name=restart-service
step.4.run=echo "TODO: Add your restart command (e.g., pm2 restart app / systemctl restart myapp)"
step.5.name=health-check
step.5.run=curl -sf http://localhost:3000/health || echo "Health check endpoint not configured"
TEOF
            echo "✅ Template 'deploy' created: $out"
            ;;
        monitor)
            local out="$WF_DIR/monitor-template.wf"
            cat > "$out" << 'TEOF'
# name: system-monitor
# description: System health monitoring workflow
step.1.name=cpu-check
step.1.run=top -bn1 | head -5
step.2.name=memory-check
step.2.run=free -h
step.3.name=disk-check
step.3.run=df -h | grep -E "/$|/home"
step.4.name=process-check
step.4.run=ps aux --sort=-%mem | head -10
step.5.name=network-check
step.5.run=ss -tuln | head -10
TEOF
            echo "✅ Template 'monitor' created: $out"
            ;;
        report)
            local out="$WF_DIR/report-template.wf"
            cat > "$out" << 'TEOF'
# name: daily-report
# description: Generate daily status report
step.1.name=header
step.1.run=echo "=== Daily Report $(date '+%Y-%m-%d') ==="
step.2.name=uptime
step.2.run=uptime
step.3.name=disk-usage
step.3.run=df -h / | tail -1
step.4.name=recent-errors
step.4.run=journalctl --since "24 hours ago" -p err --no-pager 2>/dev/null | tail -10 || echo "No journal access"
step.5.name=summary
step.5.run=echo "=== End of Report ==="
TEOF
            echo "✅ Template 'report' created: $out"
            ;;
        "")
            echo "Available templates:"
            echo "  backup   — Automated backup workflow"
            echo "  deploy   — Application deployment"
            echo "  monitor  — System health monitoring"
            echo "  report   — Daily status report"
            echo ""
            echo "Usage: bash main.sh template <name>"
            ;;
        *)
            echo "Error: Unknown template '$tpl'"
            echo "Available: backup, deploy, monitor, report"
            exit 1
            ;;
    esac
}

# ──── EXPORT ────
cmd_export() {
    local wf_file="$1"
    [ -z "$wf_file" ] && { echo "Error: specify workflow file"; exit 1; }

    if [ ! -f "$wf_file" ] && [ -f "$WF_DIR/$wf_file" ]; then
        wf_file="$WF_DIR/$wf_file"
    fi
    [ ! -f "$wf_file" ] && { echo "Error: File not found: $wf_file"; exit 1; }

    local wf_name=$(grep "^# name:" "$wf_file" 2>/dev/null | head -1 | sed 's/^# name:[[:space:]]*//')
    [ -z "$wf_name" ] && wf_name=$(basename "$wf_file" .wf)

    local out="${wf_name}_exported.sh"

    echo "#!/usr/bin/env bash" > "$out"
    echo "# Exported workflow: $wf_name" >> "$out"
    echo "# Generated by Workflow Automator (BytesAgain)" >> "$out"
    echo "# $(date '+%Y-%m-%d %H:%M:%S')" >> "$out"
    echo "set -euo pipefail" >> "$out"
    echo "" >> "$out"

    local max_step=$(grep -oE "^step\.[0-9]+" "$wf_file" | sed 's/step\.//' | sort -n | tail -1)
    [ -z "$max_step" ] && { echo "Error: No steps found"; exit 1; }

    for i in $(seq 1 "$max_step"); do
        local step_name=$(grep "^step\.${i}\.name=" "$wf_file" | head -1 | cut -d= -f2-)
        local step_run=$(grep "^step\.${i}\.run=" "$wf_file" | head -1 | cut -d= -f2-)
        [ -z "$step_name" ] && continue
        echo "echo \"▶️  Step $i: $step_name\"" >> "$out"
        echo "$step_run" >> "$out"
        echo "" >> "$out"
    done

    chmod +x "$out"
    echo "✅ Exported to: $out"
    echo "   Run with: bash $out"
}

# ──── HISTORY ────
cmd_history() {
    local limit=20
    while [ $# -gt 0 ]; do
        case "$1" in
            --limit) limit="$2"; shift 2;;
            *) shift;;
        esac
    done

    ensure_dirs
    echo "═══════════════════════════════════════"
    echo "  Execution History (last $limit)"
    echo "═══════════════════════════════════════"
    echo ""

    if [ -s "$HIST_FILE" ]; then
        tail -"$limit" "$HIST_FILE" | while read -r line; do
            echo "  $line"
        done
    else
        echo "  No history yet. Run a workflow first."
    fi
}

# ──── Main Router ────
ensure_dirs

case "$CMD" in
    init) cmd_init "$@";;
    run) cmd_run "$@";;
    validate) cmd_validate "$@";;
    list) cmd_list;;
    status) cmd_status "$@";;
    log) cmd_log "$@";;
    schedule) cmd_schedule "$@";;
    template) cmd_template "$@";;
    export) cmd_export "$@";;
    history) cmd_history "$@";;
    help|--help|-h) show_help;;
    *) echo "Unknown command: $CMD"; echo "Run: bash main.sh help"; exit 1;;
esac
