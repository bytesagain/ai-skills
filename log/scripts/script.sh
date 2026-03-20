#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="log"
DATA_DIR="$HOME/.local/share/log"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_tail() {
    local file="${2:-}"
    local lines="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME tail <file lines>"
    tail -"${3:-50}" "$2"
}

cmd_search() {
    local pattern="${2:-}"
    local file="${3:-}"
    [ -z "$pattern" ] && die "Usage: $SCRIPT_NAME search <pattern file>"
    grep -n --color=auto "$2" "$3"
}

cmd_errors() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME errors <file>"
    grep -i "error\|fail\|fatal\|exception\|panic" "$2" | tail -20
}

cmd_stats() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME stats <file>"
    echo "Lines: $(wc -l < "$2")"; echo "Size: $(du -h "$2" | cut -f1)"; echo "Errors: $(grep -ci "error\|fail" "$2" 2>/dev/null || echo 0)"
}

cmd_filter() {
    local file="${2:-}"
    local level="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME filter <file level>"
    grep -i "\[$3\]\|$3:" "$2"
}

cmd_between() {
    local file="${2:-}"
    local start="${3:-}"
    local end="${4:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME between <file start end>"
    awk "/$3/,/$4/" "$2"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s %s\n" "tail <file lines>" ""
    printf "  %-25s %s\n" "search <pattern file>" ""
    printf "  %-25s %s\n" "errors <file>" ""
    printf "  %-25s %s\n" "stats <file>" ""
    printf "  %-25s %s\n" "filter <file level>" ""
    printf "  %-25s %s\n" "between <file start end>" ""
    printf "  %-25s %s\n" "help" "Show this help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        tail) shift; cmd_tail "$@" ;;
        search) shift; cmd_search "$@" ;;
        errors) shift; cmd_errors "$@" ;;
        stats) shift; cmd_stats "$@" ;;
        filter) shift; cmd_filter "$@" ;;
        between) shift; cmd_between "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
