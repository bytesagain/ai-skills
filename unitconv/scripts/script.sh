#!/usr/bin/env bash
set -euo pipefail
###############################################################################
# UnitConv — Unit Converter
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
###############################################################################

VERSION="3.0.0"
SCRIPT_NAME="unitconv"

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

err()  { echo -e "${RED}[ERROR]${NC} $*" >&2; }
info() { echo -e "${CYAN}[INFO]${NC} $*"; }

usage() {
  cat <<EOF
${BOLD}UnitConv v${VERSION}${NC} — Unit Converter
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

${BOLD}Usage:${NC}
  $SCRIPT_NAME length <value> <from> <to>   Convert length (m, ft, in, cm, km, mi, yd, mm)
  $SCRIPT_NAME weight <value> <from> <to>   Convert weight (kg, lb, oz, g, mg, ton)
  $SCRIPT_NAME temp <value> <from> <to>     Convert temperature (C, F, K)
  $SCRIPT_NAME speed <value> <from> <to>    Convert speed (kmh, mph, ms, knots, fts)
  $SCRIPT_NAME data <value> <from> <to>     Convert data (B, KB, MB, GB, TB, PB)
  $SCRIPT_NAME time <value> <from> <to>     Convert time (s, m, h, d, w, mo, y)

${BOLD}Examples:${NC}
  $SCRIPT_NAME length 100 cm in          # 100 centimeters to inches
  $SCRIPT_NAME weight 5 kg lb            # 5 kilograms to pounds
  $SCRIPT_NAME temp 100 C F              # 100 Celsius to Fahrenheit
  $SCRIPT_NAME speed 60 mph kmh          # 60 mph to km/h
  $SCRIPT_NAME data 1024 MB GB           # 1024 MB to GB
  $SCRIPT_NAME time 3600 s h             # 3600 seconds to hours
EOF
}

calc() {
  awk "BEGIN { printf \"%.6g\", $1 }"
}

convert_length() {
  local val="$1" from="$2" to="$3"
  # Everything to meters first
  local to_m from_m
  case "$from" in
    m)  from_m="1" ;;
    cm) from_m="0.01" ;;
    mm) from_m="0.001" ;;
    km) from_m="1000" ;;
    in) from_m="0.0254" ;;
    ft) from_m="0.3048" ;;
    yd) from_m="0.9144" ;;
    mi) from_m="1609.344" ;;
    *) err "Unknown length unit: $from (use m/cm/mm/km/in/ft/yd/mi)"; exit 1 ;;
  esac
  case "$to" in
    m)  to_m="1" ;;
    cm) to_m="0.01" ;;
    mm) to_m="0.001" ;;
    km) to_m="1000" ;;
    in) to_m="0.0254" ;;
    ft) to_m="0.3048" ;;
    yd) to_m="0.9144" ;;
    mi) to_m="1609.344" ;;
    *) err "Unknown length unit: $to (use m/cm/mm/km/in/ft/yd/mi)"; exit 1 ;;
  esac
  calc "${val} * ${from_m} / ${to_m}"
}

convert_weight() {
  local val="$1" from="$2" to="$3"
  local from_g to_g
  case "$from" in
    g)   from_g="1" ;;
    mg)  from_g="0.001" ;;
    kg)  from_g="1000" ;;
    lb)  from_g="453.592" ;;
    oz)  from_g="28.3495" ;;
    ton) from_g="907185" ;;
    *) err "Unknown weight unit: $from (use g/mg/kg/lb/oz/ton)"; exit 1 ;;
  esac
  case "$to" in
    g)   to_g="1" ;;
    mg)  to_g="0.001" ;;
    kg)  to_g="1000" ;;
    lb)  to_g="453.592" ;;
    oz)  to_g="28.3495" ;;
    ton) to_g="907185" ;;
    *) err "Unknown weight unit: $to (use g/mg/kg/lb/oz/ton)"; exit 1 ;;
  esac
  calc "${val} * ${from_g} / ${to_g}"
}

convert_temp() {
  local val="$1" from="$2" to="$3"

  # Normalize to uppercase
  from=$(echo "$from" | tr '[:lower:]' '[:upper:]')
  to=$(echo "$to" | tr '[:lower:]' '[:upper:]')

  if [[ "$from" == "$to" ]]; then
    calc "$val"
    return
  fi

  case "${from}-${to}" in
    C-F)  calc "(${val} * 9/5) + 32" ;;
    C-K)  calc "${val} + 273.15" ;;
    F-C)  calc "(${val} - 32) * 5/9" ;;
    F-K)  calc "((${val} - 32) * 5/9) + 273.15" ;;
    K-C)  calc "${val} - 273.15" ;;
    K-F)  calc "((${val} - 273.15) * 9/5) + 32" ;;
    *) err "Unknown temperature units: $from -> $to (use C/F/K)"; exit 1 ;;
  esac
}

