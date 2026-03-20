#!/usr/bin/env bash
set -euo pipefail
###############################################################################
# Favicon — Favicon Tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
###############################################################################

VERSION="3.0.0"
SCRIPT_NAME="favicon"

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

err()  { echo -e "${RED}[ERROR]${NC} $*" >&2; }
info() { echo -e "${CYAN}[INFO]${NC} $*"; }
ok()   { echo -e "${GREEN}[OK]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }

USER_AGENT="Mozilla/5.0 (compatible; Favicon/${VERSION}; +https://bytesagain.com)"

usage() {
  cat <<EOF
${BOLD}Favicon v${VERSION}${NC} — Favicon Tool
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

${BOLD}Usage:${NC}
  $SCRIPT_NAME check <url>                 Check if site has favicon
  $SCRIPT_NAME download <url> [output]     Download favicon from site
  $SCRIPT_NAME generate <text> [size]      Generate SVG favicon placeholder
  $SCRIPT_NAME info <file>                 Show image file info

${BOLD}Examples:${NC}
  $SCRIPT_NAME check https://github.com
  $SCRIPT_NAME download https://google.com favicon.ico
  $SCRIPT_NAME generate "AB" 64
  $SCRIPT_NAME info favicon.ico
EOF
}

require_curl() {
  if ! command -v curl &>/dev/null; then
    err "curl is required but not found."
    exit 1
  fi
}

# Strip protocol and path to get domain
get_domain() {
  echo "$1" | sed -E 's|https?://||' | sed 's|/.*||'
}

# Normalize URL to have protocol
normalize_url() {
  local url="$1"
  if [[ ! "$url" =~ ^https?:// ]]; then
    url="https://${url}"
  fi
  echo "$url"
}

cmd_check() {
  local raw_url="${1:?Usage: $SCRIPT_NAME check <url>}"
  local url
  url=$(normalize_url "$raw_url")
  local domain
  domain=$(get_domain "$url")

  info "Checking favicon for ${BOLD}${domain}${NC}..."
  echo ""

  local found=0

  # Method 1: /favicon.ico
  local ico_url="${url%%/}/favicon.ico"
  local code
  code=$(curl -sL -o /dev/null -w '%{http_code}' --max-time 10 -A "$USER_AGENT" "$ico_url" 2>/dev/null || echo "000")
  if [[ "$code" =~ ^2 ]]; then
    local content_type
    content_type=$(curl -sI -L --max-time 10 -A "$USER_AGENT" "$ico_url" 2>/dev/null | grep -i 'content-type' | tail -1 | tr -d '\r')
    echo -e "  ${GREEN}✓${NC} /favicon.ico — ${code} ${content_type:-}"
    found=1
  else
    echo -e "  ${RED}✗${NC} /favicon.ico — ${code}"
  fi

  # Method 2: Parse HTML for <link rel="icon">
  local page
  page=$(curl -sL --max-time 10 -A "$USER_AGENT" "$url" 2>/dev/null || echo "")

  if [[ -n "$page" ]]; then
    local icons
    icons=$(echo "$page" | grep -oEi '<link[^>]*(rel="[^"]*icon[^"]*"|rel='"'"'[^'"'"']*icon[^'"'"']*'"'"')[^>]*>' | head -5)

    if [[ -n "$icons" ]]; then
      while IFS= read -r tag; do
        local href
        href=$(echo "$tag" | grep -oEi 'href="[^"]*"' | sed 's/href="//;s/"$//' | head -1)
        [[ -z "$href" ]] && href=$(echo "$tag" | grep -oEi "href='[^']*'" | sed "s/href='//;s/'$//" | head -1)
        if [[ -n "$href" ]]; then
          # Resolve relative URL
          if [[ "$href" =~ ^// ]]; then
            href="https:${href}"
          elif [[ "$href" =~ ^/ ]]; then
            href="${url%%/}${href}"
          elif [[ ! "$href" =~ ^https?:// ]]; then
            href="${url%%/}/${href}"
          fi
          local icode
          icode=$(curl -sL -o /dev/null -w '%{http_code}' --max-time 10 -A "$USER_AGENT" "$href" 2>/dev/null || echo "000")
          if [[ "$icode" =~ ^2 ]]; then
            echo -e "  ${GREEN}✓${NC} ${href} — ${icode}"
            found=1
          else
            echo -e "  ${YELLOW}?${NC} ${href} — ${icode}"
          fi
        fi
      done <<< "$icons"
    fi

    # Method 3: Check apple-touch-icon
    local apple
    apple=$(echo "$page" | grep -oEi '<link[^>]*rel="apple-touch-icon[^"]*"[^>]*>' | head -1)
    if [[ -n "$apple" ]]; then
      local ahref
      ahref=$(echo "$apple" | grep -oEi 'href="[^"]*"' | sed 's/href="//;s/"$//')
      if [[ -n "$ahref" ]]; then
        if [[ "$ahref" =~ ^/ ]]; then
          ahref="${url%%/}${ahref}"
        elif [[ ! "$ahref" =~ ^https?:// ]]; then
          ahref="${url%%/}/${ahref}"
        fi
        echo -e "  ${CYAN}ℹ${NC} apple-touch-icon: ${ahref}"
        found=1
      fi
    fi
  fi

  echo ""
  if [[ "$found" -eq 1 ]]; then
    ok "Favicon found for ${domain}"
  else
    warn "No favicon found for ${domain}"
  fi
}

cmd_download() {
  local raw_url="${1:?Usage: $SCRIPT_NAME download <url> [output]}"
  local url
  url=$(normalize_url "$raw_url")
  local domain
  domain=$(get_domain "$url")
  local output="${2:-${domain}-favicon.ico}"

  info "Downloading favicon from ${BOLD}${domain}${NC}..."

  # Try direct /favicon.ico first
  local ico_url="${url%%/}/favicon.ico"
  local code
  code=$(curl -sL -o "$output" -w '%{http_code}' --max-time 15 -A "$USER_AGENT" "$ico_url" 2>/dev/null || echo "000")

  if [[ "$code" =~ ^2 ]] && [[ -s "$output" ]]; then
    local size
    size=$(wc -c < "$output")
    ok "Downloaded favicon to ${output} (${size} bytes)"
    return 0
  fi

  # Try parsing page for icon link
  local page
  page=$(curl -sL --max-time 10 -A "$USER_AGENT" "$url" 2>/dev/null || echo "")
  local href
  href=$(echo "$page" | grep -oEi '<link[^>]*rel="[^"]*icon[^"]*"[^>]*href="[^"]*"' | \
    grep -oEi 'href="[^"]*"' | sed 's/href="//;s/"$//' | head -1)

  if [[ -n "$href" ]]; then
    if [[ "$href" =~ ^// ]]; then
      href="https:${href}"
    elif [[ "$href" =~ ^/ ]]; then
      href="${url%%/}${href}"
    elif [[ ! "$href" =~ ^https?:// ]]; then
      href="${url%%/}/${href}"
    fi

    code=$(curl -sL -o "$output" -w '%{http_code}' --max-time 15 -A "$USER_AGENT" "$href" 2>/dev/null || echo "000")
    if [[ "$code" =~ ^2 ]] && [[ -s "$output" ]]; then
      local size
      size=$(wc -c < "$output")
      ok "Downloaded favicon to ${output} (${size} bytes)"
      return 0
    fi
  fi

  # Try Google's favicon service as fallback
  local google_url="https://www.google.com/s2/favicons?domain=${domain}&sz=64"
  code=$(curl -sL -o "$output" -w '%{http_code}' --max-time 10 "$google_url" 2>/dev/null || echo "000")
  if [[ "$code" =~ ^2 ]] && [[ -s "$output" ]]; then
    local size
    size=$(wc -c < "$output")
    ok "Downloaded via Google API to ${output} (${size} bytes)"
    return 0
  fi

  rm -f "$output"
  err "Could not download favicon from ${domain}"
  return 1
}

cmd_generate() {
  local text="${1:?Usage: $SCRIPT_NAME generate <text> [size]}"
  local size="${2:-64}"
  local output="${text// /_}-favicon.svg"

  # Truncate text to 2 chars for favicon
  local display_text="${text:0:2}"

  info "Generating SVG favicon: \"${display_text}\" (${size}x${size})..."

  # Generate random background color
  local bg_r bg_g bg_b
  bg_r=$(( (RANDOM % 200) + 30 ))
  bg_g=$(( (RANDOM % 200) + 30 ))
  bg_b=$(( (RANDOM % 200) + 30 ))
  local bg_hex
  bg_hex=$(printf "#%02X%02X%02X" "$bg_r" "$bg_g" "$bg_b")

  # Calculate text color (white or black based on luminance)
  local lum
  lum=$(awk "BEGIN { printf \"%.3f\", (0.299 * ${bg_r} + 0.587 * ${bg_g} + 0.114 * ${bg_b}) / 255 }")
  local text_color
  text_color=$(awk "BEGIN { print ($lum > 0.5) ? \"#000000\" : \"#FFFFFF\" }")

  local font_size
  font_size=$(awk "BEGIN { printf \"%d\", ${size} * 0.5 }")

  cat > "$output" <<SVGEOF
<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 ${size} ${size}">
  <rect width="100%" height="100%" rx="8" ry="8" fill="${bg_hex}"/>
  <text x="50%" y="50%" dominant-baseline="central" text-anchor="middle"
        font-family="Arial, Helvetica, sans-serif" font-size="${font_size}" font-weight="bold"
        fill="${text_color}">${display_text}</text>
</svg>
SVGEOF

  ok "Generated: ${output}"
  echo -e "  ${BOLD}Size:${NC}       ${size}x${size}"
  echo -e "  ${BOLD}Text:${NC}       ${display_text}"
  echo -e "  ${BOLD}Background:${NC} ${bg_hex}"
  echo -e "  ${BOLD}Text color:${NC} ${text_color}"
}

cmd_info() {
  local file="${1:?Usage: $SCRIPT_NAME info <file>}"

  if [[ ! -f "$file" ]]; then
    err "File not found: $file"
    exit 1
  fi

  info "File info for ${BOLD}${file}${NC}:"
  echo ""

  local size
  size=$(wc -c < "$file")
  echo -e "  ${BOLD}File:${NC}     ${file}"
  echo -e "  ${BOLD}Size:${NC}     ${size} bytes ($(awk "BEGIN { printf \"%.1f\", ${size}/1024 }") KB)"

  # MIME type
  if command -v file &>/dev/null; then
    local mime
    mime=$(file --mime-type -b "$file" 2>/dev/null || echo "unknown")
    echo -e "  ${BOLD}MIME:${NC}     ${mime}"

    local desc
    desc=$(file -b "$file" 2>/dev/null || echo "unknown")
    echo -e "  ${BOLD}Type:${NC}     ${desc}"
  else
    warn "'file' command not available for MIME detection"
  fi

  # Check file magic bytes
  local magic
  magic=$(xxd -l 4 -p "$file" 2>/dev/null || echo "")
  case "$magic" in
    00000100) echo -e "  ${BOLD}Format:${NC}   ICO (Windows Icon)" ;;
    89504e47) echo -e "  ${BOLD}Format:${NC}   PNG" ;;
    ffd8ff*)  echo -e "  ${BOLD}Format:${NC}   JPEG" ;;
    47494638) echo -e "  ${BOLD}Format:${NC}   GIF" ;;
    52494646) echo -e "  ${BOLD}Format:${NC}   WebP (RIFF)" ;;
    3c737667|3c3f786d|3c212d2d)
              echo -e "  ${BOLD}Format:${NC}   SVG (XML)" ;;
    *)        echo -e "  ${BOLD}Magic:${NC}    ${magic:-unknown}" ;;
  esac

  # Modification time
  local mtime
  mtime=$(stat -c '%y' "$file" 2>/dev/null || stat -f '%Sm' "$file" 2>/dev/null || echo "unknown")
  echo -e "  ${BOLD}Modified:${NC} ${mtime}"
}

# Main dispatch
require_curl

case "${1:-}" in
  check)    shift; cmd_check "$@" ;;
  download) shift; cmd_download "$@" ;;
  generate) shift; cmd_generate "$@" ;;
  info)     shift; cmd_info "$@" ;;
  -h|--help|"") usage ;;
  *)
    err "Unknown command: $1"
    usage
    exit 1
    ;;
esac
