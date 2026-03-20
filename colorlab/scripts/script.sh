#!/usr/bin/env bash
set -euo pipefail
###############################################################################
# ColorLab — Color Tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
###############################################################################

VERSION="3.0.0"
SCRIPT_NAME="colorlab"

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

err()  { echo -e "${RED}[ERROR]${NC} $*" >&2; }
info() { echo -e "${CYAN}[INFO]${NC} $*"; }

usage() {
  cat <<EOF
${BOLD}ColorLab v${VERSION}${NC} — Color Tool
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

${BOLD}Usage:${NC}
  $SCRIPT_NAME hex-to-rgb <hex>              Convert hex to RGB
  $SCRIPT_NAME rgb-to-hex <r> <g> <b>        Convert RGB to hex
  $SCRIPT_NAME contrast <hex1> <hex2>        WCAG contrast ratio
  $SCRIPT_NAME palette <hex> [count]         Generate lighter/darker variants
  $SCRIPT_NAME random [count]               Generate random colors
  $SCRIPT_NAME name <hex>                   Closest named CSS color

${BOLD}Examples:${NC}
  $SCRIPT_NAME hex-to-rgb "#FF5733"
  $SCRIPT_NAME rgb-to-hex 255 87 51
  $SCRIPT_NAME contrast "#FFFFFF" "#000000"
  $SCRIPT_NAME palette "#3498db" 5
  $SCRIPT_NAME random 10
  $SCRIPT_NAME name "#e74c3c"
EOF
}

# Strip # prefix from hex
strip_hash() { echo "${1#\#}"; }

