#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="download"
DATA_DIR="$HOME/.local/share/download"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_url() {
    local url="${2:-}"
    local output="${3:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME url <url output>"
    curl -L -o "${3:-$(basename "$2")}" "$2" && echo "Downloaded"
}

cmd_resume() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME resume <url>"
    curl -L -C - -o "$(basename "$2")" "$2"
}

cmd_batch() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME batch <file>"
    while IFS= read -r url; do curl -LO "$url" 2>/dev/null && echo "OK $url" || echo "FAIL $url"; done < "$2"
}

cmd_info() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME info <url>"
    curl -sI "$2" 2>/dev/null | grep -i "content-length\|content-type"
}

cmd_mirror() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME mirror <url>"
    wget -m -p -k "$2" 2>/dev/null || curl -LO "$2"
}

cmd_verify() {
    local file="${2:-}"
    local url="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME verify <file url>"
    diff -q "$2" "$3" >/dev/null 2>&1 && echo "MATCH" || echo "DIFFER"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "url <url output>"
    printf "  %-25s\n" "resume <url>"
    printf "  %-25s\n" "batch <file>"
    printf "  %-25s\n" "info <url>"
    printf "  %-25s\n" "mirror <url>"
    printf "  %-25s\n" "verify <file url>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        url) shift; cmd_url "$@" ;;
        resume) shift; cmd_resume "$@" ;;
        batch) shift; cmd_batch "$@" ;;
        info) shift; cmd_info "$@" ;;
        mirror) shift; cmd_mirror "$@" ;;
        verify) shift; cmd_verify "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
