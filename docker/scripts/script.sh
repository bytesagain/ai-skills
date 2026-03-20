#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="docker"
DATA_DIR="$HOME/.local/share/docker"
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

cmd_ps() {
    docker ps 2>/dev/null || echo "docker not available"
}

cmd_images() {
    docker images 2>/dev/null || echo "docker not available"
}

cmd_volumes() {
    docker volume ls 2>/dev/null || echo "docker not available"
}

cmd_logs() {
    local container="${2:-}"
    [ -z "$container" ] && die "Usage: $SCRIPT_NAME logs <container>"
    docker logs --tail "${3:-50}" "$2" 2>/dev/null || tail -50 "$DATA_DIR/$2.log" 2>/dev/null
}

cmd_prune() {
    docker system prune -f 2>/dev/null && echo "Pruned"
}

cmd_stats() {
    docker stats --no-stream 2>/dev/null || echo "Total events: $(wc -l < "$DATA_DIR/events.log" 2>/dev/null || echo 0)"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "ps"
    printf "  %-25s\n" "images"
    printf "  %-25s\n" "volumes"
    printf "  %-25s\n" "logs <container>"
    printf "  %-25s\n" "prune"
    printf "  %-25s\n" "stats"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        ps) shift; cmd_ps "$@" ;;
        images) shift; cmd_images "$@" ;;
        volumes) shift; cmd_volumes "$@" ;;
        logs) shift; cmd_logs "$@" ;;
        prune) shift; cmd_prune "$@" ;;
        stats) shift; cmd_stats "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