convert_speed() {
  local val="$1" from="$2" to="$3"
  # Everything to m/s
  local from_ms to_ms
  case "$from" in
    ms|"m/s")    from_ms="1" ;;
    kmh|"km/h")  from_ms="0.277778" ;;
    mph)         from_ms="0.44704" ;;
    knots|kn)    from_ms="0.514444" ;;
    fts|"ft/s")  from_ms="0.3048" ;;
    *) err "Unknown speed unit: $from (use ms/kmh/mph/knots/fts)"; exit 1 ;;
  esac
  case "$to" in
    ms|"m/s")    to_ms="1" ;;
    kmh|"km/h")  to_ms="0.277778" ;;
    mph)         to_ms="0.44704" ;;
    knots|kn)    to_ms="0.514444" ;;
    fts|"ft/s")  to_ms="0.3048" ;;
    *) err "Unknown speed unit: $to (use ms/kmh/mph/knots/fts)"; exit 1 ;;
  esac
  calc "${val} * ${from_ms} / ${to_ms}"
}

convert_data() {
  local val="$1" from="$2" to="$3"
  # Uppercase
  from=$(echo "$from" | tr '[:lower:]' '[:upper:]')
  to=$(echo "$to" | tr '[:lower:]' '[:upper:]')
  # Everything to bytes
  local from_b to_b
  case "$from" in
    B)  from_b="1" ;;
    KB) from_b="1024" ;;
    MB) from_b="1048576" ;;
    GB) from_b="1073741824" ;;
    TB) from_b="1099511627776" ;;
    PB) from_b="1125899906842624" ;;
    *) err "Unknown data unit: $from (use B/KB/MB/GB/TB/PB)"; exit 1 ;;
  esac
  case "$to" in
    B)  to_b="1" ;;
    KB) to_b="1024" ;;
    MB) to_b="1048576" ;;
    GB) to_b="1073741824" ;;
    TB) to_b="1099511627776" ;;
    PB) to_b="1125899906842624" ;;
    *) err "Unknown data unit: $to (use B/KB/MB/GB/TB/PB)"; exit 1 ;;
  esac
  calc "${val} * ${from_b} / ${to_b}"
}

convert_time() {
  local val="$1" from="$2" to="$3"
  # Everything to seconds
  local from_s to_s
  case "$from" in
    s)      from_s="1" ;;
    m|min)  from_s="60" ;;
    h|hr)   from_s="3600" ;;
    d|day)  from_s="86400" ;;
    w|wk)   from_s="604800" ;;
    mo)     from_s="2592000" ;;
    y|yr)   from_s="31536000" ;;
    *) err "Unknown time unit: $from (use s/m/h/d/w/mo/y)"; exit 1 ;;
  esac
  case "$to" in
    s)      to_s="1" ;;
    m|min)  to_s="60" ;;
    h|hr)   to_s="3600" ;;
    d|day)  to_s="86400" ;;
    w|wk)   to_s="604800" ;;
    mo)     to_s="2592000" ;;
    y|yr)   to_s="31536000" ;;
    *) err "Unknown time unit: $to (use s/m/h/d/w/mo/y)"; exit 1 ;;
  esac
  calc "${val} * ${from_s} / ${to_s}"
}

# Main dispatch
if [[ $# -lt 1 ]]; then
  usage
  exit 0
fi

cmd="$1"; shift

case "$cmd" in
  length)
    [[ $# -ge 3 ]] || { err "Usage: $SCRIPT_NAME length <value> <from> <to>"; exit 1; }
    result=$(convert_length "$1" "$2" "$3")
    echo -e "${GREEN}${1} ${2}${NC} = ${BOLD}${result} ${3}${NC}"
    ;;
  weight)
    [[ $# -ge 3 ]] || { err "Usage: $SCRIPT_NAME weight <value> <from> <to>"; exit 1; }
    result=$(convert_weight "$1" "$2" "$3")
    echo -e "${GREEN}${1} ${2}${NC} = ${BOLD}${result} ${3}${NC}"
    ;;
  temp)
    [[ $# -ge 3 ]] || { err "Usage: $SCRIPT_NAME temp <value> <from> <to>"; exit 1; }
    result=$(convert_temp "$1" "$2" "$3")
    echo -e "${GREEN}${1}°${2}${NC} = ${BOLD}${result}°${3}${NC}"
    ;;
  speed)
    [[ $# -ge 3 ]] || { err "Usage: $SCRIPT_NAME speed <value> <from> <to>"; exit 1; }
    result=$(convert_speed "$1" "$2" "$3")
    echo -e "${GREEN}${1} ${2}${NC} = ${BOLD}${result} ${3}${NC}"
    ;;
  data)
    [[ $# -ge 3 ]] || { err "Usage: $SCRIPT_NAME data <value> <from> <to>"; exit 1; }
    result=$(convert_data "$1" "$2" "$3")
    echo -e "${GREEN}${1} ${2}${NC} = ${BOLD}${result} ${3}${NC}"
    ;;
  time)
    [[ $# -ge 3 ]] || { err "Usage: $SCRIPT_NAME time <value> <from> <to>"; exit 1; }
    result=$(convert_time "$1" "$2" "$3")
    echo -e "${GREEN}${1} ${2}${NC} = ${BOLD}${result} ${3}${NC}"
    ;;
  -h|--help) usage ;;
  *)
    err "Unknown command: $cmd"
    usage
    exit 1
    ;;
esac
