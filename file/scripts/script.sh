#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="file"
DATA_DIR="$HOME/.local/share/file"
mkdir -p "$DATA_DIR"

# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# file — Manage, organize, and inspect files with batch operations. U
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_info() {
    local path="${2:-}"
    [ -z "$path" ] && die "Usage: $SCRIPT_NAME info <path>"
    stat "$2" 2>/dev/null && file "$2"
}

cmd_find() {
    local pattern="${2:-}"
    local dir="${3:-}"
    [ -z "$pattern" ] && die "Usage: $SCRIPT_NAME find <pattern dir>"
    find "${3:-.}" -name "$2" 2>/dev/null
}

cmd_dupes() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME dupes <dir>"
    find "${2:-.}" -type f | xargs md5sum 2>/dev/null | sort | uniq -w32 -d
}

cmd_large() {
    local dir="${2:-}"
    local n="${3:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME large <dir n>"
    find "${2:-.}" -type f -printf '%s %p\n' 2>/dev/null | sort -rn | head -"${3:-10}"
}

cmd_recent() {
    local dir="${2:-}"
    local days="${3:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME recent <dir days>"
    find "${2:-.}" -type f -mtime -"${3:-7}" -printf '%T+ %p\n' 2>/dev/null | sort -r | head -20
}

cmd_tree() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME tree <dir>"
    find "${2:-.}" -maxdepth 3 | head -50 | sed 's|[^/]*/|  |g'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "info <path>" ""
    printf "  %-20s %s\n" "find <pattern dir>" ""
    printf "  %-20s %s\n" "dupes <dir>" ""
    printf "  %-20s %s\n" "large <dir n>" ""
    printf "  %-20s %s\n" "recent <dir days>" ""
    printf "  %-20s %s\n" "tree <dir>" ""
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
        info) shift; cmd_info "$@" ;;
        find) shift; cmd_find "$@" ;;
        dupes) shift; cmd_dupes "$@" ;;
        large) shift; cmd_large "$@" ;;
        recent) shift; cmd_recent "$@" ;;
        tree) shift; cmd_tree "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
