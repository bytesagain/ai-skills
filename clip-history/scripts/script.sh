#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="clip-history"
DATA_DIR="$HOME/.local/share/clip-history"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_save() {
    local text="${2:-}"
    [ -z "$text" ] && die "Usage: $SCRIPT_NAME save <text>"
    echo '{"ts":"'$(date +%s)'","text":"'$2'"}' >> $DATA_DIR/clips.jsonl && echo Saved
}

cmd_list() {
    local count="${2:-}"
    [ -z "$count" ] && die "Usage: $SCRIPT_NAME list <count>"
    tail -${2:-10} $DATA_DIR/clips.jsonl 2>/dev/null
}

cmd_search() {
    local query="${2:-}"
    [ -z "$query" ] && die "Usage: $SCRIPT_NAME search <query>"
    grep -i $2 $DATA_DIR/clips.jsonl 2>/dev/null || echo 'No matches'
}

cmd_get() {
    local id="${2:-}"
    [ -z "$id" ] && die "Usage: $SCRIPT_NAME get <id>"
    sed -n ${2}p $DATA_DIR/clips.jsonl 2>/dev/null
}

cmd_clear() {
    : > $DATA_DIR/clips.jsonl && echo Cleared
}

cmd_export() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME export <file>"
    cp $DATA_DIR/clips.jsonl $2 && echo 'Exported to $2'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "save <text>"
    printf "  %-25s\n" "list <count>"
    printf "  %-25s\n" "search <query>"
    printf "  %-25s\n" "get <id>"
    printf "  %-25s\n" "clear"
    printf "  %-25s\n" "export <file>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        save) shift; cmd_save "$@" ;;
        list) shift; cmd_list "$@" ;;
        search) shift; cmd_search "$@" ;;
        get) shift; cmd_get "$@" ;;
        clear) shift; cmd_clear "$@" ;;
        export) shift; cmd_export "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
