#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="batch"
DATA_DIR="$HOME/.local/share/batch"
mkdir -p "$DATA_DIR"

# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# batch — Process files in bulk with rename, convert, and compress ope
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_rename() {
    local dir="${2:-}"
    local from="${3:-}"
    local to="${4:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME rename <dir from to>"
    find "$2" -name "*$3*" | while read f; do mv "$f" "${f/$3/$4}"; echo "Renamed: $f"; done
}

cmd_compress() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME compress <dir>"
    find "$2" -type f -size +1M | while read f; do gzip -k "$f" 2>/dev/null && echo "Compressed: $f"; done
}

cmd_count() {
    local dir="${2:-}"
    local ext="${3:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME count <dir ext>"
    find "$2" -name "*.$3" | wc -l | awk '{print $1" files"}'
}

cmd_list() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME list <dir>"
    find "$2" -type f -printf '%s %p\n' | sort -rn | head -20
}

cmd_delete_empty() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME delete-empty <dir>"
    find "$2" -type f -empty -delete -print
}

cmd_total_size() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME total-size <dir>"
    du -sh "$2" | cut -f1
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "rename <dir from to>" ""
    printf "  %-20s %s\n" "compress <dir>" ""
    printf "  %-20s %s\n" "count <dir ext>" ""
    printf "  %-20s %s\n" "list <dir>" ""
    printf "  %-20s %s\n" "delete-empty <dir>" ""
    printf "  %-20s %s\n" "total-size <dir>" ""
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
        rename) shift; cmd_rename "$@" ;;
        compress) shift; cmd_compress "$@" ;;
        count) shift; cmd_count "$@" ;;
        list) shift; cmd_list "$@" ;;
        delete-empty) shift; cmd_delete_empty "$@" ;;
        total-size) shift; cmd_total_size "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
