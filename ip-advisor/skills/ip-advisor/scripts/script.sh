#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="ip-advisor"
DATA_DIR="$HOME/.local/share/ip-advisor"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_info() {
    local ip="${2:-}"
    [ -z "$ip" ] && die "Usage: $SCRIPT_NAME info <ip>"
    echo 'IP: $2'; echo $2 | grep -qE '^10\.|^172\.(1[6-9]|2[0-9]|3[01])\.|^192\.168\.' && echo 'Type: Private' || echo 'Type: Public'
}

cmd_subnet() {
    local cidr="${2:-}"
    [ -z "$cidr" ] && die "Usage: $SCRIPT_NAME subnet <cidr>"
    echo 'CIDR: $2'; echo $2 | awk -F/ '{print "Mask bits: /"$2}'
}

cmd_validate() {
    local ip="${2:-}"
    [ -z "$ip" ] && die "Usage: $SCRIPT_NAME validate <ip>"
    echo $2 | grep -qE '^([0-9]{1,3}\.){3}[0-9]{1,3}$' && echo 'Valid IPv4' || echo 'Invalid'
}

cmd_local() {
    ip -br addr 2>/dev/null | grep -v lo || ifconfig 2>/dev/null
}

cmd_public() {
    curl -s https://checkip.amazonaws.com 2>/dev/null || echo 'Cannot determine'
}

cmd_range() {
    local start="${2:-}"
    local end="${3:-}"
    [ -z "$start" ] && die "Usage: $SCRIPT_NAME range <start end>"
    echo 'Range: $2 - $3'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "info <ip>"
    printf "  %-25s\n" "subnet <cidr>"
    printf "  %-25s\n" "validate <ip>"
    printf "  %-25s\n" "local"
    printf "  %-25s\n" "public"
    printf "  %-25s\n" "range <start end>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        info) shift; cmd_info "$@" ;;
        subnet) shift; cmd_subnet "$@" ;;
        validate) shift; cmd_validate "$@" ;;
        local) shift; cmd_local "$@" ;;
        public) shift; cmd_public "$@" ;;
        range) shift; cmd_range "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
