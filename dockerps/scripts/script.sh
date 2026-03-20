#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="dockerps"
DATA_DIR="$HOME/.local/share/dockerps"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_list() {
    docker ps -a --format 'table {{.Names}}	{{.Status}}	{{.Ports}}' 2>/dev/null || echo 'docker not available'
}

cmd_stats() {
    docker stats --no-stream 2>/dev/null || echo 'docker not available'
}

cmd_top() {
    local container="${2:-}"
    [ -z "$container" ] && die "Usage: $SCRIPT_NAME top <container>"
    docker top $2 2>/dev/null || echo 'Container not found'
}

cmd_logs() {
    local container="${2:-}"
    local lines="${3:-}"
    [ -z "$container" ] && die "Usage: $SCRIPT_NAME logs <container lines>"
    docker logs --tail ${3:-50} $2 2>/dev/null
}

cmd_inspect() {
    local container="${2:-}"
    [ -z "$container" ] && die "Usage: $SCRIPT_NAME inspect <container>"
    docker inspect $2 2>/dev/null | python3 -c 'import json,sys;d=json.load(sys.stdin)[0];print("Name:",d["Name"]);print("State:",d["State"]["Status"])' 2>/dev/null
}

cmd_cleanup() {
    docker container prune -f 2>/dev/null && docker image prune -f 2>/dev/null && echo Cleaned
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "list"
    printf "  %-25s\n" "stats"
    printf "  %-25s\n" "top <container>"
    printf "  %-25s\n" "logs <container lines>"
    printf "  %-25s\n" "inspect <container>"
    printf "  %-25s\n" "cleanup"
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
        top) shift; cmd_top "$@" ;;
        logs) shift; cmd_logs "$@" ;;
        inspect) shift; cmd_inspect "$@" ;;
        cleanup) shift; cmd_cleanup "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
