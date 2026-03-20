#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="lyrics"
DATA_DIR="$HOME/.local/share/lyrics"
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

cmd_save() {
    local artist="${2:-}"
    local title="${3:-}"
    [ -z "$artist" ] && die "Usage: $SCRIPT_NAME save <artist title>"
    echo 'Saved: $2 - $3' && echo '{"artist":"'$2'","title":"'$3'","ts":"'$(date +%s)'"}' >> $DATA_DIR/lyrics.jsonl
}

cmd_list() {
    cat $DATA_DIR/lyrics.jsonl 2>/dev/null | tail -20
}

cmd_search() {
    local query="${2:-}"
    [ -z "$query" ] && die "Usage: $SCRIPT_NAME search <query>"
    grep -i $2 $DATA_DIR/lyrics.jsonl 2>/dev/null
}

cmd_random() {
    shuf -n1 $DATA_DIR/lyrics.jsonl 2>/dev/null || echo 'No lyrics saved'
}

cmd_export() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME export <file>"
    cp $DATA_DIR/lyrics.jsonl $2 && echo Exported
}

cmd_stats() {
    echo 'Songs: '$(wc -l < $DATA_DIR/lyrics.jsonl 2>/dev/null || echo 0)
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "save <artist title>"
    printf "  %-25s\n" "list"
    printf "  %-25s\n" "search <query>"
    printf "  %-25s\n" "random"
    printf "  %-25s\n" "export <file>"
    printf "  %-25s\n" "stats"
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
        random) shift; cmd_random "$@" ;;
        export) shift; cmd_export "$@" ;;
        stats) shift; cmd_stats "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
