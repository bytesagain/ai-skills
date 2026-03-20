#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="perftest"
DATA_DIR="$HOME/.local/share/perftest"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_http() {
    local url="${2:-}"
    local count="${3:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME http <url count>"
    echo 'Testing $2 ($((${3:-5})) requests)'; for i in $(seq 1 ${3:-5}); do curl -so /dev/null -w '%{time_total}' $2 2>/dev/null; echo; done | awk '{s+=$1;n++} END{printf "Avg: %.3fs\n",s/n}'
}

cmd_latency() {
    local host="${2:-}"
    [ -z "$host" ] && die "Usage: $SCRIPT_NAME latency <host>"
    curl -so /dev/null -w 'DNS: %{time_namelookup}s\nConnect: %{time_connect}s\nTTFB: %{time_starttransfer}s\nTotal: %{time_total}s\n' $2 2>/dev/null
}

cmd_throughput() {
    local url="${2:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME throughput <url>"
    curl -so /dev/null -w '%{speed_download}' $2 2>/dev/null | awk '{printf "Speed: %.0f bytes/sec\n",$1}'
}

cmd_stress() {
    local url="${2:-}"
    local concurrent="${3:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME stress <url concurrent>"
    echo 'Stress test: ${3:-5} concurrent to $2'
}

cmd_report() {
    local logfile="${2:-}"
    [ -z "$logfile" ] && die "Usage: $SCRIPT_NAME report <logfile>"
    cat $2 2>/dev/null | awk '{s+=$1;n++} END{printf "Requests: %d, Avg: %.3fs\n",n,s/n}'
}

cmd_compare() {
    local f1="${2:-}"
    local f2="${3:-}"
    [ -z "$f1" ] && die "Usage: $SCRIPT_NAME compare <f1 f2>"
    echo '=== $2 ==='; head -5 $2; echo '=== $3 ==='; head -5 $3
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "http <url count>"
    printf "  %-25s\n" "latency <host>"
    printf "  %-25s\n" "throughput <url>"
    printf "  %-25s\n" "stress <url concurrent>"
    printf "  %-25s\n" "report <logfile>"
    printf "  %-25s\n" "compare <f1 f2>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        http) shift; cmd_http "$@" ;;
        latency) shift; cmd_latency "$@" ;;
        throughput) shift; cmd_throughput "$@" ;;
        stress) shift; cmd_stress "$@" ;;
        report) shift; cmd_report "$@" ;;
        compare) shift; cmd_compare "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
