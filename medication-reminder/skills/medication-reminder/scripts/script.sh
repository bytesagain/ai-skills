#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="medication-reminder"
DATA_DIR="$HOME/.local/share/medication-reminder"
mkdir -p "$DATA_DIR"

#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_add() {
    local med="${2:-}"
    local dose="${3:-}"
    local frequency="${4:-}"
    [ -z "$med" ] && die "Usage: $SCRIPT_NAME add <med dose frequency>"
    echo '{"med":"'$2'","dose":"'$3'","freq":"'$4'","ts":"'$(date +%s)'"}' >> $DATA_DIR/meds.jsonl && echo 'Added $2'
}

cmd_list() {
    cat $DATA_DIR/meds.jsonl 2>/dev/null | tail -10
}

cmd_take() {
    local med="${2:-}"
    [ -z "$med" ] && die "Usage: $SCRIPT_NAME take <med>"
    echo '{"med":"'$2'","taken":"'$(date +%Y-%m-%d_%H:%M)'"}' >> $DATA_DIR/intake.jsonl && echo 'Logged: $2'
}

cmd_history() {
    local days="${2:-}"
    [ -z "$days" ] && die "Usage: $SCRIPT_NAME history <days>"
    tail -${2:-20} $DATA_DIR/intake.jsonl 2>/dev/null
}

cmd_schedule() {
    echo 'Current medication schedule:'
}

cmd_due() {
    echo 'Medications due now:'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "add <med dose frequency>"
    printf "  %-25s\n" "list"
    printf "  %-25s\n" "take <med>"
    printf "  %-25s\n" "history <days>"
    printf "  %-25s\n" "schedule"
    printf "  %-25s\n" "due"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        add) shift; cmd_add "$@" ;;
        list) shift; cmd_list "$@" ;;
        take) shift; cmd_take "$@" ;;
        history) shift; cmd_history "$@" ;;
        schedule) shift; cmd_schedule "$@" ;;
        due) shift; cmd_due "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
