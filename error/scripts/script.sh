#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="error"
DATA_DIR="$HOME/.local/share/error"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_scan() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME scan <file>"
    for p in 22 80 443 8080 3306; do (echo >/dev/tcp/"$2"/$p) 2>/dev/null && echo "OPEN :$p"; done
}

cmd_count() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME count <file>"
    echo "Errors: $(grep -ci error "$2" 2>/dev/null || echo 0)"; echo "Warnings: $(grep -ci warn "$2" 2>/dev/null || echo 0)"
}

cmd_recent() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME recent <file>"
    find "${2:-.}" -type f -mtime -"${4:-1}" | head -20
}

cmd_unique() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME unique <file>"
    grep -i "error\|fail" "$2" | sort -u | head -20
}

cmd_context() {
    local file="${2:-}"
    local pattern="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME context <file pattern>"
    grep -B2 -A2 "$3" "$2" | head -30
}

cmd_report() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME report <file>"
    echo "=== Report ==="; echo "Lines: $(wc -l < "$2")"; echo "Errors: $(grep -ci error "$2" 2>/dev/null || echo 0)"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "scan <file>"
    printf "  %-25s\n" "count <file>"
    printf "  %-25s\n" "recent <file>"
    printf "  %-25s\n" "unique <file>"
    printf "  %-25s\n" "context <file pattern>"
    printf "  %-25s\n" "report <file>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        scan) shift; cmd_scan "$@" ;;
        count) shift; cmd_count "$@" ;;
        recent) shift; cmd_recent "$@" ;;
        unique) shift; cmd_unique "$@" ;;
        context) shift; cmd_context "$@" ;;
        report) shift; cmd_report "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
