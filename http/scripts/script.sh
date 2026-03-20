#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="http"
DATA_DIR="$HOME/.local/share/http"
mkdir -p "$DATA_DIR"

# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
# http — Send HTTP requests and analyze responses with timing. Use wh
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
    local body="${3:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME post <url body>"
    curl -sS -X POST -H 'Content-Type: application/json' -d "$3" "$2"
}

cmd_head() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME head <url>"
    curl -sI "$2"
}

cmd_time() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME time <url>"
    curl -w 'DNS: %{time_namelookup}s\nConnect: %{time_connect}s\nTTFB: %{time_starttransfer}s\nTotal: %{time_total}s\n' -so /dev/null "$2"
}

cmd_status() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME status <url>"
    curl -so /dev/null -w '%{http_code}\n' "$2"
}

cmd_follow() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME follow <url>"
    curl -sIL "$2" 2>/dev/null | grep -i 'location:\|HTTP/'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "get <url>" ""
    printf "  %-20s %s\n" "post <url body>" ""
    printf "  %-20s %s\n" "head <url>" ""
    printf "  %-20s %s\n" "time <url>" ""
    printf "  %-20s %s\n" "status <url>" ""
    printf "  %-20s %s\n" "follow <url>" ""
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
        head) shift; cmd_head "$@" ;;
        time) shift; cmd_time "$@" ;;
        status) shift; cmd_status "$@" ;;
        follow) shift; cmd_follow "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
