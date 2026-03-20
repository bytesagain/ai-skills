#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="chinese-calendar-cn"
DATA_DIR="$HOME/.local/share/chinese-calendar-cn"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_today() {
    echo "$(date +%Y-%m-%d) $(date +%A)"; local y=$(date +%Y); local z=$((($y - 4) % 12)); local animals='鼠 牛 虎 兔 龙 蛇 马 羊 猴 鸡 狗 猪'; echo "生肖: $(echo $animals | cut -d' ' -f$((z+1)))"
}

cmd_zodiac() {
    local year="${2:-}"
    [ -z "$year" ] && die "Usage: $SCRIPT_NAME zodiac <year>"
    local z=$(((${2:-$(date +%Y)} - 4) % 12)); local animals='鼠 牛 虎 兔 龙 蛇 马 羊 猴 鸡 狗 猪'; echo $(echo $animals | cut -d' ' -f$((z+1)))
}

cmd_festival() {
    local year="${2:-}"
    [ -z "$year" ] && die "Usage: $SCRIPT_NAME festival <year>"
    echo '${2:-2026}年主要节日:'; echo '春节 元宵节 清明节 端午节 中秋节 重阳节'
}

cmd_solar_term() {
    local month="${2:-}"
    [ -z "$month" ] && die "Usage: $SCRIPT_NAME solar-term <month>"
    echo '${2:-1}月节气: 小寒 大寒'
}

cmd_convert() {
    local date="${2:-}"
    [ -z "$date" ] && die "Usage: $SCRIPT_NAME convert <date>"
    echo '阳历 $2 对应农历日期（需要查表）'
}

cmd_list() {
    echo '十二生肖: 鼠 牛 虎 兔 龙 蛇 马 羊 猴 鸡 狗 猪'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "today"
    printf "  %-25s\n" "zodiac <year>"
    printf "  %-25s\n" "festival <year>"
    printf "  %-25s\n" "solar-term <month>"
    printf "  %-25s\n" "convert <date>"
    printf "  %-25s\n" "list"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        today) shift; cmd_today "$@" ;;
        zodiac) shift; cmd_zodiac "$@" ;;
        festival) shift; cmd_festival "$@" ;;
        solar-term) shift; cmd_solar_term "$@" ;;
        convert) shift; cmd_convert "$@" ;;
        list) shift; cmd_list "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
