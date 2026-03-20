#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="onchain-analyzer"
DATA_DIR="$HOME/.local/share/onchain-analyzer"
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

cmd_balance() {
    local addr="${2:-}"
    [ -z "$addr" ] && die "Usage: $SCRIPT_NAME balance <addr>"
    curl -s 'https://blockstream.info/api/address/$2' 2>/dev/null | python3 -c 'import json,sys;d=json.load(sys.stdin);cs=d.get("chain_stats",{});print("Balance:",(cs.get("funded_txo_sum",0)-cs.get("spent_txo_sum",0))/1e8,"BTC")' 2>/dev/null
}

cmd_tx() {
    local hash="${2:-}"
    [ -z "$hash" ] && die "Usage: $SCRIPT_NAME tx <hash>"
    curl -s 'https://blockstream.info/api/tx/$2' 2>/dev/null | python3 -c 'import json,sys;d=json.load(sys.stdin);print("Confirmations:",d.get("status",{}).get("confirmed",False))' 2>/dev/null
}

cmd_address() {
    local addr="${2:-}"
    [ -z "$addr" ] && die "Usage: $SCRIPT_NAME address <addr>"
    curl -s 'https://blockstream.info/api/address/$2' 2>/dev/null
}

cmd_gas() {
    curl -s 'https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd' 2>/dev/null
}

cmd_block() {
    local number="${2:-}"
    [ -z "$number" ] && die "Usage: $SCRIPT_NAME block <number>"
    curl -s 'https://blockstream.info/api/blocks/tip/height' 2>/dev/null
}

cmd_token() {
    local addr="${2:-}"
    [ -z "$addr" ] && die "Usage: $SCRIPT_NAME token <addr>"
    echo 'Token lookup for $2'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "balance <addr>"
    printf "  %-25s\n" "tx <hash>"
    printf "  %-25s\n" "address <addr>"
    printf "  %-25s\n" "gas"
    printf "  %-25s\n" "block <number>"
    printf "  %-25s\n" "token <addr>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        balance) shift; cmd_balance "$@" ;;
        tx) shift; cmd_tx "$@" ;;
        address) shift; cmd_address "$@" ;;
        gas) shift; cmd_gas "$@" ;;
        block) shift; cmd_block "$@" ;;
        token) shift; cmd_token "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
