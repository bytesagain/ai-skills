#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="whois-checker"
DATA_DIR="$HOME/.local/share/whois-checker"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_lookup() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME lookup <domain>"
    whois $2 2>/dev/null | head -30 || echo 'whois not available'
}

cmd_expiry() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME expiry <domain>"
    whois $2 2>/dev/null | grep -i 'expir\|renewal' | head -2
}

cmd_registrar() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME registrar <domain>"
    whois $2 2>/dev/null | grep -i registrar | head -1
}

cmd_batch() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME batch <file>"
    while IFS= read -r d; do echo "$d: $(whois $d 2>/dev/null | grep -i expir | head -1)"; sleep 1; done < $2
}

cmd_dns() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME dns <domain>"
    dig +short A $2 2>/dev/null; dig +short MX $2 2>/dev/null
}

cmd_compare() {
    local d1="${2:-}"
    local d2="${3:-}"
    [ -z "$d1" ] && die "Usage: $SCRIPT_NAME compare <d1 d2>"
    echo '=== $2 ==='; cmd_expiry $2; echo '=== $3 ==='; cmd_expiry $3
}

cmd_available() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME available <domain>"
    whois $2 2>/dev/null | grep -qi 'no match\|not found' && echo 'AVAILABLE: $2' || echo 'TAKEN: $2'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "lookup <domain>"
    printf "  %-25s\n" "expiry <domain>"
    printf "  %-25s\n" "registrar <domain>"
    printf "  %-25s\n" "batch <file>"
    printf "  %-25s\n" "dns <domain>"
    printf "  %-25s\n" "compare <d1 d2>"
    printf "  %-25s\n" "available <domain>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        lookup) shift; cmd_lookup "$@" ;;
        expiry) shift; cmd_expiry "$@" ;;
        registrar) shift; cmd_registrar "$@" ;;
        batch) shift; cmd_batch "$@" ;;
        dns) shift; cmd_dns "$@" ;;
        compare) shift; cmd_compare "$@" ;;
        available) shift; cmd_available "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
