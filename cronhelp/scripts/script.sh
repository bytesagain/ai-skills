#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="cronhelp"
DATA_DIR="$HOME/.local/share/cronhelp"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_list() {
    crontab -l 2>/dev/null || echo 'No crontab'
}

cmd_add() {
    local schedule="${2:-}"
    local command="${3:-}"
    [ -z "$schedule" ] && die "Usage: $SCRIPT_NAME add <schedule command>"
    (crontab -l 2>/dev/null; echo "$2 $3") | crontab - && echo Added
}

cmd_remove() {
    local number="${2:-}"
    [ -z "$number" ] && die "Usage: $SCRIPT_NAME remove <number>"
    crontab -l 2>/dev/null | sed ${2}d | crontab - && echo 'Removed line $2'
}

cmd_log() {
    local lines="${2:-}"
    [ -z "$lines" ] && die "Usage: $SCRIPT_NAME log <lines>"
    tail -${2:-20} /var/log/syslog 2>/dev/null | grep -i cron || echo 'No cron logs found'
}

cmd_test() {
    local command="${2:-}"
    [ -z "$command" ] && die "Usage: $SCRIPT_NAME test <command>"
    echo 'Testing: $2'; eval $2
}

cmd_backup() {
    crontab -l > $DATA_DIR/crontab_backup_$(date +%Y%m%d).txt 2>/dev/null && echo Backed up
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "list"
    printf "  %-25s\n" "add <schedule command>"
    printf "  %-25s\n" "remove <number>"
    printf "  %-25s\n" "log <lines>"
    printf "  %-25s\n" "test <command>"
    printf "  %-25s\n" "backup"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        list) shift; cmd_list "$@" ;;
        add) shift; cmd_add "$@" ;;
        remove) shift; cmd_remove "$@" ;;
        log) shift; cmd_log "$@" ;;
        test) shift; cmd_test "$@" ;;
        backup) shift; cmd_backup "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
