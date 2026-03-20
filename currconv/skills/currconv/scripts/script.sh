#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# currconv — Currency Converter
# Convert currencies, check rates, and look up historical exchange rates
# using the free frankfurter.app API.
#
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
###############################################################################

VERSION="3.0.0"
SCRIPT_NAME="currconv"
API_BASE="https://api.frankfurter.app"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

print_banner() {
  echo "═══════════════════════════════════════════════════════"
  echo "  ${SCRIPT_NAME} v${VERSION} — Currency Converter"
  echo "  Powered by BytesAgain | bytesagain.com"
  echo "═══════════════════════════════════════════════════════"
}

usage() {
  print_banner
  echo ""
  echo "Usage: ${SCRIPT_NAME} <command> [arguments]"
  echo ""
  echo "Commands:"
  echo "  convert <amount> <from> <to>   Convert currency (e.g., convert 100 USD EUR)"
  echo "  rates <base>                   Show exchange rates for a base currency"
  echo "  list                           List all available currencies"
  echo "  history <from> <to> <date>     Get historical rate (date: YYYY-MM-DD)"
  echo "  version                        Show version"
  echo "  help                           Show this help message"
  echo ""
  echo "Currency codes: 3-letter ISO 4217 (USD, EUR, GBP, JPY, CNY, etc.)"
  echo "Data source: frankfurter.app (European Central Bank rates, free, no API key)"
  echo ""
  echo "Examples:"
  echo "  ${SCRIPT_NAME} convert 100 USD EUR"
  echo "  ${SCRIPT_NAME} convert 5000 JPY GBP"
  echo "  ${SCRIPT_NAME} rates USD"
  echo "  ${SCRIPT_NAME} list"
  echo "  ${SCRIPT_NAME} history USD EUR 2024-01-15"
  echo ""
  echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

check_curl() {
  command -v curl &>/dev/null || die "curl is required but not found. Install it first."
}

# Fetch JSON from API — returns response body, dies on HTTP error
api_get() {
  local url="$1"
  local response http_code body

  # Use a temp file for the body to separate HTTP code
  local tmpfile
  tmpfile="$(mktemp)"
  trap "rm -f '$tmpfile'" RETURN

  http_code="$(curl -s -o "$tmpfile" -w '%{http_code}' --connect-timeout 10 --max-time 30 "$url" 2>/dev/null)" \
    || die "Network error — could not reach ${API_BASE}. Check your internet connection."

  body="$(cat "$tmpfile")"

  if [[ "$http_code" -lt 200 || "$http_code" -ge 300 ]]; then
    local msg
    msg="$(echo "$body" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('message','Unknown error'))" 2>/dev/null || echo "$body")"
    die "API error (HTTP ${http_code}): ${msg}"
  fi

  echo "$body"
}

# Extract a JSON value using python3 (lightweight, no jq dependency)
json_get() {
  local json="$1"
  local key="$2"
  echo "$json" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('${key}',''))" 2>/dev/null
}

# Format number with commas for readability
format_number() {
  local num="$1"
  # Use python3 for locale-independent formatting
  python3 -c "print(f'{float(\"${num}\"):,.2f}')" 2>/dev/null || echo "$num"
}

# Validate currency code format
validate_currency() {
  local code="$1"
  local upper
  upper="$(echo "$code" | tr '[:lower:]' '[:upper:]')"
  if ! [[ "$upper" =~ ^[A-Z]{3}$ ]]; then
    die "Invalid currency code: '${code}'. Must be a 3-letter ISO 4217 code (e.g., USD, EUR, GBP)"
  fi
  echo "$upper"
}

