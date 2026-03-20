#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="resignation-letter"
DATA_DIR="$HOME/.local/share/resignation-letter"
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

cmd_create() {
    local name="${2:-}"
    local company="${3:-}"
    local last_day="${4:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME create <name company last_day>"
    printf 'Dear Manager,\n\nI, %s, hereby resign from my position at %s.\nMy last day will be %s.\n\nSincerely,\n%s\n' $2 $3 $4 $2
}

cmd_template() {
    local style="${2:-}"
    [ -z "$style" ] && die "Usage: $SCRIPT_NAME template <style>"
    case $2 in formal) echo 'Dear [Manager], I am writing to formally notify...';; casual) echo 'Hi [Manager], I wanted to let you know...';; *) echo 'Styles: formal, casual, grateful, brief';; esac
}

cmd_checklist() {
    echo '[ ] Submit letter 2 weeks before last day'; echo '[ ] Return company property'; echo '[ ] Transfer knowledge'; echo '[ ] Update LinkedIn'
}

cmd_timeline() {
    local last_day="${2:-}"
    [ -z "$last_day" ] && die "Usage: $SCRIPT_NAME timeline <last_day>"
    echo 'Last day: $2'; echo 'Submit letter 2 weeks prior'
}

cmd_formal() {
    local name="${2:-}"
    local company="${3:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME formal <name company>"
    cmd_create $2 $3 TBD
}

cmd_casual() {
    local name="${2:-}"
    local company="${3:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME casual <name company>"
    echo 'Hi, I wanted to let you know I will be leaving $3. Thanks for everything! - $2'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "create <name company last_day>"
    printf "  %-25s\n" "template <style>"
    printf "  %-25s\n" "checklist"
    printf "  %-25s\n" "timeline <last_day>"
    printf "  %-25s\n" "formal <name company>"
    printf "  %-25s\n" "casual <name company>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        create) shift; cmd_create "$@" ;;
        template) shift; cmd_template "$@" ;;
        checklist) shift; cmd_checklist "$@" ;;
        timeline) shift; cmd_timeline "$@" ;;
        formal) shift; cmd_formal "$@" ;;
        casual) shift; cmd_casual "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
