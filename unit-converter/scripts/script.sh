#!/usr/bin/env bash
# unit-converter v2.0.0 - Universal Unit Converter
# Powered by BytesAgain | bytesagain.com
set -uo pipefail
VERSION="2.0.0"

_calc() {
    python3 -c "print(f'Result: {eval(sys.argv[1])}')" "$1" 2>/dev/null || echo "Error in calculation"
}

cmd_convert() {
    local val=$1; local from=$2; local to=$3
    echo "🔄 Converting $val $from to $to..."
    case "$from-$to" in
        c-f) echo "$val * 9/5 + 32" | bc -l ;;
        f-c) echo "($val - 32) * 5/9" | bc -l ;;
        km-mi) echo "$val * 0.621371" | bc -l ;;
        mi-km) echo "$val / 0.621371" | bc -l ;;
        kg-lb) echo "$val * 2.20462" | bc -l ;;
        *) echo "Unit combo not supported yet." ;;
    esac
}

case "${1:-help}" in
    convert) shift; cmd_convert "$@" ;;
    *) echo "Usage: script.sh convert <val> <from_unit> <to_unit> (e.g. 100 c f)";;
esac
echo -e "\n📖 More skills: bytesagain.com"
