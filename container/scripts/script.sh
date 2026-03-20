#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="container"
DATA_DIR="$HOME/.local/share/container"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_list() {
    ls "$DATA_DIR" 2>/dev/null || echo "Empty"
}

cmd_stats() {
    docker stats --no-stream 2>/dev/null || echo "Total events: $(wc -l < "$DATA_DIR/events.log" 2>/dev/null || echo 0)"
}

cmd_logs() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME logs <name>"
    docker logs --tail "${3:-50}" "$2" 2>/dev/null || tail -50 "$DATA_DIR/$2.log" 2>/dev/null
}

cmd_inspect() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME inspect <name>"
    docker inspect "$2" 2>/dev/null | head -30
}

cmd_cleanup() {
    docker system prune -f 2>/dev/null && echo "Cleaned"
}

cmd_images() {
    docker images 2>/dev/null || echo "docker not available"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "list"
    printf "  %-25s\n" "stats"
    printf "  %-25s\n" "logs <name>"
    printf "  %-25s\n" "inspect <name>"
    printf "  %-25s\n" "cleanup"
    printf "  %-25s\n" "images"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        list) shift; cmd_list "$@" ;;
        stats) shift; cmd_stats "$@" ;;
        logs) shift; cmd_logs "$@" ;;
        inspect) shift; cmd_inspect "$@" ;;
        cleanup) shift; cmd_cleanup "$@" ;;
        images) shift; cmd_images "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
