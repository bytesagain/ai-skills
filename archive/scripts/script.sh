#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="archive"
DATA_DIR="$HOME/.local/share/archive"
mkdir -p "$DATA_DIR"

# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# archive — Create, extract, and manage compressed archives in tar and z
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_create() {
    local dir="${2:-}"
    local output="${3:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME create <dir output>"
    tar -czf "$3" "$2" && echo "Created: $3 ($(du -h "$3" | cut -f1))"
}

cmd_extract() {
    local file="${2:-}"
    local dir="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME extract <file dir>"
    mkdir -p "${3:-.}" && tar -xzf "$2" -C "${3:-.}" && echo 'Extracted'
}

cmd_list() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME list <file>"
    tar -tzf "$2" 2>/dev/null || unzip -l "$2" 2>/dev/null
}

cmd_info() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME info <file>"
    file "$2"; echo "Size: $(du -h "$2" | cut -f1)"; echo "Files: $(tar -tzf "$2" 2>/dev/null | wc -l)"
}

cmd_verify() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME verify <file>"
    gzip -t "$2" 2>/dev/null && echo 'OK' || echo 'Corrupted'
}

cmd_split() {
    local file="${2:-}"
    local size="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME split <file size>"
    split -b "${3:-100m}" "$2" "${2}.part." && echo 'Split complete'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "create <dir output>" ""
    printf "  %-20s %s\n" "extract <file dir>" ""
    printf "  %-20s %s\n" "list <file>" ""
    printf "  %-20s %s\n" "info <file>" ""
    printf "  %-20s %s\n" "verify <file>" ""
    printf "  %-20s %s\n" "split <file size>" ""
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
        create) shift; cmd_create "$@" ;;
        extract) shift; cmd_extract "$@" ;;
        list) shift; cmd_list "$@" ;;
        info) shift; cmd_info "$@" ;;
        verify) shift; cmd_verify "$@" ;;
        split) shift; cmd_split "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
