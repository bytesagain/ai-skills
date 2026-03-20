#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="first-aid"
DATA_DIR="$HOME/.local/share/first-aid"
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

cmd_guide() {
    local condition="${2:-}"
    [ -z "$condition" ] && die "Usage: $SCRIPT_NAME guide <condition>"
    case $2 in burn) echo 'Cool with water 10-20min, cover with sterile dressing';; choking) echo 'Back blows, abdominal thrusts (Heimlich)';; bleeding) echo 'Apply direct pressure, elevate, call 911 if severe';; cpr) echo 'Check response, call 911, 30 compressions : 2 breaths';; *) echo 'Consult medical professional for $2';; esac
}

cmd_emergency() {
    echo 'Emergency: 911 (US) / 120 (CN) / 999 (UK) / 112 (EU)'
}

cmd_kit() {
    echo 'First Aid Kit: bandages, gauze, tape, antiseptic, scissors, gloves, CPR mask, aspirin'
}

cmd_list() {
    echo 'Topics: burn, choking, bleeding, cpr, fracture, poison, shock, heatstroke'
}

cmd_search() {
    local keyword="${2:-}"
    [ -z "$keyword" ] && die "Usage: $SCRIPT_NAME search <keyword>"
    echo 'Searching: $2'
}

cmd_quiz() {
    echo 'Q: What is the ratio for CPR compressions to breaths? A: 30:2'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "guide <condition>"
    printf "  %-25s\n" "emergency"
    printf "  %-25s\n" "kit"
    printf "  %-25s\n" "list"
    printf "  %-25s\n" "search <keyword>"
    printf "  %-25s\n" "quiz"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        guide) shift; cmd_guide "$@" ;;
        emergency) shift; cmd_emergency "$@" ;;
        kit) shift; cmd_kit "$@" ;;
        list) shift; cmd_list "$@" ;;
        search) shift; cmd_search "$@" ;;
        quiz) shift; cmd_quiz "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
