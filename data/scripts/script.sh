#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="data"
DATA_DIR="$HOME/.local/share/data"
mkdir -p "$DATA_DIR"

# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# data — Transform, validate, and analyze data files in CSV, JSON, an
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_csv_info() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME csv-info <file>"
    head -1 "$2" | awk -F, '{print NF" columns"}'; wc -l < "$2" | awk '{print $1" rows"}'
}

cmd_json_keys() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME json-keys <file>"
    python3 -c "import json;d=json.load(open('$2'));print('\n'.join(d.keys() if isinstance(d,dict) else ['array:'+str(len(d))]))" 2>/dev/null || echo 'Not valid JSON'
}

cmd_stats() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME stats <file>"
    awk '{s+=$1;n++} END{print "count="n,"sum="s,"avg="s/n}' "$2"
}

cmd_sample() {
    local file="${2:-}"
    local n="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME sample <file n>"
    head -"${3:-10}" "$2"
}

cmd_unique() {
    local file="${2:-}"
    local col="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME unique <file col>"
    awk -F, -v c="${3:-1}" '{print $c}' "$2" | sort -u | wc -l | awk '{print $1" unique values"}'
}

cmd_sort_csv() {
    local file="${2:-}"
    local col="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME sort-csv <file col>"
    head -1 "$2"; tail -n+2 "$2" | sort -t, -k"${3:-1}" -n
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "csv-info <file>" ""
    printf "  %-20s %s\n" "json-keys <file>" ""
    printf "  %-20s %s\n" "stats <file>" ""
    printf "  %-20s %s\n" "sample <file n>" ""
    printf "  %-20s %s\n" "unique <file col>" ""
    printf "  %-20s %s\n" "sort-csv <file col>" ""
    printf "  %-20s %s\n" "help" "Show this help"
    printf "  %-20s %s\n" "version" "Show version"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() {
    echo "$SCRIPT_NAME v$VERSION"
}

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        csv-info) shift; cmd_csv_info "$@" ;;
        json-keys) shift; cmd_json_keys "$@" ;;
        stats) shift; cmd_stats "$@" ;;
        sample) shift; cmd_sample "$@" ;;
        unique) shift; cmd_unique "$@" ;;
        sort-csv) shift; cmd_sort_csv "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
