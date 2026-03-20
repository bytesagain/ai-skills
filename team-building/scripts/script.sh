#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="team-building"
DATA_DIR="$HOME/.local/share/team-building"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_icebreaker() {
    local qs=('Two truths and a lie' 'Desert island: 3 items?' 'Superpower for a day?' 'Best vacation ever?' 'Hidden talent?'); echo ${qs[$((RANDOM % 5))]}
}

cmd_activity() {
    local size="${2:-}"
    [ -z "$size" ] && die "Usage: $SCRIPT_NAME activity <size>"
    echo 'Group of ${2:-10}: try a collaborative puzzle or escape room'
}

cmd_quiz() {
    local topic="${2:-}"
    [ -z "$topic" ] && die "Usage: $SCRIPT_NAME quiz <topic>"
    echo 'Team quiz topic: ${2:-general knowledge}'
}

cmd_random_team() {
    local names="${2:-}"
    local count="${3:-}"
    [ -z "$names" ] && die "Usage: $SCRIPT_NAME random-team <names count>"
    echo '$2' | tr ',' '\n' | shuf | awk 'NR%'${3:-2}'==1{t++}{print "Team "t": "$0}'
}

cmd_pairs() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME pairs <file>"
    cat $2 | shuf | paste - - 2>/dev/null
}

cmd_vote() {
    local options="${2:-}"
    [ -z "$options" ] && die "Usage: $SCRIPT_NAME vote <options>"
    echo 'Vote options: $2' | tr ',' '\n' | cat -n
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "icebreaker"
    printf "  %-25s\n" "activity <size>"
    printf "  %-25s\n" "quiz <topic>"
    printf "  %-25s\n" "random-team <names count>"
    printf "  %-25s\n" "pairs <file>"
    printf "  %-25s\n" "vote <options>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        icebreaker) shift; cmd_icebreaker "$@" ;;
        activity) shift; cmd_activity "$@" ;;
        quiz) shift; cmd_quiz "$@" ;;
        random-team) shift; cmd_random_team "$@" ;;
        pairs) shift; cmd_pairs "$@" ;;
        vote) shift; cmd_vote "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