# Validate hex color (3 or 6 chars)
validate_hex() {
  local hex
  hex=$(strip_hash "$1")
  if [[ ${#hex} -eq 3 ]]; then
    hex="${hex:0:1}${hex:0:1}${hex:1:1}${hex:1:1}${hex:2:1}${hex:2:1}"
  fi
  if ! [[ "$hex" =~ ^[0-9A-Fa-f]{6}$ ]]; then
    err "Invalid hex color: $1"
    exit 1
  fi
  echo "$hex"
}

hex_to_r() { printf "%d" "0x${1:0:2}"; }
hex_to_g() { printf "%d" "0x${1:2:2}"; }
hex_to_b() { printf "%d" "0x${1:4:2}"; }

cmd_hex_to_rgb() {
  local input="${1:?Usage: $SCRIPT_NAME hex-to-rgb <hex>}"
  local hex
  hex=$(validate_hex "$input")
  local r g b
  r=$(hex_to_r "$hex")
  g=$(hex_to_g "$hex")
  b=$(hex_to_b "$hex")
  echo -e "${BOLD}#${hex^^}${NC} → ${GREEN}rgb(${r}, ${g}, ${b})${NC}"
  echo -e "  R: ${r}  G: ${g}  B: ${b}"
}

cmd_rgb_to_hex() {
  local r="${1:?Usage: $SCRIPT_NAME rgb-to-hex <r> <g> <b>}"
  local g="${2:?Usage: $SCRIPT_NAME rgb-to-hex <r> <g> <b>}"
  local b="${3:?Usage: $SCRIPT_NAME rgb-to-hex <r> <g> <b>}"

  # Validate range
  for v in "$r" "$g" "$b"; do
    if [[ "$v" -lt 0 || "$v" -gt 255 ]]; then
      err "RGB values must be 0-255 (got: $v)"
      exit 1
    fi
  done

  local hex
  hex=$(printf "%02X%02X%02X" "$r" "$g" "$b")
  echo -e "${GREEN}rgb(${r}, ${g}, ${b})${NC} → ${BOLD}#${hex}${NC}"
}

# Relative luminance per WCAG 2.0
luminance() {
  local r="$1" g="$2" b="$3"
  awk "BEGIN {
    rs = $r / 255.0
    gs = $g / 255.0
    bs = $b / 255.0
    rl = (rs <= 0.03928) ? rs / 12.92 : ((rs + 0.055) / 1.055) ^ 2.4
    gl = (gs <= 0.03928) ? gs / 12.92 : ((gs + 0.055) / 1.055) ^ 2.4
    bl = (bs <= 0.03928) ? bs / 12.92 : ((bs + 0.055) / 1.055) ^ 2.4
    printf \"%.6f\", 0.2126 * rl + 0.7152 * gl + 0.0722 * bl
  }"
}

cmd_contrast() {
  local hex1_raw="${1:?Usage: $SCRIPT_NAME contrast <hex1> <hex2>}"
  local hex2_raw="${2:?Usage: $SCRIPT_NAME contrast <hex1> <hex2>}"
  local hex1 hex2
  hex1=$(validate_hex "$hex1_raw")
  hex2=$(validate_hex "$hex2_raw")

  local r1 g1 b1 r2 g2 b2
  r1=$(hex_to_r "$hex1"); g1=$(hex_to_g "$hex1"); b1=$(hex_to_b "$hex1")
  r2=$(hex_to_r "$hex2"); g2=$(hex_to_g "$hex2"); b2=$(hex_to_b "$hex2")

  local l1 l2
  l1=$(luminance "$r1" "$g1" "$b1")
  l2=$(luminance "$r2" "$g2" "$b2")

  local ratio
  ratio=$(awk "BEGIN {
    l1 = $l1; l2 = $l2
    if (l1 > l2) { lighter = l1; darker = l2 }
    else { lighter = l2; darker = l1 }
    printf \"%.2f\", (lighter + 0.05) / (darker + 0.05)
  }")

  echo -e "${BOLD}Contrast Ratio:${NC} ${ratio}:1"
  echo -e "  #${hex1^^} vs #${hex2^^}"
  echo ""

  # WCAG ratings
  local ratio_num
  ratio_num=$(awk "BEGIN { printf \"%.2f\", $ratio }")

  local aa_normal aa_large aaa_normal aaa_large
  aa_normal=$(awk "BEGIN { print ($ratio >= 4.5) ? \"PASS\" : \"FAIL\" }")
  aa_large=$(awk "BEGIN { print ($ratio >= 3.0) ? \"PASS\" : \"FAIL\" }")
  aaa_normal=$(awk "BEGIN { print ($ratio >= 7.0) ? \"PASS\" : \"FAIL\" }")
  aaa_large=$(awk "BEGIN { print ($ratio >= 4.5) ? \"PASS\" : \"FAIL\" }")

  local pass_color fail_color
  pass_color="$GREEN"
  fail_color="$RED"

  echo -e "  ${BOLD}WCAG AA  Normal:${NC} $([[ $aa_normal == PASS ]] && echo -e "${pass_color}✓ PASS${NC}" || echo -e "${fail_color}✗ FAIL${NC}") (≥4.5:1)"
  echo -e "  ${BOLD}WCAG AA  Large:${NC}  $([[ $aa_large == PASS ]] && echo -e "${pass_color}✓ PASS${NC}" || echo -e "${fail_color}✗ FAIL${NC}") (≥3.0:1)"
  echo -e "  ${BOLD}WCAG AAA Normal:${NC} $([[ $aaa_normal == PASS ]] && echo -e "${pass_color}✓ PASS${NC}" || echo -e "${fail_color}✗ FAIL${NC}") (≥7.0:1)"
  echo -e "  ${BOLD}WCAG AAA Large:${NC}  $([[ $aaa_large == PASS ]] && echo -e "${pass_color}✓ PASS${NC}" || echo -e "${fail_color}✗ FAIL${NC}") (≥4.5:1)"
}

cmd_palette() {
  local hex_raw="${1:?Usage: $SCRIPT_NAME palette <hex> [count]}"
  local count="${2:-5}"
  local hex
  hex=$(validate_hex "$hex_raw")

  local r g b
  r=$(hex_to_r "$hex")
  g=$(hex_to_g "$hex")
  b=$(hex_to_b "$hex")

  echo -e "${BOLD}Palette for #${hex^^}${NC} (${count} variants):"
  echo ""

  local i
  for (( i = -count; i <= count; i++ )); do
    local nr ng nb nhex
    nr=$(awk "BEGIN { v = int($r + ($i * (255 - $r) / ($count + 1))); if(v<0)v=0; if(v>255)v=255; print v }")
    ng=$(awk "BEGIN { v = int($g + ($i * (255 - $g) / ($count + 1))); if(v<0)v=0; if(v>255)v=255; print v }")
    nb=$(awk "BEGIN { v = int($b + ($i * (255 - $b) / ($count + 1))); if(v<0)v=0; if(v>255)v=255; print v }")
    nhex=$(printf "%02X%02X%02X" "$nr" "$ng" "$nb")

    local label=""
    if [[ $i -lt 0 ]]; then
      label="darker"
    elif [[ $i -gt 0 ]]; then
      label="lighter"
    else
      label="base"
    fi

    # Show color swatch using ANSI 24-bit color
    echo -e "  \033[48;2;${nr};${ng};${nb}m    \033[0m  #${nhex}  rgb(${nr}, ${ng}, ${nb})  [${label}]"
  done
}

cmd_random() {
  local count="${1:-1}"
  echo -e "${BOLD}Random Colors (${count}):${NC}"
  echo ""

  local i
  for (( i = 0; i < count; i++ )); do
    local r g b hex
    r=$(( RANDOM % 256 ))
    g=$(( RANDOM % 256 ))
    b=$(( RANDOM % 256 ))
    hex=$(printf "%02X%02X%02X" "$r" "$g" "$b")
    echo -e "  \033[48;2;${r};${g};${b}m    \033[0m  #${hex}  rgb(${r}, ${g}, ${b})"
  done
}

cmd_name() {
  local hex_raw="${1:?Usage: $SCRIPT_NAME name <hex>}"
  local hex
  hex=$(validate_hex "$hex_raw")
  local r g b
  r=$(hex_to_r "$hex")
  g=$(hex_to_g "$hex")
  b=$(hex_to_b "$hex")

  # Subset of named CSS colors: name r g b
  local -a colors=(
    "Black 0 0 0" "White 255 255 255" "Red 255 0 0" "Lime 0 255 0"
    "Blue 0 0 255" "Yellow 255 255 0" "Cyan 0 255 255" "Magenta 255 0 255"
    "Silver 192 192 192" "Gray 128 128 128" "Maroon 128 0 0" "Olive 128 128 0"
    "Green 0 128 0" "Purple 128 0 128" "Teal 0 128 128" "Navy 0 0 128"
    "Orange 255 165 0" "Coral 255 127 80" "Salmon 250 128 114"
    "Tomato 255 99 71" "Gold 255 215 0" "Khaki 240 230 140"
    "Violet 238 130 238" "Plum 221 160 221" "Orchid 218 112 214"
    "Pink 255 192 203" "Crimson 220 20 60" "Indigo 75 0 130"
    "SteelBlue 70 130 180" "SlateGray 112 128 144" "DodgerBlue 30 144 255"
    "DeepSkyBlue 0 191 255" "Turquoise 64 224 208" "MediumSeaGreen 60 179 113"
    "LimeGreen 50 205 50" "SpringGreen 0 255 127" "DarkGreen 0 100 0"
    "DarkRed 139 0 0" "Sienna 160 82 45" "Chocolate 210 105 30"
    "Peru 205 133 63" "Tan 210 180 140" "Beige 245 245 220"
    "Ivory 255 255 240" "Lavender 230 230 250" "MistyRose 255 228 225"
    "Snow 255 250 250" "Honeydew 240 255 240" "AliceBlue 240 248 255"
    "SkyBlue 135 206 235" "RoyalBlue 65 105 225" "MidnightBlue 25 25 112"
    "DarkOrange 255 140 0" "OrangeRed 255 69 0" "FireBrick 178 34 34"
  )

  local best_name="" best_dist=999999
  for entry in "${colors[@]}"; do
    local cname cr cg cb
    read -r cname cr cg cb <<< "$entry"
    local dist
    dist=$(awk "BEGIN {
      dr = $r - $cr; dg = $g - $cg; db = $b - $cb
      printf \"%d\", dr*dr + dg*dg + db*db
    }")
    if [[ "$dist" -lt "$best_dist" ]]; then
      best_dist="$dist"
      best_name="$cname"
    fi
  done

  echo -e "${BOLD}#${hex^^}${NC} ≈ ${GREEN}${best_name}${NC}"
  echo -e "  Distance: $(awk "BEGIN { printf \"%.1f\", sqrt($best_dist) }")"
}

# Main dispatch
case "${1:-}" in
  hex-to-rgb)  shift; cmd_hex_to_rgb "$@" ;;
  rgb-to-hex)  shift; cmd_rgb_to_hex "$@" ;;
  contrast)    shift; cmd_contrast "$@" ;;
  palette)     shift; cmd_palette "$@" ;;
  random)      shift; cmd_random "$@" ;;
  name)        shift; cmd_name "$@" ;;
  -h|--help|"") usage ;;
  *)
    err "Unknown command: $1"
    usage
    exit 1
    ;;
esac
