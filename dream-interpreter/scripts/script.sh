#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="dream-interpreter"
DATA_DIR="$HOME/.local/share/dream-interpreter"
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

cmd_interpret() {
    local symbol="${2:-}"
    [ -z "$symbol" ] && die "Usage: $SCRIPT_NAME interpret <symbol>"
    case $2 in water) echo 'Water: emotions, subconscious';; flying) echo 'Flying: freedom, ambition';; falling) echo 'Falling: anxiety, loss of control';; teeth) echo 'Teeth: self-image, communication';; snake) echo 'Snake: transformation, fear';; *) echo 'Symbol $2: search for personal meaning';; esac
}

cmd_journal() {
    local text="${2:-}"
    [ -z "$text" ] && die "Usage: $SCRIPT_NAME journal <text>"
    echo '{"date":"'$(date +%Y-%m-%d)'","dream":"'$2'"}' >> $DATA_DIR/journal.jsonl && echo 'Logged dream'
}

cmd_history() {
    cat $DATA_DIR/journal.jsonl 2>/dev/null | tail -10
}

cmd_search() {
    local keyword="${2:-}"
    [ -z "$keyword" ] && die "Usage: $SCRIPT_NAME search <keyword>"
    grep -i $2 $DATA_DIR/journal.jsonl 2>/dev/null
}

cmd_categories() {
    echo 'Common categories: water, flying, falling, teeth, snake, chase, death, animals, house, road'
}

cmd_random() {
    shuf -n1 -e water flying falling teeth snake chase death animals house road | xargs -I{} bash $0 interpret {}
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "interpret <symbol>"
    printf "  %-25s\n" "journal <text>"
    printf "  %-25s\n" "history"
    printf "  %-25s\n" "search <keyword>"
    printf "  %-25s\n" "categories"
    printf "  %-25s\n" "random"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        interpret) shift; cmd_interpret "$@" ;;
        journal) shift; cmd_journal "$@" ;;
        history) shift; cmd_history "$@" ;;
        search) shift; cmd_search "$@" ;;
        categories) shift; cmd_categories "$@" ;;
        random) shift; cmd_random "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
