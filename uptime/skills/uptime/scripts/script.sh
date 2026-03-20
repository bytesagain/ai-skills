#!/usr/bin/env bash
# Uptime — System uptime monitor
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="uptime"
LOG_DIR="${HOME}/.uptime-monitor"

# ─────────────────────────────────────────────────────────────
# Usage / Help
# ─────────────────────────────────────────────────────────────
usage() {
  cat <<'EOF'
Uptime — System uptime monitor
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

USAGE:
  uptime <command> [arguments]

COMMANDS:
  status                   Show system uptime, load average, and users
  check <url>              Check if a URL is reachable (HTTP status + timing)
  log                      Log current uptime snapshot to file
  history                  Show uptime log history
  alert <url> <email>      Check URL and show alert info (mail integration)
  since                    Show system boot time
  multi <url1> <url2> ...  Check multiple URLs at once
  help                     Show this help message
  version                  Show version

EXAMPLES:
  uptime status
  uptime check https://example.com
  uptime log
  uptime history
  uptime alert https://mysite.com admin@example.com
  uptime since
  uptime multi https://google.com https://github.com
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

ensure_log_dir() {
  mkdir -p "$LOG_DIR"
}

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

# ─────────────────────────────────────────────────────────────
# Commands
# ─────────────────────────────────────────────────────────────

cmd_status() {
  echo "System Uptime Status"
  echo "─────────────────────────────────────"

  # Uptime from /proc/uptime
  if [[ -f /proc/uptime ]]; then
    local raw_seconds
    raw_seconds=$(awk '{print int($1)}' /proc/uptime)
    local days=$(( raw_seconds / 86400 ))
    local hours=$(( (raw_seconds % 86400) / 3600 ))
    local minutes=$(( (raw_seconds % 3600) / 60 ))
    local seconds=$(( raw_seconds % 60 ))
    echo "  Uptime:     ${days}d ${hours}h ${minutes}m ${seconds}s"
  fi

  # Load average
  if [[ -f /proc/loadavg ]]; then
    local loadavg
    loadavg=$(cat /proc/loadavg)
    local load1 load5 load15 procs
    load1=$(echo "$loadavg" | awk '{print $1}')
    load5=$(echo "$loadavg" | awk '{print $2}')
    load15=$(echo "$loadavg" | awk '{print $3}')
    procs=$(echo "$loadavg" | awk '{print $4}')
    echo "  Load Avg:   $load1 (1m)  $load5 (5m)  $load15 (15m)"
    echo "  Processes:  $procs"
  fi

  # CPU count
  if [[ -f /proc/cpuinfo ]]; then
    local cpus
    cpus=$(grep -c '^processor' /proc/cpuinfo 2>/dev/null || echo "?")
    echo "  CPUs:       $cpus"
  fi

  # Logged-in users
  local users
  users=$(who 2>/dev/null | wc -l)
  echo "  Users:      $users logged in"

  # Current time
  echo "  Time:       $(date)"

  # Hostname
  echo "  Hostname:   $(hostname 2>/dev/null || echo '?')"
}

cmd_check() {
  local url="${1:-}"
  require_arg "$url" "url"
  echo "URL Check: $url"
  echo "─────────────────────────────────────"
  local http_code time_total time_connect time_starttransfer redirect_url
  local curl_output
  curl_output=$(curl -sL -o /dev/null -w '%{http_code} %{time_total} %{time_connect} %{time_starttransfer} %{redirect_url}' \
    --max-time 30 "$url" 2>/dev/null || echo "000 0 0 0")
  http_code=$(echo "$curl_output" | awk '{print $1}')
  time_total=$(echo "$curl_output" | awk '{print $2}')
  time_connect=$(echo "$curl_output" | awk '{print $3}')
  time_starttransfer=$(echo "$curl_output" | awk '{print $4}')
  redirect_url=$(echo "$curl_output" | awk '{print $5}')
  local status_text
  if [[ "$http_code" == "000" ]]; then
    status_text="❌ UNREACHABLE"
  elif [[ "$http_code" -lt 300 ]]; then
    status_text="✅ UP (HTTP $http_code)"
  elif [[ "$http_code" -lt 400 ]]; then
    status_text="↪ REDIRECT (HTTP $http_code)"
  elif [[ "$http_code" -lt 500 ]]; then
    status_text="⚠️ CLIENT ERROR (HTTP $http_code)"
  else
    status_text="❌ SERVER ERROR (HTTP $http_code)"
  fi

  echo "  Status:    $status_text"
  echo "  Connect:   ${time_connect}s"
  echo "  TTFB:      ${time_starttransfer}s"
  echo "  Total:     ${time_total}s"
  echo "  Checked:   $(timestamp)"
  if [[ -n "$redirect_url" && "$redirect_url" != "-" ]]; then
    echo "  Redirect:  $redirect_url"
  fi
}

cmd_log() {
  ensure_log_dir
  local logfile="$LOG_DIR/uptime.log"
  local ts
  ts=$(timestamp)
  local raw_uptime="?"
  [[ -f /proc/uptime ]] && raw_uptime=$(awk '{print $1}' /proc/uptime)
  local loadavg="?"
  [[ -f /proc/loadavg ]] && loadavg=$(awk '{print $1,$2,$3}' /proc/loadavg)
  local users
  users=$(who 2>/dev/null | wc -l)
  local entry="[$ts] uptime=${raw_uptime}s load=\"$loadavg\" users=$users"
  echo "$entry" >> "$logfile"
  echo "Logged: $entry"
  echo "File:   $logfile"
}

cmd_history() {
  ensure_log_dir
  local logfile="$LOG_DIR/uptime.log"
  if [[ ! -f "$logfile" ]]; then
    echo "No uptime history yet. Run 'uptime log' to start recording."
    return
  fi
  local total
  total=$(wc -l < "$logfile")
  echo "Uptime History ($total entries)"
  echo "─────────────────────────────────────"
  if [[ "$total" -le 30 ]]; then
    cat "$logfile"
  else
    echo "(showing last 30 of $total entries)"
    tail -30 "$logfile"
  fi
}

cmd_alert() {
  local url="${1:-}"
  local email="${2:-}"
  require_arg "$url" "url"
  require_arg "$email" "email"
  echo "Alert Check: $url → $email"
  echo "─────────────────────────────────────"
  local http_code
  http_code=$(curl -sL -o /dev/null -w '%{http_code}' --max-time 15 "$url" 2>/dev/null || echo "000")

  if [[ "$http_code" == "000" || "$http_code" -ge 500 ]]; then
    local alert_msg="🚨 ALERT: $url is DOWN (HTTP $http_code) at $(timestamp)"
    echo "$alert_msg"
    echo ""
    if command -v mail &>/dev/null; then
      echo "$alert_msg" | mail -s "ALERT: $url DOWN" "$email" 2>/dev/null && \
        echo "📧 Alert email sent to $email" || \
        echo "📧 mail command failed — alert not sent"
    else
      echo "📧 mail command not available. Alert message above for manual action."
      echo "   To enable email alerts, install mailutils: apt install mailutils"
    fi
    # Log the alert
    ensure_log_dir
    echo "[$(timestamp)] ALERT url=$url status=$http_code email=$email" >> "$LOG_DIR/alerts.log"
  else
    echo "✅ $url is UP (HTTP $http_code)"
    echo "   No alert needed."
  fi
}

cmd_since() {
  echo "System Boot Time"
  echo "─────────────────────────────────────"
  if command -v uptime &>/dev/null; then
    echo "  $(uptime -s 2>/dev/null || uptime)"
  fi
  if [[ -f /proc/uptime ]]; then
    local boot_epoch
    boot_epoch=$(awk -v now="$(date +%s)" '{print int(now - $1)}' /proc/uptime)
    echo "  Boot epoch: $boot_epoch"
    echo "  Boot time:  $(date -d "@$boot_epoch" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date -r "$boot_epoch" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo '?')"
  fi
}

cmd_multi() {
  local urls=("$@")
  [[ ${#urls[@]} -gt 0 ]] || die "Provide at least one URL"
  echo "Multi-URL Check (${#urls[@]} URLs)"
  echo "─────────────────────────────────────"
  local up=0 down=0
  for url in "${urls[@]}"; do
    local http_code time_total
    local curl_out
    curl_out=$(curl -sL -o /dev/null -w '%{http_code} %{time_total}' --max-time 10 "$url" 2>/dev/null || echo "000 0")
    http_code=$(echo "$curl_out" | awk '{print $1}')
    time_total=$(echo "$curl_out" | awk '{print $2}')
    if [[ "$http_code" != "000" && "$http_code" -lt 500 ]]; then
      echo "  ✅ $url — HTTP $http_code (${time_total}s)"
      (( up++ )) || true
    else
      echo "  ❌ $url — HTTP $http_code"
      (( down++ )) || true
    fi
  done
  echo "─────────────────────────────────────"
  echo "Summary: $up up, $down down"
}

# ─────────────────────────────────────────────────────────────
# Main dispatcher
# ─────────────────────────────────────────────────────────────
main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    status)  cmd_status ;;
    check)   cmd_check "$@" ;;
    log)     cmd_log ;;
    history) cmd_history ;;
    alert)   cmd_alert "$@" ;;
    since)   cmd_since ;;
    multi)   cmd_multi "$@" ;;
    version) echo "$SCRIPT_NAME $VERSION" ;;
    help|--help|-h) usage ;;
    *)       die "Unknown command: $cmd (try 'uptime help')" ;;
  esac
}

main "$@"
