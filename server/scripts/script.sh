#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="server"
DATA_DIR="$HOME/.local/share/server"
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

cmd_status() {
    uptime; echo '---'; free -h | head -2; echo '---'; df -h / | tail -1
}

cmd_cpu() {
    grep -c ^processor /proc/cpuinfo; cat /proc/loadavg
}

cmd_memory() {
    free -h
}

cmd_disk() {
    df -h
}

cmd_processes() {
    local n="${2:-}"
    [ -z "$n" ] && die "Usage: $SCRIPT_NAME processes <n>"
    ps aux --sort=-%mem | head -"${2:-11}"
}

cmd_uptime() {
    uptime -p 2>/dev/null || uptime
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s %s\n" "status" ""
    printf "  %-25s %s\n" "cpu" ""
    printf "  %-25s %s\n" "memory" ""
    printf "  %-25s %s\n" "disk" ""
    printf "  %-25s %s\n" "processes <n>" ""
    printf "  %-25s %s\n" "uptime" ""
    printf "  %-25s %s\n" "help" "Show this help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        status) shift; cmd_status "$@" ;;
        cpu) shift; cmd_cpu "$@" ;;
        memory) shift; cmd_memory "$@" ;;
        disk) shift; cmd_disk "$@" ;;
        processes) shift; cmd_processes "$@" ;;
        uptime) shift; cmd_uptime "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
