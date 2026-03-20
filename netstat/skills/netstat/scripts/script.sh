#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="netstat"
DATA_DIR="$HOME/.local/share/netstat"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_listen() {
    ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null
}

cmd_connections() {
    local state="${2:-}"
    [ -z "$state" ] && die "Usage: $SCRIPT_NAME connections <state>"
    ss -t${2:+a} 2>/dev/null | head -30
}

cmd_ports() {
    local port="${2:-}"
    [ -z "$port" ] && die "Usage: $SCRIPT_NAME ports <port>"
    ss -tlnp 2>/dev/null | grep ${2:-} || echo 'No matches'
}

cmd_stats() {
    ss -s 2>/dev/null
}

cmd_interfaces() {
    ip -br addr 2>/dev/null || ifconfig 2>/dev/null
}

cmd_route() {
    ip route show 2>/dev/null || route -n 2>/dev/null
}

cmd_dns() {
    cat /etc/resolv.conf 2>/dev/null | grep nameserver
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "listen"
    printf "  %-25s\n" "connections <state>"
    printf "  %-25s\n" "ports <port>"
    printf "  %-25s\n" "stats"
    printf "  %-25s\n" "interfaces"
    printf "  %-25s\n" "route"
    printf "  %-25s\n" "dns"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        listen) shift; cmd_listen "$@" ;;
        connections) shift; cmd_connections "$@" ;;
        ports) shift; cmd_ports "$@" ;;
        stats) shift; cmd_stats "$@" ;;
        interfaces) shift; cmd_interfaces "$@" ;;
        route) shift; cmd_route "$@" ;;
        dns) shift; cmd_dns "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
