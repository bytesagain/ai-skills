#!/usr/bin/env bash
set -euo pipefail
###############################################################################
# DeadLink — Dead Link Checker
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
###############################################################################

VERSION="3.0.0"
SCRIPT_NAME="deadlink"

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

err()  { echo -e "${RED}[ERROR]${NC} $*" >&2; }
info() { echo -e "${CYAN}[INFO]${NC} $*"; }
ok()   { echo -e "${GREEN}[OK]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }

TIMEOUT=10
USER_AGENT="Mozilla/5.0 (compatible; DeadLink/${VERSION}; +https://bytesagain.com)"

usage() {
  cat <<EOF
${BOLD}DeadLink v${VERSION}${NC} — Dead Link Checker
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

${BOLD}Usage:${NC}
  $SCRIPT_NAME check <url>             Check single URL
  $SCRIPT_NAME scan <file>             Check all URLs in a file
  $SCRIPT_NAME site <url> [depth]      Crawl site for broken links
  $SCRIPT_NAME report <file>           Generate report from URL file

${BOLD}Examples:${NC}
  $SCRIPT_NAME check https://example.com
  $SCRIPT_NAME scan urls.txt
  $SCRIPT_NAME site https://example.com 2
  $SCRIPT_NAME report links.txt
EOF
}

require_curl() {
  if ! command -v curl &>/dev/null; then
    err "curl is required but not found."
    exit 1
  fi
}

# Check a single URL, return status code
check_url() {
  local url="$1"
  local code
  code=$(curl -sL -o /dev/null -w '%{http_code}' \
    --max-time "$TIMEOUT" \
    --connect-timeout 5 \
    -A "$USER_AGENT" \
    "$url" 2>/dev/null || echo "000")
  echo "$code"
}

# Classify HTTP status
status_label() {
  local code="$1"
  case "$code" in
    2[0-9][0-9]) echo -e "${GREEN}OK${NC}" ;;
    3[0-9][0-9]) echo -e "${YELLOW}REDIRECT${NC}" ;;
    4[0-9][0-9]) echo -e "${RED}CLIENT ERROR${NC}" ;;
    5[0-9][0-9]) echo -e "${RED}SERVER ERROR${NC}" ;;
    000)         echo -e "${RED}TIMEOUT/DNS${NC}" ;;
    *)           echo -e "${RED}UNKNOWN${NC}" ;;
  esac
}

is_dead() {
  local code="$1"
  case "$code" in
    2[0-9][0-9]|3[0-9][0-9]) return 1 ;;  # alive
    *) return 0 ;;  # dead
  esac
}

cmd_check() {
  local url="${1:?Usage: $SCRIPT_NAME check <url>}"
  info "Checking: ${url}"

  local code
  code=$(check_url "$url")
  local label
  label=$(status_label "$code")

  echo -e "  ${BOLD}URL:${NC}    ${url}"
  echo -e "  ${BOLD}Status:${NC} ${code} ${label}"

  # Extra info
  if [[ "$code" == "000" ]]; then
    echo -e "  ${RED}Could not connect (DNS failure, timeout, or invalid URL)${NC}"
  elif [[ "$code" =~ ^3 ]]; then
    local redirect_url
    redirect_url=$(curl -sL -o /dev/null -w '%{url_effective}' \
      --max-time "$TIMEOUT" -A "$USER_AGENT" "$url" 2>/dev/null || echo "(unknown)")
    echo -e "  ${BOLD}Redirects to:${NC} ${redirect_url}"
  fi

  if is_dead "$code"; then
    return 1
  fi
  return 0
}

# Extract URLs from text
extract_urls() {
  grep -oEi 'https?://[^ "'"'"'<>]+' "$1" 2>/dev/null | sort -u
}

cmd_scan() {
  local file="${1:?Usage: $SCRIPT_NAME scan <file>}"

  if [[ ! -f "$file" ]]; then
    err "File not found: $file"
    exit 1
  fi

  local urls
  urls=$(extract_urls "$file")
  local total
  total=$(echo "$urls" | grep -c . || echo 0)

  if [[ "$total" -eq 0 ]]; then
    warn "No URLs found in $file"
    exit 0
  fi

  info "Scanning ${total} URLs from ${file}..."
  echo ""

  local alive=0 dead=0 count=0

  while IFS= read -r url; do
    count=$((count + 1))
    local code
    code=$(check_url "$url")
    local label
    label=$(status_label "$code")

    printf "  [%d/%d] %-6s %b  %s\n" "$count" "$total" "$code" "$label" "$url"

    if is_dead "$code"; then
      dead=$((dead + 1))
    else
      alive=$((alive + 1))
    fi
  done <<< "$urls"

  echo ""
  echo -e "${BOLD}Results:${NC}"
  echo -e "  ${GREEN}Alive:${NC} ${alive}"
  echo -e "  ${RED}Dead:${NC}  ${dead}"
  echo -e "  ${BOLD}Total:${NC} ${total}"
}

