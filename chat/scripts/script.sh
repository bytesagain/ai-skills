#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="chat"
DATA_DIR="$HOME/.local/share/chat"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_send() {
    local channel="${2:-}"
    local message="${3:-}"
    [ -z "$channel" ] && die "Usage: $SCRIPT_NAME send <channel message>"
    mkdir -p "$DATA_DIR/channels/$2" && echo "$(date +%H:%M) $3" >> "$DATA_DIR/channels/$2/log.txt" && _info "Sent to #$2"
}

cmd_read() {
    local channel="${2:-}"
    [ -z "$channel" ] && die "Usage: $SCRIPT_NAME read <channel>"
    tail -"${3:-20}" "$DATA_DIR/channels/$2/log.txt" 2>/dev/null || echo "No messages"
}

cmd_channels() {
    ls -d "$DATA_DIR/channels/"*/ 2>/dev/null | xargs -I{} basename {} || echo "No channels"
}

cmd_search() {
    local query="${2:-}"
    [ -z "$query" ] && die "Usage: $SCRIPT_NAME search <query>"
    grep -rn "$2" "$DATA_DIR/channels/" 2>/dev/null || echo "No matches"
}

cmd_export() {
    local channel="${2:-}"
    local file="${3:-}"
    [ -z "$channel" ] && die "Usage: $SCRIPT_NAME export <channel file>"
    cp "$DATA_DIR/channels/$2/log.txt" "$3" 2>/dev/null && echo "Exported to $3"
}

cmd_clear() {
    local channel="${2:-}"
    [ -z "$channel" ] && die "Usage: $SCRIPT_NAME clear <channel>"
    : > "$DATA_DIR/channels/$2/log.txt" 2>/dev/null && echo "Cleared #$2"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "send <channel message>"
    printf "  %-25s\n" "read <channel>"
    printf "  %-25s\n" "channels"
    printf "  %-25s\n" "search <query>"
    printf "  %-25s\n" "export <channel file>"
    printf "  %-25s\n" "clear <channel>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        send) shift; cmd_send "$@" ;;
        read) shift; cmd_read "$@" ;;
        channels) shift; cmd_channels "$@" ;;
        search) shift; cmd_search "$@" ;;
        export) shift; cmd_export "$@" ;;
        clear) shift; cmd_clear "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
