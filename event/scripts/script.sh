#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="event"
DATA_DIR="$HOME/.local/share/event"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_add() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME add <name>"
    echo "$(date +%Y-%m-%d_%H:%M) $2" >> "$DATA_DIR/events.log" && echo "Logged: $2"
}

cmd_list() {
    ls "$DATA_DIR" 2>/dev/null || echo "Empty"
}

cmd_search() {
    local query="${2:-}"
    [ -z "$query" ] && die "Usage: $SCRIPT_NAME search <query>"
    grep -i "$2" "$DATA_DIR/events.log" 2>/dev/null || echo "No matches"
}

cmd_today() {
    grep "$(date +%Y-%m-%d)" "$DATA_DIR/events.log" 2>/dev/null || echo "No events today"
}

cmd_stats() {
    docker stats --no-stream 2>/dev/null || echo "Total events: $(wc -l < "$DATA_DIR/events.log" 2>/dev/null || echo 0)"
}

cmd_export() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME export <file>"
    cp "$DATA_DIR/events.log" "$2" 2>/dev/null && echo "Exported to $2"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "add <name>"
    printf "  %-25s\n" "list"
    printf "  %-25s\n" "search <query>"
    printf "  %-25s\n" "today"
    printf "  %-25s\n" "stats"
    printf "  %-25s\n" "export <file>"
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
        search) shift; cmd_search "$@" ;;
        today) shift; cmd_today "$@" ;;
        stats) shift; cmd_stats "$@" ;;
        export) shift; cmd_export "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
