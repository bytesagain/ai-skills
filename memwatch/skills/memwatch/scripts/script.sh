#!/usr/bin/env bash
# MemWatch — Memory monitor
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="memwatch"

# ─────────────────────────────────────────────────────────────
# Usage / Help
# ─────────────────────────────────────────────────────────────
usage() {
  cat <<'EOF'
MemWatch — Memory monitor
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

USAGE:
  memwatch <command> [arguments]

COMMANDS:
  status                Current memory usage summary
  top [n]               Top N memory-consuming processes (default: 10)
  watch                 Snapshot memory every 2s for 10 iterations
  process <pid>         Memory details for a specific PID
  swap                  Swap usage details
  alert <threshold>     Check if memory usage exceeds threshold %
  detailed              Detailed /proc/meminfo breakdown
  compare               Compare memory now vs 30s later
  help                  Show this help message
  version               Show version

EXAMPLES:
  memwatch status
  memwatch top 5
  memwatch watch
  memwatch process 1234
  memwatch swap
  memwatch alert 80
  memwatch detailed
  memwatch compare
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

get_mem_percent() {
  # Returns used memory percentage
  if [[ -f /proc/meminfo ]]; then
    awk '/^MemTotal:/{total=$2} /^MemAvailable:/{avail=$2} END{printf "%.1f", ((total-avail)/total)*100}' /proc/meminfo
  else
    free | awk '/^Mem:/{printf "%.1f", ($3/$2)*100}'
  fi
}

# ─────────────────────────────────────────────────────────────
# Commands
# ─────────────────────────────────────────────────────────────

cmd_status() {
  echo "Memory Status — $(timestamp)"
  echo "─────────────────────────────────────"

  # Use free -h for human-readable
  if command -v free &>/dev/null; then
    free -h
    echo ""
  fi

  # Memory usage percentage
  local pct
  pct=$(get_mem_percent)
  echo "Usage: ${pct}%"

  # Visual bar
  local filled
  filled=$(awk "BEGIN{printf \"%d\", $pct / 2}")
  local empty=$(( 50 - filled ))
  printf "  ["
  printf '%0.s█' $(seq 1 "$filled" 2>/dev/null) || true
  printf '%0.s░' $(seq 1 "$empty" 2>/dev/null) || true
  printf "] %s%%\n" "$pct"

  # Key values from /proc/meminfo
  if [[ -f /proc/meminfo ]]; then
    echo ""
    local total avail buffers cached
    total=$(awk '/^MemTotal:/{printf "%.0f", $2/1024}' /proc/meminfo)
    avail=$(awk '/^MemAvailable:/{printf "%.0f", $2/1024}' /proc/meminfo)
    buffers=$(awk '/^Buffers:/{printf "%.0f", $2/1024}' /proc/meminfo)
    cached=$(awk '/^Cached:/{printf "%.0f", $2/1024}' /proc/meminfo)
    echo "  Total:     ${total}MB"
    echo "  Available: ${avail}MB"
    echo "  Buffers:   ${buffers}MB"
    echo "  Cached:    ${cached}MB"
  fi
}

cmd_top() {
  local n="${1:-10}"
  [[ "$n" =~ ^[0-9]+$ ]] || die "n must be a positive integer"
  echo "Top $n Memory Consumers — $(timestamp)"
  echo "─────────────────────────────────────"
  printf "%-8s %-6s %-10s %s\n" "PID" "%MEM" "RSS(MB)" "COMMAND"
  echo "─────────────────────────────────────"
  ps aux --sort=-%mem 2>/dev/null | awk 'NR>1{printf "%-8s %-6s %-10.1f %s\n", $2, $4, $6/1024, $11}' | head -"$n"
}

cmd_watch() {
  local iterations=10
  local interval=2
  echo "Memory Watch — $iterations snapshots, ${interval}s interval"
  echo "─────────────────────────────────────"
  printf "%-20s %-8s %-10s %-10s %-10s\n" "TIMESTAMP" "USED%" "TOTAL(MB)" "USED(MB)" "AVAIL(MB)"
  echo "─────────────────────────────────────"
  local i
  for (( i = 1; i <= iterations; i++ )); do
    local ts pct total used avail
    ts=$(date '+%H:%M:%S')
    if [[ -f /proc/meminfo ]]; then
      read -r total avail <<< "$(awk '/^MemTotal:/{t=$2} /^MemAvailable:/{a=$2} END{print int(t/1024), int(a/1024)}' /proc/meminfo)"
      used=$(( total - avail ))
      pct=$(awk "BEGIN{printf \"%.1f\", ($used/$total)*100}")
    else
      read -r total used avail <<< "$(free -m | awk '/^Mem:/{print $2, $3, $7}')"
      pct=$(awk "BEGIN{printf \"%.1f\", ($used/$total)*100}")
    fi
    printf "%-20s %-8s %-10s %-10s %-10s\n" "$ts" "${pct}%" "$total" "$used" "$avail"
    [[ $i -lt $iterations ]] && sleep "$interval"
  done
}

cmd_process() {
  local pid="${1:-}"
  require_arg "$pid" "PID"
  [[ "$pid" =~ ^[0-9]+$ ]] || die "PID must be a number"

  if [[ ! -d "/proc/$pid" ]]; then
    die "Process $pid not found"
  fi

  echo "Memory for PID $pid — $(timestamp)"
  echo "─────────────────────────────────────"

  # Process name
  local comm="?"
  [[ -f "/proc/$pid/comm" ]] && comm=$(cat "/proc/$pid/comm")
  echo "  Process:  $comm (PID $pid)"

  # From /proc/PID/status
  if [[ -f "/proc/$pid/status" ]]; then
    local vmsize vmrss vmswap threads
    vmsize=$(awk '/^VmSize:/{print $2, $3}' "/proc/$pid/status" 2>/dev/null || echo "?")
    vmrss=$(awk '/^VmRSS:/{print $2, $3}' "/proc/$pid/status" 2>/dev/null || echo "?")
    vmswap=$(awk '/^VmSwap:/{print $2, $3}' "/proc/$pid/status" 2>/dev/null || echo "?")
    threads=$(awk '/^Threads:/{print $2}' "/proc/$pid/status" 2>/dev/null || echo "?")
    echo "  VmSize:   $vmsize"
    echo "  VmRSS:    $vmrss"
    echo "  VmSwap:   $vmswap"
    echo "  Threads:  $threads"
  fi

  # From /proc/PID/smaps_rollup if available
  if [[ -r "/proc/$pid/smaps_rollup" ]]; then
    local pss
    pss=$(awk '/^Pss:/{print $2, $3}' "/proc/$pid/smaps_rollup" 2>/dev/null || echo "?")
    echo "  PSS:      $pss"
  fi

  # From ps
  local ps_info
  ps_info=$(ps -p "$pid" -o %mem=,rss=,vsz=,etime= 2>/dev/null || true)
  if [[ -n "$ps_info" ]]; then
    read -r pmem rss vsz etime <<< "$ps_info"
    echo "  %MEM:     ${pmem}%"
    echo "  RSS:      $(( rss / 1024 ))MB"
    echo "  VSZ:      $(( vsz / 1024 ))MB"
    echo "  Elapsed:  $etime"
  fi
}

cmd_swap() {
  echo "Swap Usage — $(timestamp)"
  echo "─────────────────────────────────────"

  if command -v free &>/dev/null; then
    free -h | head -1
    free -h | grep -i swap
    echo ""
  fi

  if [[ -f /proc/swaps ]]; then
    echo "Swap Devices:"
    cat /proc/swaps
    echo ""
  fi

  if [[ -f /proc/meminfo ]]; then
    local swap_total swap_free swap_cached
    swap_total=$(awk '/^SwapTotal:/{printf "%.0f", $2/1024}' /proc/meminfo)
    swap_free=$(awk '/^SwapFree:/{printf "%.0f", $2/1024}' /proc/meminfo)
    swap_cached=$(awk '/^SwapCached:/{printf "%.0f", $2/1024}' /proc/meminfo)
    local swap_used=$(( swap_total - swap_free ))
    echo "Summary:"
    echo "  Total:   ${swap_total}MB"
    echo "  Used:    ${swap_used}MB"
    echo "  Free:    ${swap_free}MB"
    echo "  Cached:  ${swap_cached}MB"
    if [[ "$swap_total" -gt 0 ]]; then
      local pct
      pct=$(awk "BEGIN{printf \"%.1f\", ($swap_used/$swap_total)*100}")
      echo "  Usage:   ${pct}%"
    fi
  fi

  # Top swap consumers
  echo ""
  echo "Top Swap Consumers:"
  for pid_dir in /proc/[0-9]*/status; do
    [[ -f "$pid_dir" ]] || continue
    awk '/^VmSwap:/{swap=$2} /^Name:/{name=$2} END{if(swap>0) printf "  %-8s %s kB  %s\n", FILENAME, swap, name}' \
      FILENAME="$(dirname "$pid_dir" | xargs basename)" "$pid_dir" 2>/dev/null || true
  done | sort -t' ' -k2 -rn | head -10
}

cmd_alert() {
  local threshold="${1:-}"
  require_arg "$threshold" "threshold (%)"
  [[ "$threshold" =~ ^[0-9]+$ ]] || die "Threshold must be an integer percentage"
  [[ "$threshold" -ge 1 && "$threshold" -le 100 ]] || die "Threshold must be between 1 and 100"

  local current
  current=$(get_mem_percent)
  local current_int
  current_int=$(awk "BEGIN{printf \"%d\", $current}")

  echo "Memory Alert Check"
  echo "─────────────────────────────────────"
  echo "  Threshold: ${threshold}%"
  echo "  Current:   ${current}%"

  if [[ "$current_int" -ge "$threshold" ]]; then
    echo "  Status:    🚨 ALERT — memory usage exceeds threshold!"
    echo ""
    echo "Top 5 memory consumers:"
    ps aux --sort=-%mem 2>/dev/null | awk 'NR>1 && NR<=6{printf "  PID %-8s %5s%%  %s\n", $2, $4, $11}'
    return 1
  else
    echo "  Status:    ✅ OK — memory usage is within limits"
    local headroom
    headroom=$(awk "BEGIN{printf \"%.1f\", $threshold - $current}")
    echo "  Headroom:  ${headroom}%"
    return 0
  fi
}

cmd_detailed() {
  echo "Detailed Memory Info — $(timestamp)"
  echo "─────────────────────────────────────"
  [[ -f /proc/meminfo ]] || die "/proc/meminfo not found"
  cat /proc/meminfo
}

cmd_compare() {
  echo "Memory Comparison (now vs 30 seconds later)"
  echo "─────────────────────────────────────"
  echo "Snapshot 1 — $(timestamp)"
  local s1_total s1_avail s1_buffers s1_cached
  read -r s1_total s1_avail s1_buffers s1_cached <<< "$(awk '/^MemTotal:/{t=$2} /^MemAvailable:/{a=$2} /^Buffers:/{b=$2} /^Cached:/{c=$2} END{print t, a, b, c}' /proc/meminfo)"
  printf "  Total: %dMB | Available: %dMB | Buffers: %dMB | Cached: %dMB\n" \
    $((s1_total/1024)) $((s1_avail/1024)) $((s1_buffers/1024)) $((s1_cached/1024))

  echo "  Waiting 30 seconds..."
  sleep 30

  echo "Snapshot 2 — $(timestamp)"
  local s2_total s2_avail s2_buffers s2_cached
  read -r s2_total s2_avail s2_buffers s2_cached <<< "$(awk '/^MemTotal:/{t=$2} /^MemAvailable:/{a=$2} /^Buffers:/{b=$2} /^Cached:/{c=$2} END{print t, a, b, c}' /proc/meminfo)"
  printf "  Total: %dMB | Available: %dMB | Buffers: %dMB | Cached: %dMB\n" \
    $((s2_total/1024)) $((s2_avail/1024)) $((s2_buffers/1024)) $((s2_cached/1024))

  echo ""
  echo "Delta:"
  local d_avail=$(( (s2_avail - s1_avail) / 1024 ))
  local d_buffers=$(( (s2_buffers - s1_buffers) / 1024 ))
  local d_cached=$(( (s2_cached - s1_cached) / 1024 ))
  printf "  Available: %+dMB | Buffers: %+dMB | Cached: %+dMB\n" "$d_avail" "$d_buffers" "$d_cached"
}

# ─────────────────────────────────────────────────────────────
# Main dispatcher
# ─────────────────────────────────────────────────────────────
main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    status)   cmd_status ;;
    top)      cmd_top "$@" ;;
    watch)    cmd_watch ;;
    process)  cmd_process "$@" ;;
    swap)     cmd_swap ;;
    alert)    cmd_alert "$@" ;;
    detailed) cmd_detailed ;;
    compare)  cmd_compare ;;
    version)  echo "$SCRIPT_NAME $VERSION" ;;
    help|--help|-h) usage ;;
    *)        die "Unknown command: $cmd (try 'memwatch help')" ;;
  esac
}

main "$@"
