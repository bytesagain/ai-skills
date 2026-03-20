#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="dns"
DATA_DIR="$HOME/.local/share/dns"
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

cmd_lookup() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME lookup <domain>"
    dig +short A "$2" 2>/dev/null || echo "DNS lookup failed"
}

cmd_mx() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME mx <domain>"
    dig +short MX "$2" 2>/dev/null
}

cmd_ns() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME ns <domain>"
    dig +short NS "$2" 2>/dev/null
}

cmd_txt() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME txt <domain>"
    dig +short TXT "$2" 2>/dev/null
}

cmd_all() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME all <domain>"
    dig ANY "$2" 2>/dev/null
}

cmd_reverse() {
    local ip="${2:-}"
    [ -z "$ip" ] && die "Usage: $SCRIPT_NAME reverse <ip>"
    dig +short -x "$2" 2>/dev/null
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "lookup <domain>"
    printf "  %-25s\n" "mx <domain>"
    printf "  %-25s\n" "ns <domain>"
    printf "  %-25s\n" "txt <domain>"
    printf "  %-25s\n" "all <domain>"
    printf "  %-25s\n" "reverse <ip>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        lookup) shift; cmd_lookup "$@" ;;
        mx) shift; cmd_mx "$@" ;;
        ns) shift; cmd_ns "$@" ;;
        txt) shift; cmd_txt "$@" ;;
        all) shift; cmd_all "$@" ;;
        reverse) shift; cmd_reverse "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
