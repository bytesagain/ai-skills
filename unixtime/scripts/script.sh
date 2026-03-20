#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# unixtime — Unix Time Utility
# Convert timestamps, count down to events, and calculate time ranges.
#
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
###############################################################################

VERSION="3.0.0"
SCRIPT_NAME="unixtime"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

print_banner() {
  echo "═══════════════════════════════════════════════════════"
  echo "  ${SCRIPT_NAME} v${VERSION} — Unix Time Utility"
  echo "  Powered by BytesAgain | bytesagain.com"
  echo "═══════════════════════════════════════════════════════"
}

usage() {
  print_banner
  echo ""
  echo "Usage: ${SCRIPT_NAME} <command> [arguments]"
  echo ""
  echo "Commands:"
  echo "  current                      Show current Unix timestamp with details"
  echo "  to-date <timestamp>          Convert Unix timestamp to readable date"
  echo "  to-epoch <date-string>       Convert date string to Unix epoch"
  echo "  countdown <future-timestamp> Show time remaining until a future timestamp"
  echo "  ranges <start> <end>         Show duration between two timestamps"
  echo "  version                      Show version"
  echo "  help                         Show this help message"
  echo ""
  echo "Examples:"
  echo "  ${SCRIPT_NAME} current"
  echo "  ${SCRIPT_NAME} to-date 1700000000"
  echo "  ${SCRIPT_NAME} to-epoch '2025-06-15 14:00:00'"
  echo "  ${SCRIPT_NAME} countdown 1800000000"
  echo "  ${SCRIPT_NAME} ranges 1700000000 1700086400"
  echo ""
  echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

is_numeric() {
  [[ "$1" =~ ^-?[0-9]+$ ]]
}

format_duration_long() {
  local total="$1"
  local negative=0
  if [[ "$total" -lt 0 ]]; then
    negative=1
    total=$(( -total ))
  fi

  local years=$(( total / 31536000 ))
  local remainder=$(( total % 31536000 ))
  local weeks=$(( remainder / 604800 ))
  remainder=$(( remainder % 604800 ))
  local days=$(( remainder / 86400 ))
  remainder=$(( remainder % 86400 ))
  local hours=$(( remainder / 3600 ))
  remainder=$(( remainder % 3600 ))
  local minutes=$(( remainder / 60 ))
  local seconds=$(( remainder % 60 ))

  local parts=()
  [[ "$years" -gt 0 ]] && parts+=("${years}y")
  [[ "$weeks" -gt 0 ]] && parts+=("${weeks}w")
  [[ "$days" -gt 0 ]] && parts+=("${days}d")
  [[ "$hours" -gt 0 ]] && parts+=("${hours}h")
  [[ "$minutes" -gt 0 ]] && parts+=("${minutes}m")
  parts+=("${seconds}s")

  local result="${parts[*]}"
  if [[ "$negative" -eq 1 ]]; then
    echo "-${result}"
  else
    echo "${result}"
  fi
}

format_short_duration() {
  local total="$1"
  local abs="${total#-}"
  [[ "$total" -lt 0 ]] && abs=$(( -total ))

  local days=$(( abs / 86400 ))
  local hours=$(( (abs % 86400) / 3600 ))
  local minutes=$(( (abs % 3600) / 60 ))
  local seconds=$(( abs % 60 ))

  echo "${days}d ${hours}h ${minutes}m ${seconds}s"
}

epoch_to_human() {
  local ts="$1"
  date -d "@${ts}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null \
    || date -r "${ts}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null \
    || echo "N/A"
}

epoch_to_utc() {
  local ts="$1"
  TZ=UTC date -d "@${ts}" '+%Y-%m-%d %H:%M:%S UTC' 2>/dev/null \
    || TZ=UTC date -r "${ts}" '+%Y-%m-%d %H:%M:%S UTC' 2>/dev/null \
    || echo "N/A"
}

# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------

cmd_current() {
  local now
  now="$(date +%s)"
  local now_local now_utc now_iso
  now_local="$(epoch_to_human "$now")"
  now_utc="$(epoch_to_utc "$now")"
  now_iso="$(date -u '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || echo 'N/A')"

  local now_ms
  if command -v python3 &>/dev/null; then
    now_ms="$(python3 -c 'import time; print(int(time.time()*1000))')"
  else
    now_ms="${now}000"
  fi

  local day_of_year week_number day_name
  day_of_year="$(date '+%-j' 2>/dev/null || echo 'N/A')"
  week_number="$(date '+%V' 2>/dev/null || echo 'N/A')"
  day_name="$(date '+%A' 2>/dev/null || echo 'N/A')"

  echo "┌───────────────────────────────────────────────┐"
  echo "│  Current Unix Time                            │"
  echo "├───────────────────────────────────────────────┤"
  printf "│  Epoch (s):   %-32s │\n" "${now}"
  printf "│  Epoch (ms):  %-32s │\n" "${now_ms}"
  printf "│  Local:       %-32s │\n" "${now_local}"
  printf "│  UTC:         %-32s │\n" "${now_utc}"
  printf "│  ISO 8601:    %-32s │\n" "${now_iso}"
  echo "├───────────────────────────────────────────────┤"
  printf "│  Day of year: %-32s │\n" "${day_of_year}/365"
  printf "│  Week:        %-32s │\n" "${week_number}"
  printf "│  Day:         %-32s │\n" "${day_name}"
  echo "└───────────────────────────────────────────────┘"
}

cmd_to_date() {
  local ts="${1:-}"
  [[ -z "$ts" ]] && die "Usage: ${SCRIPT_NAME} to-date <timestamp>"
  is_numeric "$ts" || die "Invalid timestamp: '${ts}' — must be a number"

  # Detect if milliseconds (13+ digits)
  local effective_ts="$ts"
  local note=""
  if [[ "${#ts}" -ge 13 ]]; then
    effective_ts=$(( ts / 1000 ))
    note="(detected milliseconds, divided by 1000)"
  fi

  local local_date utc_date iso_date
  local_date="$(epoch_to_human "$effective_ts")"
  utc_date="$(epoch_to_utc "$effective_ts")"
  iso_date="$(TZ=UTC date -d "@${effective_ts}" '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || echo 'N/A')"

  local now age age_str
  now="$(date +%s)"
  age=$(( now - effective_ts ))
  age_str="$(format_duration_long "$age")"

  local relative
  if [[ "$age" -gt 0 ]]; then
    relative="${age_str} ago"
  elif [[ "$age" -lt 0 ]]; then
    relative="in $(format_duration_long $(( -age )))"
  else
    relative="right now"
  fi

  echo "┌───────────────────────────────────────────────────┐"
  echo "│  Timestamp → Date                                 │"
  echo "├───────────────────────────────────────────────────┤"
  printf "│  Input:    %-39s │\n" "${ts} ${note}"
  printf "│  Local:    %-39s │\n" "${local_date}"
  printf "│  UTC:      %-39s │\n" "${utc_date}"
  printf "│  ISO 8601: %-39s │\n" "${iso_date}"
  printf "│  Relative: %-39s │\n" "${relative}"
  echo "└───────────────────────────────────────────────────┘"
}

cmd_to_epoch() {
  local datestr="${1:-}"
  [[ -z "$datestr" ]] && die "Usage: ${SCRIPT_NAME} to-epoch <date-string>\n  Example: ${SCRIPT_NAME} to-epoch '2025-06-15 14:00:00'"

  local epoch
  epoch="$(date -d "${datestr}" '+%s' 2>/dev/null)" \
    || die "Failed to parse date: '${datestr}'\n  Try formats like: '2025-01-15', '2025-01-15 10:30:00', 'Jan 15 2025'"

  local human_back
  human_back="$(epoch_to_human "$epoch")"

  local now diff_sec relative
  now="$(date +%s)"
  diff_sec=$(( epoch - now ))
  if [[ "$diff_sec" -gt 0 ]]; then
    relative="$(format_duration_long "$diff_sec") from now"
  elif [[ "$diff_sec" -lt 0 ]]; then
    relative="$(format_duration_long $(( -diff_sec ))) ago"
  else
    relative="right now"
  fi

  echo "┌───────────────────────────────────────────────────┐"
  echo "│  Date → Epoch                                     │"
  echo "├───────────────────────────────────────────────────┤"
  printf "│  Input:    %-39s │\n" "${datestr}"
  printf "│  Epoch:    %-39s │\n" "${epoch}"
  printf "│  Verified: %-39s │\n" "${human_back}"
  printf "│  Relative: %-39s │\n" "${relative}"
  echo "└───────────────────────────────────────────────────┘"
}

cmd_countdown() {
  local target="${1:-}"
  [[ -z "$target" ]] && die "Usage: ${SCRIPT_NAME} countdown <future-timestamp>"
  is_numeric "$target" || die "Invalid timestamp: '${target}'"

  local now remaining
  now="$(date +%s)"
  remaining=$(( target - now ))

  local target_date
  target_date="$(epoch_to_human "$target")"

  if [[ "$remaining" -le 0 ]]; then
    local elapsed=$(( -remaining ))
    echo "┌───────────────────────────────────────────────────┐"
    echo "│  ⏰ Countdown — ALREADY PASSED                    │"
    echo "├───────────────────────────────────────────────────┤"
    printf "│  Target:  %-40s │\n" "${target} (${target_date})"
    printf "│  Status:  %-40s │\n" "Passed $(format_duration_long "$elapsed") ago"
    echo "└───────────────────────────────────────────────────┘"
  else
    local pct
    # percentage through the day
    local dur_str
    dur_str="$(format_duration_long "$remaining")"
    echo "┌───────────────────────────────────────────────────┐"
    echo "│  ⏳ Countdown                                     │"
    echo "├───────────────────────────────────────────────────┤"
    printf "│  Target:     %-37s │\n" "${target} (${target_date})"
    printf "│  Now:        %-37s │\n" "${now}"
    printf "│  Remaining:  %-37s │\n" "${dur_str}"
    echo "├───────────────────────────────────────────────────┤"
    printf "│  Seconds:    %-37s │\n" "${remaining}"
    printf "│  Minutes:    %-37s │\n" "$(awk "BEGIN{printf \"%.1f\", ${remaining}/60}")"
    printf "│  Hours:      %-37s │\n" "$(awk "BEGIN{printf \"%.2f\", ${remaining}/3600}")"
    printf "│  Days:       %-37s │\n" "$(awk "BEGIN{printf \"%.3f\", ${remaining}/86400}")"
    echo "└───────────────────────────────────────────────────┘"
  fi
}

cmd_ranges() {
  local start="${1:-}"
  local end="${2:-}"
  [[ -z "$start" || -z "$end" ]] && die "Usage: ${SCRIPT_NAME} ranges <start> <end>"
  is_numeric "$start" || die "Invalid start timestamp: '${start}'"
  is_numeric "$end" || die "Invalid end timestamp: '${end}'"

  local diff=$(( end - start ))
  local abs_diff="${diff#-}"
  [[ "$diff" -lt 0 ]] && abs_diff=$(( -diff ))

  local start_date end_date
  start_date="$(epoch_to_human "$start")"
  end_date="$(epoch_to_human "$end")"

  local dur_str
  dur_str="$(format_duration_long "$diff")"

  echo "┌───────────────────────────────────────────────────────┐"
  echo "│  Time Range Analysis                                  │"
  echo "├───────────────────────────────────────────────────────┤"
  printf "│  Start:    %-42s │\n" "${start} → ${start_date}"
  printf "│  End:      %-42s │\n" "${end} → ${end_date}"
  echo "├───────────────────────────────────────────────────────┤"
  printf "│  Duration: %-42s │\n" "${dur_str}"
  printf "│  Seconds:  %-42s │\n" "${diff}"
  printf "│  Minutes:  %-42s │\n" "$(awk "BEGIN{printf \"%.2f\", ${abs_diff}/60}")"
  printf "│  Hours:    %-42s │\n" "$(awk "BEGIN{printf \"%.2f\", ${abs_diff}/3600}")"
  printf "│  Days:     %-42s │\n" "$(awk "BEGIN{printf \"%.4f\", ${abs_diff}/86400}")"
  printf "│  Weeks:    %-42s │\n" "$(awk "BEGIN{printf \"%.4f\", ${abs_diff}/604800}")"
  echo "└───────────────────────────────────────────────────────┘"
}

# ---------------------------------------------------------------------------
# Main dispatch
# ---------------------------------------------------------------------------

main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    current)   cmd_current "$@" ;;
    to-date)   cmd_to_date "$@" ;;
    to-epoch)  cmd_to_epoch "$@" ;;
    countdown) cmd_countdown "$@" ;;
    ranges)    cmd_ranges "$@" ;;
    version)   echo "${SCRIPT_NAME} v${VERSION}" ;;
    help|--help|-h) usage ;;
    *)         die "Unknown command: '${cmd}'. Run '${SCRIPT_NAME} help' for usage." ;;
  esac
}

main "$@"
