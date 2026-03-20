#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="wallet-tracker"
DATA_DIR="$HOME/.local/share/wallet-tracker"
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

cmd_add() {
    local address="${2:-}"
    local label="${3:-}"
    [ -z "$address" ] && die "Usage: $SCRIPT_NAME add <address label>"
    echo '{"addr":"'$2'","label":"'${3:-unlabeled}'"}' >> $DATA_DIR/wallets.jsonl && echo 'Added $2'
}

cmd_list() {
    cat $DATA_DIR/wallets.jsonl 2>/dev/null || echo 'No wallets'
}

cmd_balance() {
    local address="${2:-}"
    [ -z "$address" ] && die "Usage: $SCRIPT_NAME balance <address>"
    curl -s 'https://blockstream.info/api/address/$2' 2>/dev/null | python3 -c 'import json,sys;d=json.load(sys.stdin);cs=d.get("chain_stats",{});print("Balance:",(cs.get("funded_txo_sum",0)-cs.get("spent_txo_sum",0))/1e8,"BTC")' 2>/dev/null
}

cmd_check() {
    local address="${2:-}"
    [ -z "$address" ] && die "Usage: $SCRIPT_NAME check <address>"
    curl -s 'https://blockstream.info/api/address/$2/txs' 2>/dev/null | python3 -c 'import json,sys;txs=json.load(sys.stdin);print("Transactions:",len(txs))' 2>/dev/null
}

cmd_remove() {
    local address="${2:-}"
    [ -z "$address" ] && die "Usage: $SCRIPT_NAME remove <address>"
    grep -v $2 $DATA_DIR/wallets.jsonl > $DATA_DIR/wallets.tmp && mv $DATA_DIR/wallets.tmp $DATA_DIR/wallets.jsonl && echo 'Removed $2'
}

cmd_report() {
    echo '=== Wallet Report ==='
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "add <address label>"
    printf "  %-25s\n" "list"
    printf "  %-25s\n" "balance <address>"
    printf "  %-25s\n" "check <address>"
    printf "  %-25s\n" "remove <address>"
    printf "  %-25s\n" "report"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        add) shift; cmd_add "$@" ;;
        list) shift; cmd_list "$@" ;;
        balance) shift; cmd_balance "$@" ;;
        check) shift; cmd_check "$@" ;;
        remove) shift; cmd_remove "$@" ;;
        report) shift; cmd_report "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