cmd_site() {
  local url="${1:?Usage: $SCRIPT_NAME site <url> [depth]}"
  local max_depth="${2:-1}"

  info "Crawling ${url} (depth: ${max_depth})..."
  echo ""

  # Fetch page and extract links
  local page_content
  page_content=$(curl -sL --max-time 15 -A "$USER_AGENT" "$url" 2>/dev/null || echo "")

  if [[ -z "$page_content" ]]; then
    err "Could not fetch: $url"
    exit 1
  fi

  # Extract href and src links
  local links
  links=$(echo "$page_content" | grep -oEi '(href|src)="[^"]*"' | \
    sed -E 's/(href|src)="([^"]*)"/\2/' | sort -u)

  # Resolve relative URLs
  local base_domain
  base_domain=$(echo "$url" | grep -oE 'https?://[^/]+')

  local all_urls=()
  while IFS= read -r link; do
    [[ -z "$link" ]] && continue
    # Skip anchors, javascript, mailto
    [[ "$link" =~ ^(#|javascript:|mailto:|tel:|data:) ]] && continue

    if [[ "$link" =~ ^https?:// ]]; then
      all_urls+=("$link")
    elif [[ "$link" =~ ^// ]]; then
      all_urls+=("https:${link}")
    elif [[ "$link" =~ ^/ ]]; then
      all_urls+=("${base_domain}${link}")
    fi
  done <<< "$links"

  # Deduplicate
  local unique_urls
  unique_urls=$(printf '%s\n' "${all_urls[@]}" 2>/dev/null | sort -u)
  local total
  total=$(echo "$unique_urls" | grep -c . || echo 0)

  info "Found ${total} links on page"
  echo ""

  local alive=0 dead=0 count=0

  while IFS= read -r link_url; do
    [[ -z "$link_url" ]] && continue
    count=$((count + 1))
    local code
    code=$(check_url "$link_url")
    local label
    label=$(status_label "$code")

    if is_dead "$code"; then
      dead=$((dead + 1))
      printf "  ${RED}✗${NC} [%d/%d] %-6s %b  %s\n" "$count" "$total" "$code" "$label" "$link_url"
    else
      alive=$((alive + 1))
      printf "  ${GREEN}✓${NC} [%d/%d] %-6s %b  %s\n" "$count" "$total" "$code" "$label" "$link_url"
    fi
  done <<< "$unique_urls"

  echo ""
  echo -e "${BOLD}Crawl Results for ${url}:${NC}"
  echo -e "  ${GREEN}Alive:${NC} ${alive}"
  echo -e "  ${RED}Dead:${NC}  ${dead}"
  echo -e "  ${BOLD}Total:${NC} ${total}"
}

cmd_report() {
  local file="${1:?Usage: $SCRIPT_NAME report <file>}"

  if [[ ! -f "$file" ]]; then
    err "File not found: $file"
    exit 1
  fi

  local urls
  urls=$(extract_urls "$file")
  local total
  total=$(echo "$urls" | grep -c . || echo 0)

  if [[ "$total" -eq 0 ]]; then
    warn "No URLs found in $file"
    exit 0
  fi

  local report_file="deadlink-report-$(date +%Y%m%d-%H%M%S).txt"

  info "Generating report for ${total} URLs..."

  {
    echo "============================================================"
    echo " DeadLink Report — $(date '+%Y-%m-%d %H:%M:%S')"
    echo " Source: ${file}"
    echo " Powered by BytesAgain | bytesagain.com"
    echo "============================================================"
    echo ""

    local alive=0 dead=0 redirects=0

    while IFS= read -r url; do
      local code
      code=$(check_url "$url")

      local status_text
      case "$code" in
        2[0-9][0-9]) status_text="OK"; alive=$((alive + 1)) ;;
        3[0-9][0-9]) status_text="REDIRECT"; redirects=$((redirects + 1)); alive=$((alive + 1)) ;;
        4[0-9][0-9]) status_text="CLIENT_ERROR"; dead=$((dead + 1)) ;;
        5[0-9][0-9]) status_text="SERVER_ERROR"; dead=$((dead + 1)) ;;
        000)         status_text="UNREACHABLE"; dead=$((dead + 1)) ;;
        *)           status_text="UNKNOWN"; dead=$((dead + 1)) ;;
      esac

      printf "%-12s %-6s %s\n" "$status_text" "$code" "$url"
      # Progress to stderr
      printf "\r  Checked: %d/%d" "$((alive + dead))" "$total" >&2
    done <<< "$urls"

    echo "" >&2
    echo ""
    echo "============================================================"
    echo " Summary"
    echo "============================================================"
    echo " Total URLs:  ${total}"
    echo " Alive:       ${alive} (including ${redirects} redirects)"
    echo " Dead:        ${dead}"
    echo "============================================================"
  } > "$report_file"

  ok "Report saved to: ${report_file}"
  echo ""
  tail -8 "$report_file"
}

# Main dispatch
require_curl

case "${1:-}" in
  check)  shift; cmd_check "$@" ;;
  scan)   shift; cmd_scan "$@" ;;
  site)   shift; cmd_site "$@" ;;
  report) shift; cmd_report "$@" ;;
  -h|--help|"") usage ;;
  *)
    err "Unknown command: $1"
    usage
    exit 1
    ;;
esac
