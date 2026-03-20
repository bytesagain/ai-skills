#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="ssl-checker"
DATA_DIR="$HOME/.local/share/ssl-checker"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_check() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME check <domain>"
    echo | openssl s_client -connect $2:443 -servername $2 2>/dev/null | openssl x509 -noout -subject -issuer -dates 2>/dev/null
}

cmd_grade() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME grade <domain>"
    echo | openssl s_client -connect $2:443 2>/dev/null | openssl x509 -noout -dates 2>/dev/null; echo 'Full grade: use ssllabs.com'
}

cmd_chain() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME chain <domain>"
    echo | openssl s_client -connect $2:443 -showcerts 2>/dev/null | grep -E 's:|i:'
}

cmd_protocols() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME protocols <domain>"
    for p in tls1 tls1_1 tls1_2 tls1_3; do echo | openssl s_client -connect $2:443 -$p 2>/dev/null | grep -q 'Cipher' && echo "$p: OK" || echo "$p: FAIL"; done
}

cmd_expiry() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME expiry <domain>"
    echo | openssl s_client -connect $2:443 -servername $2 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null
}

cmd_ciphers() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME ciphers <domain>"
    echo | openssl s_client -connect $2:443 2>/dev/null | grep 'Cipher'
}

cmd_report() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME report <domain>"
    echo '=== SSL Report: $2 ==='; cmd_check $2; echo '---'; cmd_protocols $2
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "check <domain>"
    printf "  %-25s\n" "grade <domain>"
    printf "  %-25s\n" "chain <domain>"
    printf "  %-25s\n" "protocols <domain>"
    printf "  %-25s\n" "expiry <domain>"
    printf "  %-25s\n" "ciphers <domain>"
    printf "  %-25s\n" "report <domain>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        check) shift; cmd_check "$@" ;;
        grade) shift; cmd_grade "$@" ;;
        chain) shift; cmd_chain "$@" ;;
        protocols) shift; cmd_protocols "$@" ;;
        expiry) shift; cmd_expiry "$@" ;;
        ciphers) shift; cmd_ciphers "$@" ;;
        report) shift; cmd_report "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
