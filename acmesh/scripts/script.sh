#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="acmesh"
DATA_DIR="$HOME/.local/share/acmesh"
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

cmd_issue() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME issue <domain>"
    openssl req -x509 -newkey rsa:2048 -keyout $DATA_DIR/$2.key -out $DATA_DIR/$2.crt -days 365 -nodes -subj "/CN=$2" 2>/dev/null && echo "Issued self-signed cert for $2"
}

cmd_list() {
    ls $DATA_DIR/*.crt 2>/dev/null | xargs -I{} basename {} .crt || echo 'No certs'
}

cmd_info() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME info <domain>"
    openssl x509 -in $DATA_DIR/$2.crt -noout -subject -dates 2>/dev/null || echo 'Cert not found'
}

cmd_renew() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME renew <domain>"
    cmd_issue "$2" && echo 'Renewed'
}

cmd_revoke() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME revoke <domain>"
    rm -f $DATA_DIR/$2.crt $DATA_DIR/$2.key && echo 'Revoked $2'
}

cmd_check() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME check <domain>"
    echo | openssl s_client -connect $2:443 2>/dev/null | openssl x509 -noout -dates 2>/dev/null || echo 'Cannot connect'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "issue <domain>"
    printf "  %-25s\n" "list"
    printf "  %-25s\n" "info <domain>"
    printf "  %-25s\n" "renew <domain>"
    printf "  %-25s\n" "revoke <domain>"
    printf "  %-25s\n" "check <domain>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        issue) shift; cmd_issue "$@" ;;
        list) shift; cmd_list "$@" ;;
        info) shift; cmd_info "$@" ;;
        renew) shift; cmd_renew "$@" ;;
        revoke) shift; cmd_revoke "$@" ;;
        check) shift; cmd_check "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
