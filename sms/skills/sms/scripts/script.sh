#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="sms"
DATA_DIR="$HOME/.local/share/sms"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_create() {
    local name="${2:-}"
    local text="${3:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME create <name text>"
    echo '{"name":"'$2'","text":"'$3'"}' >> $DATA_DIR/templates.jsonl && echo 'Created template: $2'
}

cmd_list() {
    cat $DATA_DIR/templates.jsonl 2>/dev/null | tail -20
}

cmd_preview() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME preview <name>"
    grep $2 $DATA_DIR/templates.jsonl 2>/dev/null | tail -1
}

cmd_send() {
    local name="${2:-}"
    local phone="${3:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME send <name phone>"
    echo 'Formatted message for $3 using template $2'
}

cmd_var() {
    local name="${2:-}"
    local key_val="${3:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME var <name key_val>"
    echo 'Variable substitution: $3 in template $2'
}

cmd_export() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME export <file>"
    cp $DATA_DIR/templates.jsonl $2 && echo Exported
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "create <name text>"
    printf "  %-25s\n" "list"
    printf "  %-25s\n" "preview <name>"
    printf "  %-25s\n" "send <name phone>"
    printf "  %-25s\n" "var <name key_val>"
    printf "  %-25s\n" "export <file>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        create) shift; cmd_create "$@" ;;
        list) shift; cmd_list "$@" ;;
        preview) shift; cmd_preview "$@" ;;
        send) shift; cmd_send "$@" ;;
        var) shift; cmd_var "$@" ;;
        export) shift; cmd_export "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
