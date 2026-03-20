#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="graphql-builder"
DATA_DIR="$HOME/.local/share/graphql-builder"
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

cmd_query() {
    local type="${2:-}"
    local fields="${3:-}"
    [ -z "$type" ] && die "Usage: $SCRIPT_NAME query <type fields>"
    echo 'query { $2 { $3 } }'
}

cmd_mutation() {
    local type="${2:-}"
    local fields="${3:-}"
    [ -z "$type" ] && die "Usage: $SCRIPT_NAME mutation <type fields>"
    echo 'mutation { create$2(input: {$3}) { id } }'
}

cmd_validate() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME validate <file>"
    [ -f $2 ] && grep -q 'query\|mutation\|type' $2 && echo 'Valid GraphQL file' || echo 'Invalid'
}

cmd_format() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME format <file>"
    cat $2 2>/dev/null | sed 's/{/{
  /g' | sed 's/}/
}/g'
}

cmd_introspect() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME introspect <url>"
    curl -s -X POST -H 'Content-Type: application/json' -d '{"query":"{__schema{types{name}}}"}' $2 2>/dev/null
}

cmd_schema() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME schema <file>"
    cat $2 2>/dev/null | grep -E '^type |^input |^enum ' | head -20
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "query <type fields>"
    printf "  %-25s\n" "mutation <type fields>"
    printf "  %-25s\n" "validate <file>"
    printf "  %-25s\n" "format <file>"
    printf "  %-25s\n" "introspect <url>"
    printf "  %-25s\n" "schema <file>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        query) shift; cmd_query "$@" ;;
        mutation) shift; cmd_mutation "$@" ;;
        validate) shift; cmd_validate "$@" ;;
        format) shift; cmd_format "$@" ;;
        introspect) shift; cmd_introspect "$@" ;;
        schema) shift; cmd_schema "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
