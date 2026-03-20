#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="sketch"
DATA_DIR="$HOME/.local/share/sketch"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_box() {
    local text="${2:-}"
    [ -z "$text" ] && die "Usage: $SCRIPT_NAME box <text>"
    echo '+---+'; echo '| '$2' |'; echo '+---+'
}

cmd_table() {
    local data="${2:-}"
    [ -z "$data" ] && die "Usage: $SCRIPT_NAME table <data>"
    echo '$2' | column -t -s, 2>/dev/null || echo '$2'
}

cmd_tree() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME tree <dir>"
    find ${2:-.} -maxdepth 3 | head -30 | sed 's|[^/]*/|  |g'
}

cmd_banner() {
    local text="${2:-}"
    [ -z "$text" ] && die "Usage: $SCRIPT_NAME banner <text>"
    echo '################################'; echo '#  '$2; echo '################################'
}

cmd_line() {
    local length="${2:-}"
    local char="${3:-}"
    [ -z "$length" ] && die "Usage: $SCRIPT_NAME line <length char>"
    printf '%0.s${3:--}' $(seq 1 ${2:-40}); echo
}

cmd_flowchart() {
    local steps="${2:-}"
    [ -z "$steps" ] && die "Usage: $SCRIPT_NAME flowchart <steps>"
    echo '[$2]'; echo '  |'; echo '  v'
}

cmd_border() {
    local text="${2:-}"
    local style="${3:-}"
    [ -z "$text" ] && die "Usage: $SCRIPT_NAME border <text style>"
    echo '=== '$2' ==='
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "box <text>"
    printf "  %-25s\n" "table <data>"
    printf "  %-25s\n" "tree <dir>"
    printf "  %-25s\n" "banner <text>"
    printf "  %-25s\n" "line <length char>"
    printf "  %-25s\n" "flowchart <steps>"
    printf "  %-25s\n" "border <text style>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        box) shift; cmd_box "$@" ;;
        table) shift; cmd_table "$@" ;;
        tree) shift; cmd_tree "$@" ;;
        banner) shift; cmd_banner "$@" ;;
        line) shift; cmd_line "$@" ;;
        flowchart) shift; cmd_flowchart "$@" ;;
        border) shift; cmd_border "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
