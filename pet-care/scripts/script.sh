#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="pet-care"
DATA_DIR="$HOME/.local/share/pet-care"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_guide() {
    local pet="${2:-}"
    [ -z "$pet" ] && die "Usage: $SCRIPT_NAME guide <pet>"
    case $2 in dog) echo 'Dogs: daily walks, balanced diet, annual vet checkup';; cat) echo 'Cats: indoor enrichment, wet+dry food, litter maintenance';; fish) echo 'Fish: water temp/pH testing, regular water changes';; *) echo 'General: fresh water, proper diet, regular vet visits';; esac
}

cmd_feed() {
    local pet="${2:-}"
    local weight="${3:-}"
    [ -z "$pet" ] && die "Usage: $SCRIPT_NAME feed <pet weight>"
    echo 'Feeding guide for $2 ($3 kg): ~${3}0 calories/day'
}

cmd_vaccine() {
    local pet="${2:-}"
    [ -z "$pet" ] && die "Usage: $SCRIPT_NAME vaccine <pet>"
    case $2 in dog) echo 'Core: Rabies, DHPP, Bordetella';; cat) echo 'Core: Rabies, FVRCP, FeLV';; *) echo 'Consult your vet for $2 vaccines';; esac
}

cmd_emergency() {
    local symptom="${2:-}"
    [ -z "$symptom" ] && die "Usage: $SCRIPT_NAME emergency <symptom>"
    echo 'Emergency: if $2, contact vet immediately'
}

cmd_log() {
    local pet="${2:-}"
    local note="${3:-}"
    [ -z "$pet" ] && die "Usage: $SCRIPT_NAME log <pet note>"
    echo '{"pet":"'$2'","note":"'$3'","date":"'$(date +%Y-%m-%d)'"}' >> $DATA_DIR/pet_log.jsonl && echo Logged
}

cmd_checklist() {
    local pet="${2:-}"
    [ -z "$pet" ] && die "Usage: $SCRIPT_NAME checklist <pet>"
    echo 'Daily: food, water, exercise, medication if needed'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "guide <pet>"
    printf "  %-25s\n" "feed <pet weight>"
    printf "  %-25s\n" "vaccine <pet>"
    printf "  %-25s\n" "emergency <symptom>"
    printf "  %-25s\n" "log <pet note>"
    printf "  %-25s\n" "checklist <pet>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        guide) shift; cmd_guide "$@" ;;
        feed) shift; cmd_feed "$@" ;;
        vaccine) shift; cmd_vaccine "$@" ;;
        emergency) shift; cmd_emergency "$@" ;;
        log) shift; cmd_log "$@" ;;
        checklist) shift; cmd_checklist "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
