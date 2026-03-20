#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="unit-converter"
DATA_DIR="$HOME/.local/share/unit-converter"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_length() {
    local val="${2:-}"
    local from="${3:-}"
    local to="${4:-}"
    [ -z "$val" ] && die "Usage: $SCRIPT_NAME length <val from to>"
    awk "BEGIN{m[\"m\"]=1;m[\"ft\"]=0.3048;m[\"in\"]=0.0254;m[\"cm\"]=0.01;m[\"km\"]=1000;m[\"mi\"]=1609.34; printf \"%.4f %s\n\",$2*m[\"$3\"]/m[\"$4\"],\"$4\"}"
}

cmd_weight() {
    local val="${2:-}"
    local from="${3:-}"
    local to="${4:-}"
    [ -z "$val" ] && die "Usage: $SCRIPT_NAME weight <val from to>"
    awk "BEGIN{m[\"kg\"]=1;m[\"lb\"]=0.453592;m[\"oz\"]=0.0283495;m[\"g\"]=0.001; printf \"%.4f %s\n\",$2*m[\"$3\"]/m[\"$4\"],\"$4\"}"
}

cmd_temp() {
    local val="${2:-}"
    local from="${3:-}"
    local to="${4:-}"
    [ -z "$val" ] && die "Usage: $SCRIPT_NAME temp <val from to>"
    case $3$4 in CF) awk "BEGIN{printf \"%.1f F\n\",$2*9/5+32}";; FC) awk "BEGIN{printf \"%.1f C\n\",($2-32)*5/9}";; CK) awk "BEGIN{printf \"%.1f K\n\",$2+273.15}";; *) echo 'Use: C, F, K';; esac
}

cmd_speed() {
    local val="${2:-}"
    local from="${3:-}"
    local to="${4:-}"
    [ -z "$val" ] && die "Usage: $SCRIPT_NAME speed <val from to>"
    awk "BEGIN{m[\"kmh\"]=1;m[\"mph\"]=1.60934;m[\"ms\"]=3.6; printf \"%.2f %s\n\",$2*m[\"$3\"]/m[\"$4\"],\"$4\"}"
}

cmd_data() {
    local val="${2:-}"
    local from="${3:-}"
    local to="${4:-}"
    [ -z "$val" ] && die "Usage: $SCRIPT_NAME data <val from to>"
    awk "BEGIN{m[\"B\"]=1;m[\"KB\"]=1024;m[\"MB\"]=1048576;m[\"GB\"]=1073741824;m[\"TB\"]=1099511627776; printf \"%.4f %s\n\",$2*m[\"$3\"]/m[\"$4\"],\"$4\"}"
}

cmd_volume() {
    local val="${2:-}"
    local from="${3:-}"
    local to="${4:-}"
    [ -z "$val" ] && die "Usage: $SCRIPT_NAME volume <val from to>"
    awk "BEGIN{m[\"L\"]=1;m[\"ml\"]=0.001;m[\"gal\"]=3.78541; printf \"%.4f %s\n\",$2*m[\"$3\"]/m[\"$4\"],\"$4\"}"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "length <val from to>"
    printf "  %-25s\n" "weight <val from to>"
    printf "  %-25s\n" "temp <val from to>"
    printf "  %-25s\n" "speed <val from to>"
    printf "  %-25s\n" "data <val from to>"
    printf "  %-25s\n" "volume <val from to>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        length) shift; cmd_length "$@" ;;
        weight) shift; cmd_weight "$@" ;;
        temp) shift; cmd_temp "$@" ;;
        speed) shift; cmd_speed "$@" ;;
        data) shift; cmd_data "$@" ;;
        volume) shift; cmd_volume "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
