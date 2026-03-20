#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="edit"
DATA_DIR="$HOME/.local/share/edit"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_replace() {
    local file="${2:-}"
    local old="${3:-}"
    local new="${4:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME replace <file old new>"
    sed -i "s/$3/$4/g" "$2" && echo "Replaced in $2"
}

cmd_append() {
    local file="${2:-}"
    local text="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME append <file text>"
    echo "$3" >> "$2" && echo "Appended"
}

cmd_prepend() {
    local file="${2:-}"
    local text="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME prepend <file text>"
    local tmp; tmp=$(mktemp); echo "$3" > "$tmp"; cat "$2" >> "$tmp"; mv "$tmp" "$2" && echo "Prepended"
}

cmd_trim() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME trim <file>"
    sed -i "s/[[:space:]]*$//" "$2" && echo "Trimmed $2"
}

cmd_lower() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME lower <file>"
    tr "[:upper:]" "[:lower:]" < "$2"
}

cmd_upper() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME upper <file>"
    tr "[:lower:]" "[:upper:]" < "$2"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "replace <file old new>"
    printf "  %-25s\n" "append <file text>"
    printf "  %-25s\n" "prepend <file text>"
    printf "  %-25s\n" "trim <file>"
    printf "  %-25s\n" "lower <file>"
    printf "  %-25s\n" "upper <file>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        replace) shift; cmd_replace "$@" ;;
        append) shift; cmd_append "$@" ;;
        prepend) shift; cmd_prepend "$@" ;;
        trim) shift; cmd_trim "$@" ;;
        lower) shift; cmd_lower "$@" ;;
        upper) shift; cmd_upper "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
