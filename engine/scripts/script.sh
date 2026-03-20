#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="engine"
DATA_DIR="$HOME/.local/share/engine"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_time() {
    local cmd="${2:-}"
    [ -z "$cmd" ] && die "Usage: $SCRIPT_NAME time <cmd>"
    shift; time eval "$@"
}

cmd_profile() {
    local script="${2:-}"
    [ -z "$script" ] && die "Usage: $SCRIPT_NAME profile <script>"
    bash -x "$2" 2>&1 | head -50
}

cmd_compare() {
    local cmd1="${2:-}"
    local cmd2="${3:-}"
    [ -z "$cmd1" ] && die "Usage: $SCRIPT_NAME compare <cmd1 cmd2>"
    echo "=== CMD1 ==="; time eval "$2" 2>/dev/null; echo "=== CMD2 ==="; time eval "$3" 2>/dev/null
}

cmd_repeat() {
    local count="${2:-}"
    local cmd="${3:-}"
    [ -z "$count" ] && die "Usage: $SCRIPT_NAME repeat <count cmd>"
    shift 2; for i in $(seq 1 "$2"); do eval "$@"; done
}

cmd_stats() {
    local logfile="${2:-}"
    [ -z "$logfile" ] && die "Usage: $SCRIPT_NAME stats <logfile>"
    docker stats --no-stream 2>/dev/null || echo "Total events: $(wc -l < "$DATA_DIR/events.log" 2>/dev/null || echo 0)"
}

cmd_memory() {
    local cmd="${2:-}"
    [ -z "$cmd" ] && die "Usage: $SCRIPT_NAME memory <cmd>"
    shift; /usr/bin/time -v bash -c "$@" 2>&1 | grep -i memory || echo "time -v not available"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "time <cmd>"
    printf "  %-25s\n" "profile <script>"
    printf "  %-25s\n" "compare <cmd1 cmd2>"
    printf "  %-25s\n" "repeat <count cmd>"
    printf "  %-25s\n" "stats <logfile>"
    printf "  %-25s\n" "memory <cmd>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        time) shift; cmd_time "$@" ;;
        profile) shift; cmd_profile "$@" ;;
        compare) shift; cmd_compare "$@" ;;
        repeat) shift; cmd_repeat "$@" ;;
        stats) shift; cmd_stats "$@" ;;
        memory) shift; cmd_memory "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
