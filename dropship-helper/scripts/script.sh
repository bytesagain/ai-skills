#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="dropship-helper"
DATA_DIR="$HOME/.local/share/dropship-helper"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_margin() {
    local cost="${2:-}"
    local price="${3:-}"
    [ -z "$cost" ] && die "Usage: $SCRIPT_NAME margin <cost price>"
    awk "BEGIN{m=($3-$2)/$3*100; printf \"Margin: %.1f%%\n\", m}"
}

cmd_roi() {
    local investment="${2:-}"
    local revenue="${3:-}"
    [ -z "$investment" ] && die "Usage: $SCRIPT_NAME roi <investment revenue>"
    awk "BEGIN{r=($3-$2)/$2*100; printf \"ROI: %.1f%%\n\", r}"
}

cmd_pricing() {
    local cost="${2:-}"
    local margin_pct="${3:-}"
    [ -z "$cost" ] && die "Usage: $SCRIPT_NAME pricing <cost margin_pct>"
    awk "BEGIN{p=$2/(1-$3/100); printf \"Sell at: \$%.2f\n\", p}"
}

cmd_breakeven() {
    local fixed="${2:-}"
    local variable="${3:-}"
    local price="${4:-}"
    [ -z "$fixed" ] && die "Usage: $SCRIPT_NAME breakeven <fixed variable price>"
    awk "BEGIN{b=$2/($4-$3); printf \"Breakeven: %.0f units\n\", b}"
}

cmd_compare() {
    local c1="${2:-}"
    local p1="${3:-}"
    local c2="${4:-}"
    local p2="${5:-}"
    [ -z "$c1" ] && die "Usage: $SCRIPT_NAME compare <c1 p1 c2 p2>"
    echo 'Product 1:'; cmd_margin $2 $3; echo 'Product 2:'; cmd_margin $4 $5
}

cmd_report() {
    echo '=== Dropship Calculator ==='; echo 'Use margin/roi/pricing/breakeven commands'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "margin <cost price>"
    printf "  %-25s\n" "roi <investment revenue>"
    printf "  %-25s\n" "pricing <cost margin_pct>"
    printf "  %-25s\n" "breakeven <fixed variable price>"
    printf "  %-25s\n" "compare <c1 p1 c2 p2>"
    printf "  %-25s\n" "report"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        margin) shift; cmd_margin "$@" ;;
        roi) shift; cmd_roi "$@" ;;
        pricing) shift; cmd_pricing "$@" ;;
        breakeven) shift; cmd_breakeven "$@" ;;
        compare) shift; cmd_compare "$@" ;;
        report) shift; cmd_report "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
