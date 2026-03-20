#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="video-toolbox"
DATA_DIR="$HOME/.local/share/video-toolbox"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_info() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME info <file>"
    ffprobe -v quiet -print_format json -show_format -show_streams $2 2>/dev/null | python3 -c 'import json,sys;d=json.load(sys.stdin);f=d["format"];print("Duration:",f.get("duration","?"),"Size:",f.get("size","?"))' 2>/dev/null || file $2
}

cmd_convert() {
    local in="${2:-}"
    local out="${3:-}"
    [ -z "$in" ] && die "Usage: $SCRIPT_NAME convert <in out>"
    ffmpeg -i $2 $3 2>/dev/null && echo 'Converted to $3' || echo 'ffmpeg required'
}

cmd_trim() {
    local file="${2:-}"
    local start="${3:-}"
    local end="${4:-}"
    local out="${5:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME trim <file start end out>"
    ffmpeg -i $2 -ss $3 -to $4 -c copy $5 2>/dev/null && echo 'Trimmed' || echo 'ffmpeg required'
}

cmd_thumbnail() {
    local file="${2:-}"
    local timestamp="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME thumbnail <file timestamp>"
    ffmpeg -i $2 -ss ${3:-00:00:01} -vframes 1 thumb.jpg 2>/dev/null && echo 'Created thumb.jpg' || echo 'ffmpeg required'
}

cmd_compress() {
    local file="${2:-}"
    local out="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME compress <file out>"
    ffmpeg -i $2 -crf 28 -preset fast $3 2>/dev/null && echo 'Compressed' || echo 'ffmpeg required'
}

cmd_merge() {
    local f1="${2:-}"
    local f2="${3:-}"
    local out="${4:-}"
    [ -z "$f1" ] && die "Usage: $SCRIPT_NAME merge <f1 f2 out>"
    echo 'file $2' > /tmp/merge_list.txt && echo 'file $3' >> /tmp/merge_list.txt && ffmpeg -f concat -i /tmp/merge_list.txt -c copy $4 2>/dev/null || echo 'ffmpeg required'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "info <file>"
    printf "  %-25s\n" "convert <in out>"
    printf "  %-25s\n" "trim <file start end out>"
    printf "  %-25s\n" "thumbnail <file timestamp>"
    printf "  %-25s\n" "compress <file out>"
    printf "  %-25s\n" "merge <f1 f2 out>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        info) shift; cmd_info "$@" ;;
        convert) shift; cmd_convert "$@" ;;
        trim) shift; cmd_trim "$@" ;;
        thumbnail) shift; cmd_thumbnail "$@" ;;
        compress) shift; cmd_compress "$@" ;;
        merge) shift; cmd_merge "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
