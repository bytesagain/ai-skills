#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="crypto-whale-tracker"
DATA_DIR="$HOME/.local/share/crypto-whale-tracker"
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

cmd_price() {
    local coin="${2:-}"
    [ -z "$coin" ] && die "Usage: $SCRIPT_NAME price <coin>"
    curl -s 'https://api.coingecko.com/api/v3/simple/price?ids=${2:-bitcoin}&vs_currencies=usd' 2>/dev/null
}

cmd_top() {
    local coin="${2:-}"
    local count="${3:-}"
    [ -z "$coin" ] && die "Usage: $SCRIPT_NAME top <coin count>"
    curl -s 'https://api.coingecko.com/api/v3/coins/${2:-bitcoin}' 2>/dev/null | python3 -c 'import json,sys;d=json.load(sys.stdin);print(json.dumps(d.get("market_data",{}).get("current_price",{}),indent=2))' 2>/dev/null
}

cmd_volume() {
    local coin="${2:-}"
    [ -z "$coin" ] && die "Usage: $SCRIPT_NAME volume <coin>"
    curl -s 'https://api.coingecko.com/api/v3/coins/${2:-bitcoin}' 2>/dev/null | python3 -c 'import json,sys;d=json.load(sys.stdin);print("Volume:",d.get("market_data",{}).get("total_volume",{}).get("usd","N/A"))' 2>/dev/null
}

cmd_watch() {
    local coin="${2:-}"
    [ -z "$coin" ] && die "Usage: $SCRIPT_NAME watch <coin>"
    echo '$2' >> $DATA_DIR/watchlist.txt && echo 'Added $2 to watchlist'
}

cmd_watchlist() {
    cat $DATA_DIR/watchlist.txt 2>/dev/null || echo Empty
}

cmd_alerts() {
    cat $DATA_DIR/alerts.log 2>/dev/null || echo 'No alerts'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "price <coin>"
    printf "  %-25s\n" "top <coin count>"
    printf "  %-25s\n" "volume <coin>"
    printf "  %-25s\n" "watch <coin>"
    printf "  %-25s\n" "watchlist"
    printf "  %-25s\n" "alerts"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        price) shift; cmd_price "$@" ;;
        top) shift; cmd_top "$@" ;;
        volume) shift; cmd_volume "$@" ;;
        watch) shift; cmd_watch "$@" ;;
        watchlist) shift; cmd_watchlist "$@" ;;
        alerts) shift; cmd_alerts "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
