#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="mealplan"
DATA_DIR="$HOME/.local/share/mealplan"
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

cmd_add() {
    local meal="${2:-}"
    local calories="${3:-}"
    local type="${4:-}"
    [ -z "$meal" ] && die "Usage: $SCRIPT_NAME add <meal calories type>"
    echo '{"meal":"'$2'","cal":'$3',"type":"'${4:-lunch}'","date":"'$(date +%Y-%m-%d)'"}' >> $DATA_DIR/meals.jsonl && echo Added
}

cmd_list() {
    local day="${2:-}"
    [ -z "$day" ] && die "Usage: $SCRIPT_NAME list <day>"
    grep ${2:-$(date +%Y-%m-%d)} $DATA_DIR/meals.jsonl 2>/dev/null || echo 'No meals planned'
}

cmd_plan() {
    local days="${2:-}"
    [ -z "$days" ] && die "Usage: $SCRIPT_NAME plan <days>"
    echo 'Meal plan for ${2:-7} days'
}

cmd_nutrition() {
    local day="${2:-}"
    [ -z "$day" ] && die "Usage: $SCRIPT_NAME nutrition <day>"
    echo 'Nutrition for ${2:-today}'
}

cmd_shopping() {
    local days="${2:-}"
    [ -z "$days" ] && die "Usage: $SCRIPT_NAME shopping <days>"
    echo 'Shopping list for ${2:-7} days'
}

cmd_random() {
    local type="${2:-}"
    [ -z "$type" ] && die "Usage: $SCRIPT_NAME random <type>"
    echo 'Random ${2:-lunch} suggestion: check your meal history'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "add <meal calories type>"
    printf "  %-25s\n" "list <day>"
    printf "  %-25s\n" "plan <days>"
    printf "  %-25s\n" "nutrition <day>"
    printf "  %-25s\n" "shopping <days>"
    printf "  %-25s\n" "random <type>"
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
        plan) shift; cmd_plan "$@" ;;
        nutrition) shift; cmd_nutrition "$@" ;;
        shopping) shift; cmd_shopping "$@" ;;
        random) shift; cmd_random "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
