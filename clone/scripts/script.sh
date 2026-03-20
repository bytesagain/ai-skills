#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="clone"
DATA_DIR="$HOME/.local/share/clone"
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

cmd_dir() {
    local src="${2:-}"
    local dest="${3:-}"
    [ -z "$src" ] && die "Usage: $SCRIPT_NAME dir <src dest>"
    rsync -av "$2" "$3" && echo "Cloned $2 -> $3"
}

cmd_mirror() {
    local src="${2:-}"
    local dest="${3:-}"
    [ -z "$src" ] && die "Usage: $SCRIPT_NAME mirror <src dest>"
    rsync -av --delete "$2" "$3" && echo "Mirrored"
}

cmd_diff() {
    local dir1="${2:-}"
    local dir2="${3:-}"
    [ -z "$dir1" ] && die "Usage: $SCRIPT_NAME diff <dir1 dir2>"
    diff -rq "$2" "$3" 2>/dev/null | head -20
}

cmd_snapshot() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME snapshot <dir>"
    local snap="$DATA_DIR/snap_$(date +%Y%m%d_%H%M%S)"; cp -r "$2" "$snap" && echo "Snapshot: $snap"
}

cmd_list() {
    ls -dt "$DATA_DIR"/snap_* 2>/dev/null | head -10 || echo "No snapshots"
}

cmd_restore() {
    local snapshot="${2:-}"
    local dest="${3:-}"
    [ -z "$snapshot" ] && die "Usage: $SCRIPT_NAME restore <snapshot dest>"
    cp -r "$2" "$3" && echo "Restored to $3"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "dir <src dest>"
    printf "  %-25s\n" "mirror <src dest>"
    printf "  %-25s\n" "diff <dir1 dir2>"
    printf "  %-25s\n" "snapshot <dir>"
    printf "  %-25s\n" "list"
    printf "  %-25s\n" "restore <snapshot dest>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        dir) shift; cmd_dir "$@" ;;
        mirror) shift; cmd_mirror "$@" ;;
        diff) shift; cmd_diff "$@" ;;
        snapshot) shift; cmd_snapshot "$@" ;;
        list) shift; cmd_list "$@" ;;
        restore) shift; cmd_restore "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
