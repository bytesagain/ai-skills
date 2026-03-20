#!/usr/bin/env bash
# ProcMon — Process monitor
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="procmon"
LOG_DIR="${HOME}/.procmon"

# ─────────────────────────────────────────────────────────────
# Usage / Help
# ─────────────────────────────────────────────────────────────
usage() {
  cat <<'EOF'
ProcMon — Process monitor
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

USAGE:
  procmon <command> [arguments]

COMMANDS:
  list [filter]           List processes (optionally filter by name)
  watch <name>            Monitor a named process (5 snapshots, 2s interval)
  zombie                  Find zombie processes
  heavy                   Show CPU/memory heavy processes
  count                   Count processes by state
  log <name>              Log process stats to file
  tree [pid]              Show process tree
  ports                   Show processes listening on ports
  help                    Show this help message
  version                 Show version

EXAMPLES:
  procmon list
  procmon list nginx
  procmon watch sshd
  procmon zombie
  procmon heavy
  procmon count
  procmon log node
  procmon tree
  procmon tree 1
  procmon ports
EOF
}

# ─────────────────────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────────────────────
die() { echo "ERROR: $*" >&2; exit 1; }

require_arg() {
  if [[ -z "${1:-}" ]]; then
    die "Missing required argument: $2"
  fi
}

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

ensure_log_dir() {
  mkdir -p "$LOG_DIR"
}

# ─────────────────────────────────────────────────────────────
# Commands
# ─────────────────────────────────────────────────────────────

cmd_list() {
  local filter="${1:-}"
  echo "Process List — $(timestamp)"
  echo "─────────────────────────────────────"

  if [[ -n "$filter" ]]; then
    echo "Filter: $filter"
    echo ""
    printf "%-8s %-6s %-6s %-8s %-6s %s\n" "PID" "%CPU" "%MEM" "STATE" "TTY" "COMMAND"
    echo "─────────────────────────────────────"
    ps aux 2>/dev/null | awk -v pat="$filter" '
      NR>1 && tolower($0) ~ tolower(pat) {
        printf "%-8s %-6s %-6s %-8s %-6s %s\n", $2, $3, $4, $8, $7, $11
      }
    '
  else
    local total
    total=$(ps aux 2>/dev/null | tail -n +2 | wc -l)
    echo "Total processes: $total"
    echo ""
    printf "%-8s %-6s %-6s %-8s %s\n" "PID" "%CPU" "%MEM" "STATE" "COMMAND"
    echo "─────────────────────────────────────"
    ps aux --sort=-%cpu 2>/dev/null | awk 'NR>1 && NR<=26 {
      printf "%-8s %-6s %-6s %-8s %s\n", $2, $3, $4, $8, $11
    }'
    [[ "$total" -gt 25 ]] && echo "... (showing top 25 of $total, use 'procmon list <filter>' to search)"
  fi
}

cmd_watch() {
  local name="${1:-}"
  require_arg "$name" "process name"

  local snapshots=5
  local interval=2

  echo "Watching process: $name ($snapshots snapshots, ${interval}s interval)"
  echo "─────────────────────────────────────"

  local i
  for (( i = 1; i <= snapshots; i++ )); do
    echo ""
    echo "── Snapshot $i/$snapshots — $(date '+%H:%M:%S') ──"
    local found=0
    while IFS= read -r line; do
      if [[ $found -eq 0 ]]; then
        printf "  %-8s %-6s %-6s %-10s %-10s %s\n" "PID" "%CPU" "%MEM" "RSS(MB)" "TIME" "CMD"
        found=1
      fi
      local pid cpu mem rss etime cmd
      read -r pid cpu mem rss etime cmd <<< "$line"
      local rss_mb
      rss_mb=$(awk "BEGIN{printf \"%.1f\", $rss/1024}")
      printf "  %-8s %-6s %-6s %-10s %-10s %s\n" "$pid" "$cpu" "$mem" "$rss_mb" "$etime" "$cmd"
    done < <(ps -eo pid,%cpu,%mem,rss,etime,comm 2>/dev/null | awk -v pat="$name" 'NR>1 && $6 ~ pat {print}')

    if [[ $found -eq 0 ]]; then
      echo "  (no matching processes found)"
    fi

    [[ $i -lt $snapshots ]] && sleep "$interval"
  done
}

cmd_zombie() {
  echo "Zombie Process Scanner — $(timestamp)"
  echo "─────────────────────────────────────"

  local zombies
  zombies=$(ps aux 2>/dev/null | awk '$8 ~ /^Z/ {print}')

  if [[ -z "$zombies" ]]; then
    echo "✅ No zombie processes found"
    return
  fi

  local count
  count=$(echo "$zombies" | wc -l)
  echo "🧟 Found $count zombie process(es):"
  echo ""
  printf "  %-8s %-8s %-8s %-20s %s\n" "PID" "PPID" "STATE" "TIME" "COMMAND"
  echo "  ─────────────────────────────────────"

  while IFS= read -r line; do
    local pid ppid state time cmd
    pid=$(echo "$line" | awk '{print $2}')
    ppid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ' || echo "?")
    state=$(echo "$line" | awk '{print $8}')
    time=$(echo "$line" | awk '{print $10}')
    cmd=$(echo "$line" | awk '{print $11}')
    printf "  %-8s %-8s %-8s %-20s %s\n" "$pid" "$ppid" "$state" "$time" "$cmd"
  done <<< "$zombies"

  echo ""
  echo "Tip: Kill parent processes (PPID) to clean up zombies"
}

