#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="dex-aggregator"
DATA_DIR="$HOME/.local/share/dex-aggregator"
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
    curl -s 'https://api.llama.fi/tvl/${2:-uniswap}' 2>/dev/null
}

cmd_protocols() {
    curl -s 'https://api.llama.fi/protocols' 2>/dev/null | python3 -c 'import json,sys;[print(p["name"],p.get("tvl",0)) for p in json.load(sys.stdin)[:10]]' 2>/dev/null
}

cmd_trending() {
    curl -s 'https://api.coingecko.com/api/v3/search/trending' 2>/dev/null | python3 -c 'import json,sys;[print(c["item"]["name"]) for c in json.load(sys.stdin).get("coins",[])]' 2>/dev/null
}

cmd_gas() {
    curl -s 'https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd' 2>/dev/null
}

cmd_watchlist() {
    cat $DATA_DIR/watchlist.txt 2>/dev/null || echo Empty
}

cmd_add_watch() {
    local token="${2:-}"
    [ -z "$token" ] && die "Usage: $SCRIPT_NAME add-watch <token>"
    echo $2 >> $DATA_DIR/watchlist.txt && echo 'Added $2'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "tvl <protocol>"
    printf "  %-25s\n" "protocols"
    printf "  %-25s\n" "trending"
    printf "  %-25s\n" "gas"
    printf "  %-25s\n" "watchlist"
    printf "  %-25s\n" "add-watch <token>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        tvl) shift; cmd_tvl "$@" ;;
        protocols) shift; cmd_protocols "$@" ;;
        trending) shift; cmd_trending "$@" ;;
        gas) shift; cmd_gas "$@" ;;
        watchlist) shift; cmd_watchlist "$@" ;;
        add-watch) shift; cmd_add_watch "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
