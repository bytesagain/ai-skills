#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="image"
DATA_DIR="$HOME/.local/share/image"
mkdir -p "$DATA_DIR"

# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# image — Inspect and process image files with metadata and conversion
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_info() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME info <file>"
    file "$2" && identify "$2" 2>/dev/null || echo 'ImageMagick not available'
}

cmd_size() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME size <file>"
    stat -c '%s bytes' "$2" 2>/dev/null
}

cmd_exif() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME exif <file>"
    identify -verbose "$2" 2>/dev/null | head -30 || echo 'ImageMagick required'
}

cmd_list() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME list <dir>"
    find "${2:-.}" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.webp' \) | wc -l | awk '{print $1" images"}'
}

cmd_convert() {
    local in="${2:-}"
    local out="${3:-}"
    [ -z "$in" ] && die "Usage: $SCRIPT_NAME convert <in out>"
    convert "$2" "$3" 2>/dev/null && echo 'Converted' || echo 'ImageMagick required'
}

cmd_thumb() {
    local file="${2:-}"
    local size="${3:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME thumb <file size>"
    convert "$2" -resize "${3:-128x128}" "thumb_$(basename $2)" 2>/dev/null || echo 'ImageMagick required'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "info <file>" ""
    printf "  %-20s %s\n" "size <file>" ""
    printf "  %-20s %s\n" "exif <file>" ""
    printf "  %-20s %s\n" "list <dir>" ""
    printf "  %-20s %s\n" "convert <in out>" ""
    printf "  %-20s %s\n" "thumb <file size>" ""
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
        info) shift; cmd_info "$@" ;;
        size) shift; cmd_size "$@" ;;
        exif) shift; cmd_exif "$@" ;;
        list) shift; cmd_list "$@" ;;
        convert) shift; cmd_convert "$@" ;;
        thumb) shift; cmd_thumb "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
