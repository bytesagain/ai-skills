#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="cron-expression"
DATA_DIR="$HOME/.local/share/cron-expression"
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

cmd_explain() {
    local expr="${2:-}"
    [ -z "$expr" ] && die "Usage: $SCRIPT_NAME explain <expr>"
    echo "Cron: $2"; echo "Fields: minute hour day month weekday"
}

cmd_validate() {
    local expr="${2:-}"
    [ -z "$expr" ] && die "Usage: $SCRIPT_NAME validate <expr>"
    echo $2 | grep -qE '^[0-9*,/-]+ [0-9*,/-]+ [0-9*,/-]+ [0-9*,/-]+ [0-9*,/-]+$' && echo Valid || echo Invalid
}

cmd_examples() {
    echo '*/5 * * * *  Every 5 minutes'; echo '0 9 * * 1-5  Weekdays 9am'; echo '0 0 1 * *    First of month'
}

cmd_next() {
    local expr="${2:-}"
    local count="${3:-}"
    [ -z "$expr" ] && die "Usage: $SCRIPT_NAME next <expr count>"
    echo 'Next ${3:-5} runs for: $2'
}

cmd_create() {
    local desc="${2:-}"
    [ -z "$desc" ] && die "Usage: $SCRIPT_NAME create <desc>"
    case $2 in hourly) echo '0 * * * *';; daily) echo '0 9 * * *';; weekly) echo '0 9 * * 1';; monthly) echo '0 9 1 * *';; esac
}

cmd_test() {
    local expr="${2:-}"
    [ -z "$expr" ] && die "Usage: $SCRIPT_NAME test <expr>"
    cmd_validate $2
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "explain <expr>"
    printf "  %-25s\n" "validate <expr>"
    printf "  %-25s\n" "examples"
    printf "  %-25s\n" "next <expr count>"
    printf "  %-25s\n" "create <desc>"
    printf "  %-25s\n" "test <expr>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        explain) shift; cmd_explain "$@" ;;
        validate) shift; cmd_validate "$@" ;;
        examples) shift; cmd_examples "$@" ;;
        next) shift; cmd_next "$@" ;;
        create) shift; cmd_create "$@" ;;
        test) shift; cmd_test "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
