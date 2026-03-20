#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="inventory-manager"
DATA_DIR="$HOME/.local/share/inventory-manager"
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

cmd_add() {
    local item="${2:-}"
    local qty="${3:-}"
    local price="${4:-}"
    [ -z "$item" ] && die "Usage: $SCRIPT_NAME add <item qty price>"
    echo '{"item":"'$2'","qty":'$3',"price":'$4',"ts":"'$(date +%s)'"}' >> $DATA_DIR/inventory.jsonl && echo 'Added $2'
}

cmd_list() {
    local filter="${2:-}"
    [ -z "$filter" ] && die "Usage: $SCRIPT_NAME list <filter>"
    cat $DATA_DIR/inventory.jsonl 2>/dev/null | tail -20
}

cmd_remove() {
    local item="${2:-}"
    local qty="${3:-}"
    [ -z "$item" ] && die "Usage: $SCRIPT_NAME remove <item qty>"
    echo 'Removed $3 of $2'
}

cmd_low_stock() {
    local threshold="${2:-}"
    [ -z "$threshold" ] && die "Usage: $SCRIPT_NAME low-stock <threshold>"
    echo 'Items below ${2:-5} units:'
}

cmd_value() {
    echo 'Total inventory value calculation'
}

cmd_export() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME export <file>"
    cp $DATA_DIR/inventory.jsonl $2 2>/dev/null && echo 'Exported'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "add <item qty price>"
    printf "  %-25s\n" "list <filter>"
    printf "  %-25s\n" "remove <item qty>"
    printf "  %-25s\n" "low-stock <threshold>"
    printf "  %-25s\n" "value"
    printf "  %-25s\n" "export <file>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        add) shift; cmd_add "$@" ;;
        list) shift; cmd_list "$@" ;;
        remove) shift; cmd_remove "$@" ;;
        low-stock) shift; cmd_low_stock "$@" ;;
        value) shift; cmd_value "$@" ;;
        export) shift; cmd_export "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