# Validate date format
validate_date() {
  local d="$1"
  if ! [[ "$d" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    die "Invalid date format: '${d}'. Use YYYY-MM-DD (e.g., 2024-01-15)"
  fi
  # Verify it's a real date
  date -d "$d" '+%Y-%m-%d' &>/dev/null || die "Invalid date: '${d}'"
}

# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------

cmd_convert() {
  local amount="${1:-}"
  local from_raw="${2:-}"
  local to_raw="${3:-}"

  [[ -z "$amount" || -z "$from_raw" || -z "$to_raw" ]] && \
    die "Usage: ${SCRIPT_NAME} convert <amount> <from> <to>\n  Example: ${SCRIPT_NAME} convert 100 USD EUR"

  # Validate amount is a number
  if ! [[ "$amount" =~ ^[0-9]+\.?[0-9]*$ ]]; then
    die "Invalid amount: '${amount}' — must be a positive number"
  fi

  local from to
  from="$(validate_currency "$from_raw")"
  to="$(validate_currency "$to_raw")"

  check_curl

  echo "  Converting ${amount} ${from} → ${to} ..."
  echo ""

  local url="${API_BASE}/latest?amount=${amount}&from=${from}&to=${to}"
  local response
  response="$(api_get "$url")"

  local rate result_amount base_currency date_str
  rate="$(echo "$response" | python3 -c "
import sys, json
d = json.load(sys.stdin)
rates = d.get('rates', {})
to = '${to}'
if to in rates:
    print(rates[to])
else:
    print('N/A')
" 2>/dev/null)"
  date_str="$(json_get "$response" "date")"

  if [[ "$rate" == "N/A" || -z "$rate" ]]; then
    die "Could not get rate for ${from} → ${to}"
  fi

  # Calculate unit rate
  local unit_rate
  unit_rate="$(echo "$response" | python3 -c "
import sys, json
d = json.load(sys.stdin)
rates = d.get('rates', {})
to = '${to}'
amount = float('${amount}')
if to in rates and amount > 0:
    print(f'{rates[to]/amount:.6f}')
else:
    print('N/A')
" 2>/dev/null)"

  local formatted_amount formatted_result
  formatted_amount="$(format_number "$amount")"
  formatted_result="$(format_number "$rate")"

  echo "┌───────────────────────────────────────────────────┐"
  echo "│  Currency Conversion                              │"
  echo "├───────────────────────────────────────────────────┤"
  printf "│  %-14s %-36s │\n" "${formatted_amount}" "${from}"
  printf "│  %-14s %-36s │\n" "=" ""
  printf "│  %-14s %-36s │\n" "${formatted_result}" "${to}"
  echo "├───────────────────────────────────────────────────┤"
  printf "│  Rate:  1 %-4s = %-10s %-22s │\n" "${from}" "${unit_rate}" "${to}"
  printf "│  Date:  %-42s │\n" "${date_str}"
  printf "│  Source: %-41s │\n" "European Central Bank"
  echo "└───────────────────────────────────────────────────┘"
}

cmd_rates() {
  local base_raw="${1:-EUR}"
  local base
  base="$(validate_currency "$base_raw")"

  check_curl

  echo "  Fetching rates for ${base} ..."
  echo ""

  local url="${API_BASE}/latest?from=${base}"
  local response
  response="$(api_get "$url")"

  local date_str
  date_str="$(json_get "$response" "date")"

  echo "┌───────────────────────────────────────────────────┐"
  printf "│  Exchange Rates — Base: %-26s │\n" "${base}"
  printf "│  Date: %-44s │\n" "${date_str}"
  echo "├──────────┬────────────────────────────────────────┤"
  printf "│ %-8s │ %-38s │\n" "Currency" "Rate"
  echo "├──────────┼────────────────────────────────────────┤"

  echo "$response" | python3 -c "
import sys, json
d = json.load(sys.stdin)
rates = d.get('rates', {})
for code in sorted(rates.keys()):
    rate = rates[code]
    print(f'{code}|{rate}')
" 2>/dev/null | while IFS='|' read -r code rate_val; do
    printf "│ %-8s │ %-38s │\n" "$code" "$rate_val"
  done

  echo "└──────────┴────────────────────────────────────────┘"
  echo ""
  echo "  Source: European Central Bank via frankfurter.app"
}

cmd_list() {
  check_curl

  echo "  Fetching available currencies ..."
  echo ""

  local url="${API_BASE}/currencies"
  local response
  response="$(api_get "$url")"

  local count
  count="$(echo "$response" | python3 -c "import sys,json; print(len(json.load(sys.stdin)))" 2>/dev/null)"

  echo "┌──────────┬────────────────────────────────────────────────┐"
  printf "│ %-8s │ %-46s │\n" "Code" "Currency Name"
  echo "├──────────┼────────────────────────────────────────────────┤"

  echo "$response" | python3 -c "
import sys, json
d = json.load(sys.stdin)
for code in sorted(d.keys()):
    name = d[code]
    print(f'{code}|{name}')
" 2>/dev/null | while IFS='|' read -r code name; do
    printf "│ %-8s │ %-46s │\n" "$code" "$name"
  done

  echo "└──────────┴────────────────────────────────────────────────┘"
  echo ""
  echo "  ${count} currencies available"
  echo "  Source: European Central Bank via frankfurter.app"
}

cmd_history() {
  local from_raw="${1:-}"
  local to_raw="${2:-}"
  local date_str="${3:-}"

  [[ -z "$from_raw" || -z "$to_raw" || -z "$date_str" ]] && \
    die "Usage: ${SCRIPT_NAME} history <from> <to> <date>\n  Example: ${SCRIPT_NAME} history USD EUR 2024-01-15"

  local from to
  from="$(validate_currency "$from_raw")"
  to="$(validate_currency "$to_raw")"
  validate_date "$date_str"

  check_curl

  echo "  Fetching historical rate for ${date_str} ..."
  echo ""

  local url="${API_BASE}/${date_str}?from=${from}&to=${to}"
  local response
  response="$(api_get "$url")"

  local actual_date rate_val
  actual_date="$(json_get "$response" "date")"
  rate_val="$(echo "$response" | python3 -c "
import sys, json
d = json.load(sys.stdin)
rates = d.get('rates', {})
to = '${to}'
if to in rates:
    print(rates[to])
else:
    print('N/A')
" 2>/dev/null)"

  # Also get today's rate for comparison
  local today_url="${API_BASE}/latest?from=${from}&to=${to}"
  local today_response today_rate today_date
  today_response="$(api_get "$today_url")" || true
  today_rate="$(echo "$today_response" | python3 -c "
import sys, json
d = json.load(sys.stdin)
rates = d.get('rates', {})
to = '${to}'
if to in rates:
    print(rates[to])
else:
    print('N/A')
" 2>/dev/null || echo "N/A")"
  today_date="$(json_get "$today_response" "date" || echo "N/A")"

  local change_str="N/A"
  if [[ "$rate_val" != "N/A" && "$today_rate" != "N/A" ]]; then
    change_str="$(python3 -c "
h = float('${rate_val}')
t = float('${today_rate}')
diff = t - h
pct = (diff / h) * 100
sign = '+' if diff >= 0 else ''
print(f'{sign}{diff:.6f} ({sign}{pct:.2f}%)')
" 2>/dev/null || echo "N/A")"
  fi

  echo "┌───────────────────────────────────────────────────┐"
  echo "│  Historical Exchange Rate                         │"
  echo "├───────────────────────────────────────────────────┤"
  printf "│  Pair:       %-36s │\n" "${from} → ${to}"
  printf "│  Date:       %-36s │\n" "${actual_date}"
  printf "│  Rate:       1 %-4s = %-28s │\n" "${from}" "${rate_val} ${to}"
  echo "├───────────────────────────────────────────────────┤"
  printf "│  Today:      1 %-4s = %-28s │\n" "${from}" "${today_rate} ${to}"
  printf "│  Change:     %-36s │\n" "${change_str}"
  printf "│  Today date: %-36s │\n" "${today_date}"
  echo "├───────────────────────────────────────────────────┤"
  printf "│  Source: %-41s │\n" "European Central Bank"
  echo "└───────────────────────────────────────────────────┘"
}

# ---------------------------------------------------------------------------
# Main dispatch
# ---------------------------------------------------------------------------

main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    convert)  cmd_convert "$@" ;;
    rates)    cmd_rates "$@" ;;
    list)     cmd_list "$@" ;;
    history)  cmd_history "$@" ;;
    version)  echo "${SCRIPT_NAME} v${VERSION}" ;;
    help|--help|-h) usage ;;
    *)        die "Unknown command: '${cmd}'. Run '${SCRIPT_NAME} help' for usage." ;;
  esac
}

main "$@"
