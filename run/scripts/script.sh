#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="run"
DATA_DIR="$HOME/.local/share/run"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_exec() {
    local cmd="${2:-}"
    [ -z "$cmd" ] && die "Usage: $SCRIPT_NAME exec <cmd>"
    shift; eval "$@"
}

cmd_timed() {
    local cmd="${2:-}"
    [ -z "$cmd" ] && die "Usage: $SCRIPT_NAME timed <cmd>"
    shift; time eval "$@"
}

cmd_retry() {
    local count="${2:-}"
    local cmd="${3:-}"
    [ -z "$count" ] && die "Usage: $SCRIPT_NAME retry <count cmd>"
    local n="$2"; shift 2; for i in $(seq 1 "$n"); do eval "$@" && exit 0; echo "Retry $i/$n failed"; sleep 1; done; exit 1
}

cmd_parallel() {
    local cmd1="${2:-}"
    local cmd2="${3:-}"
    [ -z "$cmd1" ] && die "Usage: $SCRIPT_NAME parallel <cmd1 cmd2>"
    shift; eval "$2" & eval "$3" & wait
}

cmd_watch() {
    local interval="${2:-}"
    local cmd="${3:-}"
    [ -z "$interval" ] && die "Usage: $SCRIPT_NAME watch <interval cmd>"
    shift; while true; do clear; date; echo "---"; eval "$3"; sleep "$2"; done
}

cmd_log() {
    local cmd="${2:-}"
    [ -z "$cmd" ] && die "Usage: $SCRIPT_NAME log <cmd>"
    shift; eval "$@" 2>&1 | tee "$DATA_DIR/run_$(date +%s).log"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s %s\n" "exec <cmd>" ""
    printf "  %-25s %s\n" "timed <cmd>" ""
    printf "  %-25s %s\n" "retry <count cmd>" ""
    printf "  %-25s %s\n" "parallel <cmd1 cmd2>" ""
    printf "  %-25s %s\n" "watch <interval cmd>" ""
    printf "  %-25s %s\n" "log <cmd>" ""
    printf "  %-25s %s\n" "help" "Show this help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        exec) shift; cmd_exec "$@" ;;
        timed) shift; cmd_timed "$@" ;;
        retry) shift; cmd_retry "$@" ;;
        parallel) shift; cmd_parallel "$@" ;;
        watch) shift; cmd_watch "$@" ;;
        log) shift; cmd_log "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
