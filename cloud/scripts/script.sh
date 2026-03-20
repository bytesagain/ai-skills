#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="cloud"
DATA_DIR="$HOME/.local/share/cloud"
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

cmd_regions() {
    local provider="${2:-}"
    [ -z "$provider" ] && die "Usage: $SCRIPT_NAME regions <provider>"
    case "${2:-aws}" in aws) echo "us-east-1 us-west-2 eu-west-1 ap-southeast-1";; gcp) echo "us-central1 europe-west1 asia-east1";; azure) echo "eastus westus westeurope";; *) echo "Unknown provider: $2";; esac
}

cmd_cost() {
    local hours="${2:-}"
    local rate="${3:-}"
    [ -z "$hours" ] && die "Usage: $SCRIPT_NAME cost <hours rate>"
    awk "BEGIN{printf "Cost: \$%.2f\n", $2 * $3}"
}

cmd_ips() {
    echo "Public: $(curl -s https://checkip.amazonaws.com 2>/dev/null)"; ip -br addr 2>/dev/null | grep -v lo
}

cmd_dns() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME dns <domain>"
    dig +short "$2" 2>/dev/null
}

cmd_ping() {
    local host="${2:-}"
    [ -z "$host" ] && die "Usage: $SCRIPT_NAME ping <host>"
    curl -so /dev/null -w "Latency: %{time_total}s\n" "https://$2" 2>/dev/null
}

cmd_status() {
    local service="${2:-}"
    [ -z "$service" ] && die "Usage: $SCRIPT_NAME status <service>"
    curl -so /dev/null -w "HTTP %{http_code}\n" "https://$2" 2>/dev/null
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "regions <provider>"
    printf "  %-25s\n" "cost <hours rate>"
    printf "  %-25s\n" "ips"
    printf "  %-25s\n" "dns <domain>"
    printf "  %-25s\n" "ping <host>"
    printf "  %-25s\n" "status <service>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        regions) shift; cmd_regions "$@" ;;
        cost) shift; cmd_cost "$@" ;;
        ips) shift; cmd_ips "$@" ;;
        dns) shift; cmd_dns "$@" ;;
        ping) shift; cmd_ping "$@" ;;
        status) shift; cmd_status "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
