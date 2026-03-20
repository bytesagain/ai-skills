#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="policy-reader"
DATA_DIR="$HOME/.local/share/policy-reader"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_scan() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME scan <file>"
    echo '=== Policy Scan: $2 ==='; echo 'Words: '$(wc -w < $2); grep -ci 'data\|personal\|information\|collect\|share\|third.party' $2 | awk '{print "Privacy keywords: "$1}'
}

cmd_summary() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME summary <file>"
    head -20 $2; echo '...'
}

cmd_check() {
    local file="${2:-}"
    local keyword="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME check <file keyword>"
    grep -in $3 $2 | head -10
}

cmd_score() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME score <file>"
    local w=$(wc -w < $2); local k=$(grep -ci 'data\|privacy\|security' $2); awk "BEGIN{printf \"Readability: %d words, %d privacy terms\n\", $w, $k}"
}

cmd_compare() {
    local f1="${2:-}"
    local f2="${3:-}"
    [ -z "$f1" ] && die "Usage: $SCRIPT_NAME compare <f1 f2>"
    echo 'Words: '$(wc -w < $2)' vs '$(wc -w < $3)
}

cmd_extract() {
    local file="${2:-}"
    local section="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME extract <file section>"
    grep -A10 -i $3 $2 | head -15
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "scan <file>"
    printf "  %-25s\n" "summary <file>"
    printf "  %-25s\n" "check <file keyword>"
    printf "  %-25s\n" "score <file>"
    printf "  %-25s\n" "compare <f1 f2>"
    printf "  %-25s\n" "extract <file section>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        scan) shift; cmd_scan "$@" ;;
        summary) shift; cmd_summary "$@" ;;
        check) shift; cmd_check "$@" ;;
        score) shift; cmd_score "$@" ;;
        compare) shift; cmd_compare "$@" ;;
        extract) shift; cmd_extract "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
