#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="workflow-automator"
DATA_DIR="$HOME/.local/share/workflow-automator"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_create() {
    local name="${2:-}"
    local steps="${3:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME create <name steps>"
    echo '$3' | tr ';' '\n' > $DATA_DIR/$2.flow && echo 'Created workflow: $2'
}

cmd_run() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME run <name>"
    local i=0; while IFS= read -r step; do i=$((i+1)); echo "Step $i: $step"; eval "$step" || echo 'WARN: step failed'; done < $DATA_DIR/$2.flow
}

cmd_list() {
    ls $DATA_DIR/*.flow 2>/dev/null | xargs -I{} basename {} .flow || echo 'No workflows'
}

cmd_show() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME show <name>"
    cat -n $DATA_DIR/$2.flow 2>/dev/null || echo 'Not found'
}

cmd_log() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME log <name>"
    cat $DATA_DIR/$2.log 2>/dev/null || echo 'No log'
}

cmd_status() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME status <name>"
    [ -f $DATA_DIR/$2.flow ] && echo 'Exists: $2' || echo 'Not found: $2'
}

cmd_template() {
    local type="${2:-}"
    [ -z "$type" ] && die "Usage: $SCRIPT_NAME template <type>"
    case $2 in deploy) echo 'git pull;make build;make test;make deploy';; backup) echo 'tar czf backup.tar.gz .;scp backup.tar.gz server:';; *) echo 'Types: deploy, backup, release';; esac
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "create <name steps>"
    printf "  %-25s\n" "run <name>"
    printf "  %-25s\n" "list"
    printf "  %-25s\n" "show <name>"
    printf "  %-25s\n" "log <name>"
    printf "  %-25s\n" "status <name>"
    printf "  %-25s\n" "template <type>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        create) shift; cmd_create "$@" ;;
        run) shift; cmd_run "$@" ;;
        list) shift; cmd_list "$@" ;;
        show) shift; cmd_show "$@" ;;
        log) shift; cmd_log "$@" ;;
        status) shift; cmd_status "$@" ;;
        template) shift; cmd_template "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
