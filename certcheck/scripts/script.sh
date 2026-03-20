#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="certcheck"
DATA_DIR="$HOME/.local/share/certcheck"
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

cmd_check() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME check <domain>"
    echo | openssl s_client -connect $2:443 -servername $2 2>/dev/null | openssl x509 -noout -subject -issuer -dates
}

cmd_expiry() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME expiry <domain>"
    echo | openssl s_client -connect $2:443 -servername $2 2>/dev/null | openssl x509 -noout -enddate
}

cmd_chain() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME chain <domain>"
    echo | openssl s_client -connect $2:443 -showcerts 2>/dev/null | grep -E 's:|i:'
}

cmd_compare() {
    local d1="${2:-}"
    local d2="${3:-}"
    [ -z "$d1" ] && die "Usage: $SCRIPT_NAME compare <d1 d2>"
    echo '=== $2 ==='; cmd_expiry $2; echo '=== $3 ==='; cmd_expiry $3
}

cmd_batch() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME batch <file>"
    while IFS= read -r d; do echo "$d: $(cmd_expiry $d 2>/dev/null | cut -d= -f2)"; done < $2
}

cmd_report() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME report <domain>"
    echo '=== SSL Report: $2 ==='; cmd_check $2
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "check <domain>"
    printf "  %-25s\n" "expiry <domain>"
    printf "  %-25s\n" "chain <domain>"
    printf "  %-25s\n" "compare <d1 d2>"
    printf "  %-25s\n" "batch <file>"
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
        expiry) shift; cmd_expiry "$@" ;;
        chain) shift; cmd_chain "$@" ;;
        compare) shift; cmd_compare "$@" ;;
        batch) shift; cmd_batch "$@" ;;
        report) shift; cmd_report "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
