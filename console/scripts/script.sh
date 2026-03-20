#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="console"
DATA_DIR="$HOME/.local/share/console"
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
#
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_table() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME table <file>"
    column -t -s, "$2" 2>/dev/null
}

cmd_banner() {
    local text="${2:-}"
    [ -z "$text" ] && die "Usage: $SCRIPT_NAME banner <text>"
    echo "========================================"; echo "  $2"; echo "========================================"
}

cmd_box() {
    local text="${2:-}"
    [ -z "$text" ] && die "Usage: $SCRIPT_NAME box <text>"
    echo "+$(printf -- "-%.0s" $(seq 1 $((${#2}+2))))+"; echo "| $2 |"; echo "+$(printf -- "-%.0s" $(seq 1 $((${#2}+2))))+"
}

cmd_color() {
    local text="${2:-}"
    local color="${3:-}"
    [ -z "$text" ] && die "Usage: $SCRIPT_NAME color <text color>"
    case "${3:-green}" in red) echo -e "\033[31m$2\033[0m";; green) echo -e "\033[32m$2\033[0m";; blue) echo -e "\033[34m$2\033[0m";; *) echo "$2";; esac
}

cmd_hr() {
    local length="${2:-}"
    [ -z "$length" ] && die "Usage: $SCRIPT_NAME hr <length>"
    printf "%0.s-" $(seq 1 "${2:-40}"); echo
}

cmd_list() {
    ls "$DATA_DIR" 2>/dev/null || echo "Empty"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "table <file>"
    printf "  %-25s\n" "banner <text>"
    printf "  %-25s\n" "box <text>"
    printf "  %-25s\n" "color <text color>"
    printf "  %-25s\n" "hr <length>"
    printf "  %-25s\n" "list"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        table) shift; cmd_table "$@" ;;
        banner) shift; cmd_banner "$@" ;;
        box) shift; cmd_box "$@" ;;
        color) shift; cmd_color "$@" ;;
        hr) shift; cmd_hr "$@" ;;
        list) shift; cmd_list "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
