#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="bridge"
DATA_DIR="$HOME/.local/share/bridge"
mkdir -p "$DATA_DIR"

# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# bridge — Forward ports and create network tunnels between hosts. Use 
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_forward() {
    local local="${2:-}"
    local remote_host="${3:-}"
    local remote_port="${4:-}"
    [ -z "$local" ] && die "Usage: $SCRIPT_NAME forward <local remote_host remote_port>"
    echo "Forwarding localhost:$2 -> $3:$4"; socat TCP-LISTEN:"$2",fork TCP:"$3":"$4" 2>/dev/null || nc -l -p "$2" -c "nc $3 $4" 2>/dev/null || echo 'Install socat or nc'
}

cmd_list() {
    ss -tlnp 2>/dev/null | grep -E 'LISTEN'
}

cmd_status() {
    ss -s 2>/dev/null
}

cmd_proxy() {
    local port="${2:-}"
    [ -z "$port" ] && die "Usage: $SCRIPT_NAME proxy <port>"
    echo "Starting SOCKS proxy on port $2"; ssh -D "$2" -N localhost 2>/dev/null || echo 'SSH required'
}

cmd_test() {
    local host="${2:-}"
    local port="${3:-}"
    [ -z "$host" ] && die "Usage: $SCRIPT_NAME test <host port>"
    (echo >/dev/tcp/"$2"/"$3") 2>/dev/null && echo 'OPEN' || echo 'CLOSED'
}

cmd_dns() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME dns <domain>"
    dig +short A "$2" 2>/dev/null; dig +short AAAA "$2" 2>/dev/null
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "forward <local remote_host remote_port>" ""
    printf "  %-20s %s\n" "list" ""
    printf "  %-20s %s\n" "status" ""
    printf "  %-20s %s\n" "proxy <port>" ""
    printf "  %-20s %s\n" "test <host port>" ""
    printf "  %-20s %s\n" "dns <domain>" ""
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
        forward) shift; cmd_forward "$@" ;;
        list) shift; cmd_list "$@" ;;
        status) shift; cmd_status "$@" ;;
        proxy) shift; cmd_proxy "$@" ;;
        test) shift; cmd_test "$@" ;;
        dns) shift; cmd_dns "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
