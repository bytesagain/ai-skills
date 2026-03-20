#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="key"
DATA_DIR="$HOME/.local/share/key"
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
#
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_generate() {
    local type="${2:-}"
    local length="${3:-}"
    [ -z "$type" ] && die "Usage: $SCRIPT_NAME generate <type length>"
    openssl rand -"${2:-hex}" "${3:-32}"
}

cmd_store() {
    local name="${2:-}"
    local value="${3:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME store <name value>"
    echo "$3" | openssl enc -aes-256-cbc -pbkdf2 -pass pass:skillkey -out "$DATA_DIR/$2.enc" 2>/dev/null && echo "Stored: $2"
}

cmd_get() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME get <name>"
    openssl enc -aes-256-cbc -pbkdf2 -d -pass pass:skillkey -in "$DATA_DIR/$2.enc" 2>/dev/null || die "Key not found: $2"
}

cmd_list() {
    ls "$DATA_DIR"/*.enc 2>/dev/null | xargs -I{} basename {} .enc || echo "No keys stored"
}

cmd_delete() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME delete <name>"
    rm -f "$DATA_DIR/$2.enc" && echo "Deleted: $2"
}

cmd_rotate() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME rotate <name>"
    local val=$(openssl enc -aes-256-cbc -pbkdf2 -d -pass pass:skillkey -in "$DATA_DIR/$2.enc" 2>/dev/null); local new=$(openssl rand -hex 32); echo "$new" | openssl enc -aes-256-cbc -pbkdf2 -pass pass:skillkey -out "$DATA_DIR/$2.enc" 2>/dev/null && echo "Rotated: $2"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s %s\n" "generate <type length>" ""
    printf "  %-25s %s\n" "store <name value>" ""
    printf "  %-25s %s\n" "get <name>" ""
    printf "  %-25s %s\n" "list" ""
    printf "  %-25s %s\n" "delete <name>" ""
    printf "  %-25s %s\n" "rotate <name>" ""
    printf "  %-25s %s\n" "help" "Show this help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        generate) shift; cmd_generate "$@" ;;
        store) shift; cmd_store "$@" ;;
        get) shift; cmd_get "$@" ;;
        list) shift; cmd_list "$@" ;;
        delete) shift; cmd_delete "$@" ;;
        rotate) shift; cmd_rotate "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
