#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="connect"
DATA_DIR="$HOME/.local/share/connect"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_tcp() {
    local host="${2:-}"
    local port="${3:-}"
    [ -z "$host" ] && die "Usage: $SCRIPT_NAME tcp <host port>"
    (echo >/dev/tcp/"$2"/"$3") 2>/dev/null && echo "CONNECTED $2:$3" || echo "REFUSED $2:$3"
}

cmd_ping() {
    local host="${2:-}"
    [ -z "$host" ] && die "Usage: $SCRIPT_NAME ping <host>"
    ping -c "${3:-4}" "$2" 2>/dev/null
}

cmd_dns() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME dns <domain>"
    dig +short "$2" 2>/dev/null
}

cmd_trace() {
    local host="${2:-}"
    [ -z "$host" ] && die "Usage: $SCRIPT_NAME trace <host>"
    traceroute -m 15 "$2" 2>/dev/null || echo "traceroute not available"
}

cmd_http() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME http <url>"
    curl -so /dev/null -w "Status: %{http_code}\n" "$2" 2>/dev/null
}

cmd_scan() {
    local host="${2:-}"
    [ -z "$host" ] && die "Usage: $SCRIPT_NAME scan <host>"
    for p in 22 80 443 8080 3306; do (echo >/dev/tcp/"$2"/$p) 2>/dev/null && echo "OPEN :$p"; done
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "tcp <host port>"
    printf "  %-25s\n" "ping <host>"
    printf "  %-25s\n" "dns <domain>"
    printf "  %-25s\n" "trace <host>"
    printf "  %-25s\n" "http <url>"
    printf "  %-25s\n" "scan <host>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        tcp) shift; cmd_tcp "$@" ;;
        ping) shift; cmd_ping "$@" ;;
        dns) shift; cmd_dns "$@" ;;
        trace) shift; cmd_trace "$@" ;;
        http) shift; cmd_http "$@" ;;
        scan) shift; cmd_scan "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
