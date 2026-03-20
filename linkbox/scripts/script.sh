#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="linkbox"
DATA_DIR="$HOME/.local/share/linkbox"
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

cmd_add() {
    local url="${2:-}"
    local tag="${3:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME add <url tag>"
    echo '{"url":"'$2'","tag":"'${3:-untagged}'","ts":"'$(date +%s)'"}' >> $DATA_DIR/links.jsonl && echo 'Saved $2'
}

cmd_list() {
    local tag="${2:-}"
    [ -z "$tag" ] && die "Usage: $SCRIPT_NAME list <tag>"
    cat $DATA_DIR/links.jsonl 2>/dev/null | grep ${2:-} | tail -20
}

cmd_search() {
    local query="${2:-}"
    [ -z "$query" ] && die "Usage: $SCRIPT_NAME search <query>"
    grep -i $2 $DATA_DIR/links.jsonl 2>/dev/null
}

cmd_check() {
    while IFS= read -r line; do local url=$(echo $line | python3 -c 'import json,sys;print(json.load(sys.stdin)["url"])' 2>/dev/null); local code=$(curl -so /dev/null -w '%{http_code}' $url 2>/dev/null); echo "$code $url"; done < $DATA_DIR/links.jsonl
}

cmd_delete() {
    local id="${2:-}"
    [ -z "$id" ] && die "Usage: $SCRIPT_NAME delete <id>"
    sed -i ${2}d $DATA_DIR/links.jsonl 2>/dev/null && echo Deleted
}

cmd_export() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME export <file>"
    cp $DATA_DIR/links.jsonl $2 && echo 'Exported to $2'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "add <url tag>"
    printf "  %-25s\n" "list <tag>"
    printf "  %-25s\n" "search <query>"
    printf "  %-25s\n" "check"
    printf "  %-25s\n" "delete <id>"
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
        search) shift; cmd_search "$@" ;;
        check) shift; cmd_check "$@" ;;
        delete) shift; cmd_delete "$@" ;;
        export) shift; cmd_export "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
