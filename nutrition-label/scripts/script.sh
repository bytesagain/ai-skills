#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="nutrition-label"
DATA_DIR="$HOME/.local/share/nutrition-label"
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
#
#
#
#
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_create() {
    local food="${2:-}"
    local cal="${3:-}"
    local protein="${4:-}"
    local carbs="${5:-}"
    local fat="${6:-}"
    [ -z "$food" ] && die "Usage: $SCRIPT_NAME create <food cal protein carbs fat>"
    printf '=== %s ===\nCalories: %s\nProtein: %sg\nCarbs: %sg\nFat: %sg\n' $2 $3 $4 $5 $6
}

cmd_lookup() {
    local food="${2:-}"
    [ -z "$food" ] && die "Usage: $SCRIPT_NAME lookup <food>"
    case $2 in apple) echo 'Apple: 95cal 0.5g protein 25g carbs 0.3g fat';; banana) echo 'Banana: 105cal 1.3g protein 27g carbs 0.4g fat';; egg) echo 'Egg: 78cal 6g protein 0.6g carbs 5g fat';; *) echo 'Food $2: lookup in database';; esac
}

cmd_daily() {
    echo 'Daily totals from intake log'
}

cmd_compare() {
    local f1="${2:-}"
    local f2="${3:-}"
    [ -z "$f1" ] && die "Usage: $SCRIPT_NAME compare <f1 f2>"
    echo 'Comparing $2 vs $3'
}

cmd_label() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME label <file>"
    cat $2 2>/dev/null
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "create <food cal protein carbs fat>"
    printf "  %-25s\n" "lookup <food>"
    printf "  %-25s\n" "daily"
    printf "  %-25s\n" "compare <f1 f2>"
    printf "  %-25s\n" "label <file>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        create) shift; cmd_create "$@" ;;
        lookup) shift; cmd_lookup "$@" ;;
        daily) shift; cmd_daily "$@" ;;
        compare) shift; cmd_compare "$@" ;;
        label) shift; cmd_label "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
