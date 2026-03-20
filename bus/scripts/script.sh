#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="bus"
DATA_DIR="$HOME/.local/share/bus"
mkdir -p "$DATA_DIR"

# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# bus — Publish and subscribe to local message topics using file-bas
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_publish() {
    local topic="${2:-}"
    local message="${3:-}"
    [ -z "$topic" ] && die "Usage: $SCRIPT_NAME publish <topic message>"
    mkdir -p "$DATA_DIR/topics/$2" && echo "$3" > "$DATA_DIR/topics/$2/$(date +%s%N).msg" && echo 'Published to $2'
}

cmd_subscribe() {
    local topic="${2:-}"
    [ -z "$topic" ] && die "Usage: $SCRIPT_NAME subscribe <topic>"
    ls -1t "$DATA_DIR/topics/$2/"*.msg 2>/dev/null | head -10 | while read f; do cat "$f"; done || echo 'No messages'
}

cmd_topics() {
    ls -1 "$DATA_DIR/topics/" 2>/dev/null || echo 'No topics'
}

cmd_messages() {
    local topic="${2:-}"
    local count="${3:-}"
    [ -z "$topic" ] && die "Usage: $SCRIPT_NAME messages <topic count>"
    ls -1t "$DATA_DIR/topics/$2/"*.msg 2>/dev/null | head -"${3:-5}" | while read f; do echo "$(basename $f .msg): $(cat $f)"; done
}

cmd_purge() {
    local topic="${2:-}"
    [ -z "$topic" ] && die "Usage: $SCRIPT_NAME purge <topic>"
    rm -f "$DATA_DIR/topics/$2/"*.msg 2>/dev/null && echo 'Purged $2'
}

cmd_stats() {
    for t in $(ls "$DATA_DIR/topics/" 2>/dev/null); do echo "$t: $(ls "$DATA_DIR/topics/$t/"*.msg 2>/dev/null | wc -l) messages"; done
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "publish <topic message>" ""
    printf "  %-20s %s\n" "subscribe <topic>" ""
    printf "  %-20s %s\n" "topics" ""
    printf "  %-20s %s\n" "messages <topic count>" ""
    printf "  %-20s %s\n" "purge <topic>" ""
    printf "  %-20s %s\n" "stats" ""
    printf "  %-20s %s\n" "help" "Show this help"
    printf "  %-20s %s\n" "version" "Show version"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() {
    echo "$SCRIPT_NAME v$VERSION"
}

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        publish) shift; cmd_publish "$@" ;;
        subscribe) shift; cmd_subscribe "$@" ;;
        topics) shift; cmd_topics "$@" ;;
        messages) shift; cmd_messages "$@" ;;
        purge) shift; cmd_purge "$@" ;;
        stats) shift; cmd_stats "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
