#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="net"
DATA_DIR="$HOME/.local/share/net"
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
#
#
#
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_scan() {
    local host="${2:-}"
    [ -z "$host" ] && die "Usage: $SCRIPT_NAME scan <host>"
    for p in 22 80 443 8080 3306 5432; do (echo >/dev/tcp/"$2"/$p) 2>/dev/null && echo "OPEN $2:$p" || echo "CLOSED $2:$p"; done
}

cmd_ports() {
    /usr/sbin/ss -tlnp 2>/dev/null || ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null
}

cmd_dns() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME dns <domain>"
    dig +short A "$2" 2>/dev/null; dig +short AAAA "$2" 2>/dev/null; dig +short MX "$2" 2>/dev/null
}

cmd_interfaces() {
    ip -br addr 2>/dev/null || ifconfig 2>/dev/null
}

cmd_route() {
    ip route show 2>/dev/null || route -n 2>/dev/null
}

cmd_latency() {
    local host="${2:-}"
    [ -z "$host" ] && die "Usage: $SCRIPT_NAME latency <host>"
    ping -c 5 "$2" 2>/dev/null | tail -1
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s %s\n" "scan <host>" ""
    printf "  %-25s %s\n" "ports" ""
    printf "  %-25s %s\n" "dns <domain>" ""
    printf "  %-25s %s\n" "interfaces" ""
    printf "  %-25s %s\n" "route" ""
    printf "  %-25s %s\n" "latency <host>" ""
    printf "  %-25s %s\n" "help" "Show this help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        scan) shift; cmd_scan "$@" ;;
        ports) shift; cmd_ports "$@" ;;
        dns) shift; cmd_dns "$@" ;;
        interfaces) shift; cmd_interfaces "$@" ;;
        route) shift; cmd_route "$@" ;;
        latency) shift; cmd_latency "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
