#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="api"
DATA_DIR="$HOME/.local/share/api"
mkdir -p "$DATA_DIR"

# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# api — Test and debug REST APIs with request building and response 
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_get() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME get <url>"
    curl -sS "$2"
}

cmd_post() {
    local url="${2:-}"
    local data="${3:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME post <url data>"
    curl -sS -X POST -d "$3" "$2"
}

cmd_headers() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME headers <url>"
    curl -sI "$2"
}

cmd_status() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME status <url>"
    curl -so /dev/null -w '%{http_code}' "$2"
}

cmd_time() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME time <url>"
    curl -so /dev/null -w '%{time_total}s' "$2"
}

cmd_json() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME json <url>"
    curl -sS "$2" | python3 -c 'import json,sys;print(json.dumps(json.load(sys.stdin),indent=2))'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "get <url>" ""
    printf "  %-20s %s\n" "post <url data>" ""
    printf "  %-20s %s\n" "headers <url>" ""
    printf "  %-20s %s\n" "status <url>" ""
    printf "  %-20s %s\n" "time <url>" ""
    printf "  %-20s %s\n" "json <url>" ""
    printf "  %-20s %s\n" "help" "Show this help"
    printf "  %-20s %s\n" "version" "Show version"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() {
    echo "$SCRIPT_NAME v$VERSION"
}

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        get) shift; cmd_get "$@" ;;
        post) shift; cmd_post "$@" ;;
        headers) shift; cmd_headers "$@" ;;
        status) shift; cmd_status "$@" ;;
        time) shift; cmd_time "$@" ;;
        json) shift; cmd_json "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
