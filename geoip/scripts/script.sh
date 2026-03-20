#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="geoip"
DATA_DIR="$HOME/.local/share/geoip"
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

cmd_lookup() {
    local ip="${2:-}"
    [ -z "$ip" ] && die "Usage: $SCRIPT_NAME lookup <ip>"
    curl -s 'http://ip-api.com/json/$2' 2>/dev/null | python3 -c 'import json,sys;d=json.load(sys.stdin);print(d.get("country",""),d.get("city",""),d.get("isp",""))' 2>/dev/null
}

cmd_self() {
    curl -s 'http://ip-api.com/json/' 2>/dev/null
}

cmd_batch() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME batch <file>"
    while IFS= read -r ip; do echo -n "$ip: "; curl -s "http://ip-api.com/json/$ip" 2>/dev/null | python3 -c 'import json,sys;d=json.load(sys.stdin);print(d.get("country",""),d.get("city",""))' 2>/dev/null; sleep 1; done < $2
}

cmd_whois() {
    local ip="${2:-}"
    [ -z "$ip" ] && die "Usage: $SCRIPT_NAME whois <ip>"
    whois $2 2>/dev/null | head -20 || echo 'whois not available'
}

cmd_dns() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME dns <domain>"
    dig +short A $2 2>/dev/null
}

cmd_trace() {
    local ip="${2:-}"
    [ -z "$ip" ] && die "Usage: $SCRIPT_NAME trace <ip>"
    traceroute -m 10 $2 2>/dev/null || echo 'traceroute not available'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "lookup <ip>"
    printf "  %-25s\n" "self"
    printf "  %-25s\n" "batch <file>"
    printf "  %-25s\n" "whois <ip>"
    printf "  %-25s\n" "dns <domain>"
    printf "  %-25s\n" "trace <ip>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        lookup) shift; cmd_lookup "$@" ;;
        self) shift; cmd_self "$@" ;;
        batch) shift; cmd_batch "$@" ;;
        whois) shift; cmd_whois "$@" ;;
        dns) shift; cmd_dns "$@" ;;
        trace) shift; cmd_trace "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