cmd_heavy() {
  echo "Heavy Processes — $(timestamp)"
  echo "─────────────────────────────────────"

  echo ""
  echo "🔥 Top 10 by CPU:"
  printf "  %-8s %-7s %-7s %-10s %s\n" "PID" "%CPU" "%MEM" "RSS(MB)" "COMMAND"
  echo "  ─────────────────────────────────────"
  ps aux --sort=-%cpu 2>/dev/null | awk 'NR>1 && NR<=11 {
    printf "  %-8s %-7s %-7s %-10.1f %s\n", $2, $3, $4, $6/1024, $11
  }'

  echo ""
  echo "🧠 Top 10 by Memory:"
  printf "  %-8s %-7s %-7s %-10s %s\n" "PID" "%CPU" "%MEM" "RSS(MB)" "COMMAND"
  echo "  ─────────────────────────────────────"
  ps aux --sort=-%mem 2>/dev/null | awk 'NR>1 && NR<=11 {
    printf "  %-8s %-7s %-7s %-10.1f %s\n", $2, $3, $4, $6/1024, $11
  }'
}

cmd_count() {
  echo "Process State Count — $(timestamp)"
  echo "─────────────────────────────────────"

  local total running sleeping stopped zombie other
  total=0 running=0 sleeping=0 stopped=0 zombie=0 other=0

  while IFS= read -r state; do
    (( total++ )) || true
    case "$state" in
      R*) (( running++ )) || true ;;
      S*|D*|I*) (( sleeping++ )) || true ;;
      T*|t*) (( stopped++ )) || true ;;
      Z*) (( zombie++ )) || true ;;
      *) (( other++ )) || true ;;
    esac
  done < <(ps -eo stat= 2>/dev/null)

  echo "  Total:    $total"
  echo "  Running:  $running (R)"
  echo "  Sleeping: $sleeping (S/D/I)"
  echo "  Stopped:  $stopped (T)"
  echo "  Zombie:   $zombie (Z)"
  echo "  Other:    $other"

  echo ""
  echo "State breakdown:"
  ps -eo stat= 2>/dev/null | sort | uniq -c | sort -rn | head -20 | awk '{printf "  %-6s %s\n", $2, $1}'
}

cmd_log() {
  local name="${1:-}"
  require_arg "$name" "process name"
  ensure_log_dir

  local logfile="$LOG_DIR/${name}.log"
  local ts
  ts=$(timestamp)
  local entries=""
  local count=0

  while IFS= read -r line; do
    entries+="  $line"$'\n'
    (( count++ )) || true
  done < <(ps -eo pid,%cpu,%mem,rss,etime,comm 2>/dev/null | awk -v pat="$name" 'NR>1 && $6 ~ pat')

  echo "[$ts] process=$name matches=$count" >> "$logfile"
  if [[ $count -gt 0 ]]; then
    echo "$entries" >> "$logfile"
  fi

  echo "Logged $count process(es) matching '$name'"
  echo "File: $logfile"

  if [[ $count -gt 0 ]]; then
    echo ""
    echo "Matched processes:"
    printf "  %-8s %-6s %-6s %-10s %-10s %s\n" "PID" "%CPU" "%MEM" "RSS(kB)" "ELAPSED" "CMD"
    echo -n "$entries"
  else
    echo "(no matching processes found)"
  fi
}

cmd_tree() {
  local pid="${1:-}"
  echo "Process Tree — $(timestamp)"
  echo "─────────────────────────────────────"

  if command -v pstree &>/dev/null; then
    if [[ -n "$pid" ]]; then
      pstree -p "$pid" 2>/dev/null || echo "PID $pid not found"
    else
      pstree -p 2>/dev/null | head -60
    fi
  else
    if [[ -n "$pid" ]]; then
      ps --forest -o pid,ppid,%cpu,%mem,comm -g "$(ps -o sid= -p "$pid" 2>/dev/null)" 2>/dev/null || \
        ps -ef --forest 2>/dev/null | awk -v pid="$pid" '$2==pid || $3==pid' || echo "PID $pid not found"
    else
      ps -ef --forest 2>/dev/null | head -40
    fi
  fi
}

cmd_ports() {
  echo "Processes Listening on Ports — $(timestamp)"
  echo "─────────────────────────────────────"

  if command -v ss &>/dev/null; then
    ss -tlnp 2>/dev/null | head -30
  elif command -v netstat &>/dev/null; then
    netstat -tlnp 2>/dev/null | head -30
  else
    # Fallback: check /proc/net/tcp
    echo "(ss and netstat not found, showing /proc/net/tcp)"
    if [[ -f /proc/net/tcp ]]; then
      echo "  Local Address        State"
      awk 'NR>1 {
        split($2, a, ":");
        port = strtonum("0x" a[2]);
        if ($4 == "0A") printf "  :%d LISTEN\n", port
      }' /proc/net/tcp | sort -t: -k2 -n | head -20
    fi
  fi
}

# ─────────────────────────────────────────────────────────────
# Main dispatcher
# ─────────────────────────────────────────────────────────────
main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    list)    cmd_list "$@" ;;
    watch)   cmd_watch "$@" ;;
    zombie)  cmd_zombie ;;
    heavy)   cmd_heavy ;;
    count)   cmd_count ;;
    log)     cmd_log "$@" ;;
    tree)    cmd_tree "$@" ;;
    ports)   cmd_ports ;;
    version) echo "$SCRIPT_NAME $VERSION" ;;
    help|--help|-h) usage ;;
    *)       die "Unknown command: $cmd (try 'procmon help')" ;;
  esac
}

main "$@"
