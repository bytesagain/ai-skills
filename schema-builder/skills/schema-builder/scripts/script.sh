#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="schema-builder"
DATA_DIR="$HOME/.local/share/schema-builder"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_create() {
    local table="${2:-}"
    local cols="${3:-}"
    [ -z "$table" ] && die "Usage: $SCRIPT_NAME create <table cols>"
    echo 'CREATE TABLE $2 ('; echo '  id INTEGER PRIMARY KEY,'; echo '  $3'; echo ');'
}

cmd_alter() {
    local table="${2:-}"
    local action="${3:-}"
    local col="${4:-}"
    [ -z "$table" ] && die "Usage: $SCRIPT_NAME alter <table action col>"
    echo 'ALTER TABLE $2 $3 COLUMN $4;'
}

cmd_show() {
    local table="${2:-}"
    [ -z "$table" ] && die "Usage: $SCRIPT_NAME show <table>"
    echo 'DESCRIBE $2;'
}

cmd_export() {
    local format="${2:-}"
    [ -z "$format" ] && die "Usage: $SCRIPT_NAME export <format>"
    case $2 in sql) echo 'Exporting as SQL';; json) echo 'Exporting as JSON schema';; *) echo 'Formats: sql, json';; esac
}

cmd_validate() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME validate <file>"
    [ -f $2 ] && grep -qi 'create table\|alter table' $2 && echo 'Valid SQL schema' || echo 'No SQL found'
}

cmd_er() {
    local t1="${2:-}"
    local t2="${3:-}"
    local relation="${4:-}"
    [ -z "$t1" ] && die "Usage: $SCRIPT_NAME er <t1 t2 relation>"
    echo '$2 --[$3]--> $4'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "create <table cols>"
    printf "  %-25s\n" "alter <table action col>"
    printf "  %-25s\n" "show <table>"
    printf "  %-25s\n" "export <format>"
    printf "  %-25s\n" "validate <file>"
    printf "  %-25s\n" "er <t1 t2 relation>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        create) shift; cmd_create "$@" ;;
        alter) shift; cmd_alter "$@" ;;
        show) shift; cmd_show "$@" ;;
        export) shift; cmd_export "$@" ;;
        validate) shift; cmd_validate "$@" ;;
        er) shift; cmd_er "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
