#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="liquidity-monitor"
DATA_DIR="$HOME/.local/share/liquidity-monitor"
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

cmd_tvl() {
    local protocol="${2:-}"
    [ -z "$protocol" ] && die "Usage: $SCRIPT_NAME tvl <protocol>"
    curl -s 'https://api.llama.fi/tvl/${2:-uniswap}' 2>/dev/null || echo 'API error'
}

cmd_top() {
    local count="${2:-}"
    [ -z "$count" ] && die "Usage: $SCRIPT_NAME top <count>"
    curl -s 'https://api.llama.fi/protocols' 2>/dev/null | python3 -c 'import json,sys;[print(p["name"],"TVL:",int(p.get("tvl",0))) for p in sorted(json.load(sys.stdin),key=lambda x:-x.get("tvl",0))[:${2:-10}]]' 2>/dev/null
}

cmd_pool() {
    local pair="${2:-}"
    [ -z "$pair" ] && die "Usage: $SCRIPT_NAME pool <pair>"
    echo 'Pool $2: use DeFiLlama yields API'
}

cmd_alerts() {
    cat $DATA_DIR/alerts.log 2>/dev/null || echo 'No alerts'
}

cmd_history() {
    local pool="${2:-}"
    [ -z "$pool" ] && die "Usage: $SCRIPT_NAME history <pool>"
    echo 'History for $2'
}

cmd_yield() {
    local pool="${2:-}"
    [ -z "$pool" ] && die "Usage: $SCRIPT_NAME yield <pool>"
    echo 'Yield data for $2'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "tvl <protocol>"
    printf "  %-25s\n" "top <count>"
    printf "  %-25s\n" "pool <pair>"
    printf "  %-25s\n" "alerts"
    printf "  %-25s\n" "history <pool>"
    printf "  %-25s\n" "yield <pool>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        tvl) shift; cmd_tvl "$@" ;;
        top) shift; cmd_top "$@" ;;
        pool) shift; cmd_pool "$@" ;;
        alerts) shift; cmd_alerts "$@" ;;
        history) shift; cmd_history "$@" ;;
        yield) shift; cmd_yield "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
