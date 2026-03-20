#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="model"
DATA_DIR="$HOME/.local/share/model"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_accuracy() {
    local pred="${2:-}"
    local actual="${3:-}"
    [ -z "$pred" ] && die "Usage: $SCRIPT_NAME accuracy <pred actual>"
    paste "$2" "$3" | awk -F"\t" "{if(\$1==\$2)c++; n++} END{printf \"Accuracy: %.2f%% (%d/%d)\n\",c/n*100,c,n}"
}

cmd_compare() {
    local f1="${2:-}"
    local f2="${3:-}"
    [ -z "$f1" ] && die "Usage: $SCRIPT_NAME compare <f1 f2>"
    diff --side-by-side "$2" "$3"
}

cmd_confusion() {
    local pred="${2:-}"
    local actual="${3:-}"
    [ -z "$pred" ] && die "Usage: $SCRIPT_NAME confusion <pred actual>"
    echo "=== Confusion Matrix ==="; paste "$2" "$3" | sort | uniq -c | sort -rn
}

cmd_stats() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME stats <file>"
    awk "{s+=\$1;ss+=\$1*\$1;n++} END{m=s/n;printf \"N=%d Mean=%.4f Std=%.4f\n\",n,m,sqrt(ss/n-m*m)}" "$2"
}

cmd_split() {
    local file="${2:-}"
    local ratio="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME split <file ratio>"
    total=$(wc -l < "$2"); train=$(echo "$total * ${3:-0.8}" | bc | cut -d. -f1); head -"$train" "$2" > "${2%.csv}_train.csv"; tail -n+"$((train+1))" "$2" > "${2%.csv}_test.csv"; echo "Train: $train, Test: $((total-train))"
}

cmd_describe() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME describe <file>"
    head -1 "$2"; echo "---"; wc -l < "$2" | awk "{print \$1\" rows\"}"; head -1 "$2" | awk -F, "{print NF\" columns\"}"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s %s\n" "accuracy <pred actual>" ""
    printf "  %-25s %s\n" "compare <f1 f2>" ""
    printf "  %-25s %s\n" "confusion <pred actual>" ""
    printf "  %-25s %s\n" "stats <file>" ""
    printf "  %-25s %s\n" "split <file ratio>" ""
    printf "  %-25s %s\n" "describe <file>" ""
    printf "  %-25s %s\n" "help" "Show this help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        accuracy) shift; cmd_accuracy "$@" ;;
        compare) shift; cmd_compare "$@" ;;
        confusion) shift; cmd_confusion "$@" ;;
        stats) shift; cmd_stats "$@" ;;
        split) shift; cmd_split "$@" ;;
        describe) shift; cmd_describe "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
