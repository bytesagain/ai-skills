#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="finder"
DATA_DIR="$HOME/.local/share/finder"
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

cmd_name() {
    local pattern="${2:-}"
    local dir="${3:-}"
    [ -z "$pattern" ] && die "Usage: $SCRIPT_NAME name <pattern dir>"
    find ${3:-.} -name $2 2>/dev/null | head -20
}

cmd_size() {
    local min="${2:-}"
    local dir="${3:-}"
    [ -z "$min" ] && die "Usage: $SCRIPT_NAME size <min dir>"
    find ${3:-.} -type f -size +${2:-1M} 2>/dev/null | head -20
}

cmd_recent() {
    local dir="${2:-}"
    local days="${3:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME recent <dir days>"
    find ${2:-.} -type f -mtime -${3:-7} 2>/dev/null | head -20
}

cmd_type() {
    local ext="${2:-}"
    local dir="${3:-}"
    [ -z "$ext" ] && die "Usage: $SCRIPT_NAME type <ext dir>"
    find ${3:-.} -name '*.$2' 2>/dev/null | head -20
}

cmd_empty() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME empty <dir>"
    find ${2:-.} -empty 2>/dev/null | head -20
}

cmd_large() {
    local dir="${2:-}"
    local count="${3:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME large <dir count>"
    find ${2:-.} -type f -printf '%s %p
' 2>/dev/null | sort -rn | head -${3:-10}
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "name <pattern dir>"
    printf "  %-25s\n" "size <min dir>"
    printf "  %-25s\n" "recent <dir days>"
    printf "  %-25s\n" "type <ext dir>"
    printf "  %-25s\n" "empty <dir>"
    printf "  %-25s\n" "large <dir count>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        name) shift; cmd_name "$@" ;;
        size) shift; cmd_size "$@" ;;
        recent) shift; cmd_recent "$@" ;;
        type) shift; cmd_type "$@" ;;
        empty) shift; cmd_empty "$@" ;;
        large) shift; cmd_large "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
