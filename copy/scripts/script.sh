#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="copy"
DATA_DIR="$HOME/.local/share/copy"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_file() {
    local src="${2:-}"
    local dest="${3:-}"
    [ -z "$src" ] && die "Usage: $SCRIPT_NAME file <src dest>"
    cp -v "$2" "$3"
}

cmd_dir() {
    local src="${2:-}"
    local dest="${3:-}"
    [ -z "$src" ] && die "Usage: $SCRIPT_NAME dir <src dest>"
    cp -rv "$2" "$3"
}

cmd_sync() {
    local src="${2:-}"
    local dest="${3:-}"
    [ -z "$src" ] && die "Usage: $SCRIPT_NAME sync <src dest>"
    rsync -avh --progress "$2" "$3"
}

cmd_verify() {
    local src="${2:-}"
    local dest="${3:-}"
    [ -z "$src" ] && die "Usage: $SCRIPT_NAME verify <src dest>"
    diff -q "$2" "$3" >/dev/null 2>&1 && echo "MATCH" || echo "DIFFER"
}

cmd_safe() {
    local src="${2:-}"
    local dest="${3:-}"
    [ -z "$src" ] && die "Usage: $SCRIPT_NAME safe <src dest>"
    [ -f "$3" ] && echo "EXISTS: $3" || cp -v "$2" "$3"
}

cmd_recent() {
    local dir="${2:-}"
    local dest="${3:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME recent <dir dest>"
    find "${2:-.}" -type f -mtime -"${4:-1}" | head -20
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "file <src dest>"
    printf "  %-25s\n" "dir <src dest>"
    printf "  %-25s\n" "sync <src dest>"
    printf "  %-25s\n" "verify <src dest>"
    printf "  %-25s\n" "safe <src dest>"
    printf "  %-25s\n" "recent <dir dest>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        file) shift; cmd_file "$@" ;;
        dir) shift; cmd_dir "$@" ;;
        sync) shift; cmd_sync "$@" ;;
        verify) shift; cmd_verify "$@" ;;
        safe) shift; cmd_safe "$@" ;;
        recent) shift; cmd_recent "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
