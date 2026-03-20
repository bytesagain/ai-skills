#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="retirement-planner"
DATA_DIR="$HOME/.local/share/retirement-planner"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_calculate() {
    local age="${2:-}"
    local target="${3:-}"
    local savings="${4:-}"
    local monthly="${5:-}"
    [ -z "$age" ] && die "Usage: $SCRIPT_NAME calculate <age target savings monthly>"
    awk "BEGIN{years=${3:-65}-$2; total=$4; for(i=0;i<years*12;i++){total=(total+$5)*1.005}; printf \"At %d with %.0f/mo: \$%.0f\n\",$3,$5,total}"
}

cmd_roi() {
    local principal="${2:-}"
    local rate="${3:-}"
    local years="${4:-}"
    [ -z "$principal" ] && die "Usage: $SCRIPT_NAME roi <principal rate years>"
    awk "BEGIN{printf \"%.0f -> %.0f (%.1f%% over %d years)\n\",$2,$2*(1+$3/100)^$4,$3,$4}"
}

cmd_inflation() {
    local amount="${2:-}"
    local years="${3:-}"
    local rate="${4:-}"
    [ -z "$amount" ] && die "Usage: $SCRIPT_NAME inflation <amount years rate>"
    awk "BEGIN{printf \"\$%.0f in %d years = \$%.0f today (%.1f%% inflation)\n\",$2,$3,$2/(1+$4/100)^$3,$4}"
}

cmd_gap() {
    local current="${2:-}"
    local target="${3:-}"
    local years="${4:-}"
    [ -z "$current" ] && die "Usage: $SCRIPT_NAME gap <current target years>"
    awk "BEGIN{gap=$3-$2; monthly=gap/($4*12); printf \"Gap: \$%.0f, Need: \$%.0f/month\n\",gap,monthly}"
}

cmd_social() {
    local income="${2:-}"
    [ -z "$income" ] && die "Usage: $SCRIPT_NAME social <income>"
    awk "BEGIN{printf \"Est. SS benefit: \$%.0f/month\n\",$2*0.4/12}"
}

cmd_401k() {
    local salary="${2:-}"
    local match="${3:-}"
    [ -z "$salary" ] && die "Usage: $SCRIPT_NAME 401k <salary match>"
    awk "BEGIN{printf \"Annual 401k: \$%.0f (you) + \$%.0f (match) = \$%.0f\n\",$2*0.06,$2*$3/100,$2*0.06+$2*$3/100}"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "calculate <age target savings monthly>"
    printf "  %-25s\n" "roi <principal rate years>"
    printf "  %-25s\n" "inflation <amount years rate>"
    printf "  %-25s\n" "gap <current target years>"
    printf "  %-25s\n" "social <income>"
    printf "  %-25s\n" "401k <salary match>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        calculate) shift; cmd_calculate "$@" ;;
        roi) shift; cmd_roi "$@" ;;
        inflation) shift; cmd_inflation "$@" ;;
        gap) shift; cmd_gap "$@" ;;
        social) shift; cmd_social "$@" ;;
        401k) shift; cmd_401k "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
