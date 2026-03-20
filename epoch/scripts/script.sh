#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# epoch — Unix Timestamp Tool
# Convert, compare, and calculate Unix epoch timestamps.
#
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
###############################################################################

VERSION="3.0.0"
SCRIPT_NAME="epoch"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

print_banner() {
  echo "═══════════════════════════════════════════════════════"
  echo "  ${SCRIPT_NAME} v${VERSION} — Unix Timestamp Tool"
  echo "  Powered by BytesAgain | bytesagain.com"
  echo "═══════════════════════════════════════════════════════"
}

usage() {
  print_banner
  echo ""
  echo "Usage: ${SCRIPT_NAME} <command> [arguments]"
  echo ""
  echo "Commands:"
  echo "  now                        Show current epoch timestamp + human-readable date"
  echo "  convert <timestamp>        Convert epoch timestamp to human-readable date"
  echo "  from <date-string>         Convert human-readable date string to epoch"
  echo "  diff <ts1> <ts2>           Calculate difference between two timestamps"
  echo "  add <timestamp> <seconds>  Add seconds to a timestamp"
  echo "  version                    Show version"
  echo "  help                       Show this help message"
  echo ""
  echo "Examples:"
  echo "  ${SCRIPT_NAME} now"
  echo "  ${SCRIPT_NAME} convert 1700000000"
  echo "  ${SCRIPT_NAME} from '2024-01-15 10:30:00'"
  echo "  ${SCRIPT_NAME} diff 1700000000 1700086400"
  echo "  ${SCRIPT_NAME} add 1700000000 3600"
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

format_duration() {
  local total_seconds="$1"
  local abs_seconds="${total_seconds#-}"
  local sign=""
  if [[ "$total_seconds" -lt 0 ]]; then
    sign="-"
    abs_seconds=$(( -total_seconds ))
  fi

  local days=$(( abs_seconds / 86400 ))
  local hours=$(( (abs_seconds % 86400) / 3600 ))
  local minutes=$(( (abs_seconds % 3600) / 60 ))
  local seconds=$(( abs_seconds % 60 ))

  echo "${sign}${days}d ${hours}h ${minutes}m ${seconds}s"
}

# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------

cmd_now() {
  local epoch
  epoch="$(date +%s)"
  local human
  human="$(date -d "@${epoch}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null || date -r "${epoch}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null)"

  echo "┌─────────────────────────────────────┐"
  echo "│  Current Time                       │"
  echo "├─────────────────────────────────────┤"
  printf "│  Epoch:  %-27s │\n" "${epoch}"
  printf "│  Human:  %-27s │\n" "${human}"
  echo "├─────────────────────────────────────┤"
  echo "│  UTC:    $(date -u '+%Y-%m-%d %H:%M:%S UTC')    │"
  echo "└─────────────────────────────────────┘"
}

cmd_convert() {
  local ts="${1:-}"
  [[ -z "$ts" ]] && die "Usage: ${SCRIPT_NAME} convert <timestamp>"
  is_numeric "$ts" || die "Invalid timestamp: '${ts}' — must be a number"

  local human_local human_utc
  human_local="$(date -d "@${ts}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null || date -r "${ts}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null)" \
    || die "Failed to convert timestamp: ${ts}"
  human_utc="$(TZ=UTC date -d "@${ts}" '+%Y-%m-%d %H:%M:%S UTC' 2>/dev/null || TZ=UTC date -r "${ts}" '+%Y-%m-%d %H:%M:%S UTC' 2>/dev/null)"

  local now
  now="$(date +%s)"
  local age
  age=$(( now - ts ))
  local age_str
  age_str="$(format_duration "$age")"

  echo "┌─────────────────────────────────────────────┐"
  echo "│  Epoch → Human Date                         │"
  echo "├─────────────────────────────────────────────┤"
  printf "│  Epoch:  %-35s │\n" "${ts}"
  printf "│  Local:  %-35s │\n" "${human_local}"
  printf "│  UTC:    %-35s │\n" "${human_utc}"
  printf "│  Age:    %-35s │\n" "${age_str} ago"
  echo "└─────────────────────────────────────────────┘"
}

cmd_from() {
  local datestr="${1:-}"
  [[ -z "$datestr" ]] && die "Usage: ${SCRIPT_NAME} from <date-string>\n  Example: ${SCRIPT_NAME} from '2024-01-15 10:30:00'"

  local epoch
  epoch="$(date -d "${datestr}" '+%s' 2>/dev/null || date -j -f '%Y-%m-%d %H:%M:%S' "${datestr}" '+%s' 2>/dev/null)" \
    || die "Failed to parse date: '${datestr}'"

  local human
  human="$(date -d "@${epoch}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null || date -r "${epoch}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null)"

  echo "┌─────────────────────────────────────────────┐"
  echo "│  Human Date → Epoch                         │"
  echo "├─────────────────────────────────────────────┤"
  printf "│  Input:  %-35s │\n" "${datestr}"
  printf "│  Epoch:  %-35s │\n" "${epoch}"
  printf "│  Parsed: %-35s │\n" "${human}"
  echo "└─────────────────────────────────────────────┘"
}

cmd_diff() {
  local ts1="${1:-}"
  local ts2="${2:-}"
  [[ -z "$ts1" || -z "$ts2" ]] && die "Usage: ${SCRIPT_NAME} diff <ts1> <ts2>"
  is_numeric "$ts1" || die "Invalid timestamp: '${ts1}'"
  is_numeric "$ts2" || die "Invalid timestamp: '${ts2}'"

  local diff_seconds=$(( ts2 - ts1 ))
  local abs_diff="${diff_seconds#-}"
  [[ "$diff_seconds" -lt 0 ]] && abs_diff=$(( -diff_seconds ))

  local diff_minutes diff_hours diff_days
  diff_minutes=$(awk "BEGIN { printf \"%.2f\", ${abs_diff} / 60 }")
  diff_hours=$(awk "BEGIN { printf \"%.2f\", ${abs_diff} / 3600 }")
  diff_days=$(awk "BEGIN { printf \"%.4f\", ${abs_diff} / 86400 }")

  local human1 human2
  human1="$(date -d "@${ts1}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null || date -r "${ts1}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null)"
  human2="$(date -d "@${ts2}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null || date -r "${ts2}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null)"

  local duration_str
  duration_str="$(format_duration "$diff_seconds")"

  echo "┌───────────────────────────────────────────────────┐"
  echo "│  Timestamp Difference                             │"
  echo "├───────────────────────────────────────────────────┤"
  printf "│  From:     %-39s │\n" "${ts1} (${human1})"
  printf "│  To:       %-39s │\n" "${ts2} (${human2})"
  echo "├───────────────────────────────────────────────────┤"
  printf "│  Seconds:  %-39s │\n" "${diff_seconds}"
  printf "│  Minutes:  %-39s │\n" "${diff_minutes}"
  printf "│  Hours:    %-39s │\n" "${diff_hours}"
  printf "│  Days:     %-39s │\n" "${diff_days}"
  printf "│  Duration: %-39s │\n" "${duration_str}"
  echo "└───────────────────────────────────────────────────┘"
}

cmd_add() {
  local ts="${1:-}"
  local secs="${2:-}"
  [[ -z "$ts" || -z "$secs" ]] && die "Usage: ${SCRIPT_NAME} add <timestamp> <seconds>"
  is_numeric "$ts" || die "Invalid timestamp: '${ts}'"
  is_numeric "$secs" || die "Invalid seconds: '${secs}'"

  local result=$(( ts + secs ))
  local human_original human_result
  human_original="$(date -d "@${ts}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null || date -r "${ts}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null)"
  human_result="$(date -d "@${result}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null || date -r "${result}" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null)"

  local duration_str
  duration_str="$(format_duration "$secs")"

  echo "┌───────────────────────────────────────────────────┐"
  echo "│  Timestamp Addition                               │"
  echo "├───────────────────────────────────────────────────┤"
  printf "│  Original: %-39s │\n" "${ts} (${human_original})"
  printf "│  Added:    %-39s │\n" "${secs} seconds (${duration_str})"
  printf "│  Result:   %-39s │\n" "${result} (${human_result})"
  echo "└───────────────────────────────────────────────────┘"
}

# ---------------------------------------------------------------------------
# Main dispatch
# ---------------------------------------------------------------------------

main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    now)      cmd_now "$@" ;;
    convert)  cmd_convert "$@" ;;
    from)     cmd_from "$@" ;;
    diff)     cmd_diff "$@" ;;
    add)      cmd_add "$@" ;;
    version)  echo "${SCRIPT_NAME} v${VERSION}" ;;
    help|--help|-h) usage ;;
    *)        die "Unknown command: '${cmd}'. Run '${SCRIPT_NAME} help' for usage." ;;
  esac
}

main "$@"
