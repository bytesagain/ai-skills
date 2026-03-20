#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="check"
DATA_DIR="$HOME/.local/share/check"
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

cmd_url() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME url <url>"
    local code; code=$(curl -so /dev/null -w "%{http_code}" "$2" 2>/dev/null); echo "HTTP $code $2"
}

cmd_disk() {
    df -h
}

cmd_dns() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME dns <domain>"
    dig +short "$2" 2>/dev/null || echo "DNS lookup failed"
}

cmd_port() {
    local host="${2:-}"
    local port="${3:-}"
    [ -z "$host" ] && die "Usage: $SCRIPT_NAME port <host port>"
    (echo >/dev/tcp/"$2"/"$3") 2>/dev/null && echo "OPEN $2:$3" || echo "CLOSED $2:$3"
}

cmd_file() {
    local path="${2:-}"
    [ -z "$path" ] && die "Usage: $SCRIPT_NAME file <path>"
    [ -f "$2" ] && stat "$2" 2>/dev/null || echo "MISSING: $2"
}

cmd_memory() {
    free -h
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "url <url>"
    printf "  %-25s\n" "disk"
    printf "  %-25s\n" "dns <domain>"
    printf "  %-25s\n" "port <host port>"
    printf "  %-25s\n" "file <path>"
    printf "  %-25s\n" "memory"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        url) shift; cmd_url "$@" ;;
        disk) shift; cmd_disk "$@" ;;
        dns) shift; cmd_dns "$@" ;;
        port) shift; cmd_port "$@" ;;
        file) shift; cmd_file "$@" ;;
        memory) shift; cmd_memory "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
