#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="domain"
DATA_DIR="$HOME/.local/share/domain"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_whois() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME whois <domain>"
    whois "$2" 2>/dev/null | head -30 || echo "whois not available"
}

cmd_dns() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME dns <domain>"
    dig +short "$2" 2>/dev/null
}

cmd_mx() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME mx <domain>"
    dig +short MX "$2" 2>/dev/null
}

cmd_expiry() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME expiry <domain>"
    whois "$2" 2>/dev/null | grep -i expir | head -1
}

cmd_registrar() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME registrar <domain>"
    whois "$2" 2>/dev/null | grep -i registrar | head -1
}

cmd_ns() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME ns <domain>"
    dig +short NS "$2" 2>/dev/null
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "whois <domain>"
    printf "  %-25s\n" "dns <domain>"
    printf "  %-25s\n" "mx <domain>"
    printf "  %-25s\n" "expiry <domain>"
    printf "  %-25s\n" "registrar <domain>"
    printf "  %-25s\n" "ns <domain>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        whois) shift; cmd_whois "$@" ;;
        dns) shift; cmd_dns "$@" ;;
        mx) shift; cmd_mx "$@" ;;
        expiry) shift; cmd_expiry "$@" ;;
        registrar) shift; cmd_registrar "$@" ;;
        ns) shift; cmd_ns "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
