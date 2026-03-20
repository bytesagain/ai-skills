#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="daemon"
DATA_DIR="$HOME/.local/share/daemon"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_start() {
    local name="${2:-}"
    local cmd="${3:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME start <name cmd>"
    nohup bash -c "$3" > "$DATA_DIR/$2.log" 2>&1 & echo "$!" > "$DATA_DIR/$2.pid" && echo "Started $2 (PID: $!)"
}

cmd_stop() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME stop <name>"
    local pid; pid=$(cat "$DATA_DIR/$2.pid" 2>/dev/null || echo ""); [ -n "$pid" ] && kill "$pid" 2>/dev/null && rm -f "$DATA_DIR/$2.pid" && echo "Stopped $2" || echo "Not running: $2"
}

cmd_status() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME status <name>"
    local pid; pid=$(cat "$DATA_DIR/$2.pid" 2>/dev/null || echo ""); [ -n "$pid" ] && ps -p "$pid" >/dev/null 2>&1 && echo "Running: $2 (PID: $pid)" || echo "Stopped: $2"
}

cmd_list() {
    ls "$DATA_DIR" 2>/dev/null || echo "Empty"
}

cmd_log() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME log <name>"
    tail -"${3:-50}" "$DATA_DIR/$2.log" 2>/dev/null || echo "No log for $2"
}

cmd_restart() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME restart <name>"
    cmd_stop "$2" 2>/dev/null; sleep 1; echo "Restart: provide command manually"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "start <name cmd>"
    printf "  %-25s\n" "stop <name>"
    printf "  %-25s\n" "status <name>"
    printf "  %-25s\n" "list"
    printf "  %-25s\n" "log <name>"
    printf "  %-25s\n" "restart <name>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        start) shift; cmd_start "$@" ;;
        stop) shift; cmd_stop "$@" ;;
        status) shift; cmd_status "$@" ;;
        list) shift; cmd_list "$@" ;;
        log) shift; cmd_log "$@" ;;
        restart) shift; cmd_restart "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
