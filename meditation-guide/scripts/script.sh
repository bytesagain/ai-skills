#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="meditation-guide"
DATA_DIR="$HOME/.local/share/meditation-guide"
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

cmd_breathe() {
    local pattern="${2:-}"
    [ -z "$pattern" ] && die "Usage: $SCRIPT_NAME breathe <pattern>"
    echo 'Breathing (${2:-4-7-8}): Inhale ${2%%[-_]*}s, Hold, Exhale'; echo 'Press Ctrl+C to stop'
}

cmd_timer() {
    local minutes="${2:-}"
    [ -z "$minutes" ] && die "Usage: $SCRIPT_NAME timer <minutes>"
    echo 'Meditation timer: ${2:-10} minutes'; echo 'Starting...'; sleep $((${2:-10}*60)) 2>/dev/null && echo 'Session complete'
}

cmd_guide() {
    local type="${2:-}"
    [ -z "$type" ] && die "Usage: $SCRIPT_NAME guide <type>"
    case ${2:-calm} in calm) echo 'Focus on breath. Let thoughts pass like clouds.';; focus) echo 'Choose one point of focus. Return gently when distracted.';; *) echo 'Available: calm, focus, sleep, body-scan';; esac
}

cmd_history() {
    cat $DATA_DIR/sessions.jsonl 2>/dev/null | tail -10
}

cmd_streak() {
    echo 'Sessions: '$(wc -l < $DATA_DIR/sessions.jsonl 2>/dev/null || echo 0)
}

cmd_start() {
    local minutes="${2:-}"
    [ -z "$minutes" ] && die "Usage: $SCRIPT_NAME start <minutes>"
    echo '{"duration":'${2:-10}',"date":"'$(date +%Y-%m-%d)'"}' >> $DATA_DIR/sessions.jsonl && echo 'Session logged'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "breathe <pattern>"
    printf "  %-25s\n" "timer <minutes>"
    printf "  %-25s\n" "guide <type>"
    printf "  %-25s\n" "history"
    printf "  %-25s\n" "streak"
    printf "  %-25s\n" "start <minutes>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        breathe) shift; cmd_breathe "$@" ;;
        timer) shift; cmd_timer "$@" ;;
        guide) shift; cmd_guide "$@" ;;
        history) shift; cmd_history "$@" ;;
        streak) shift; cmd_streak "$@" ;;
        start) shift; cmd_start "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
