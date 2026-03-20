#!/usr/bin/env bash
set -euo pipefail
###############################################################################
# MockData — Mock Data Generator
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
###############################################################################

VERSION="3.0.0"
SCRIPT_NAME="mockdata"

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

err()  { echo -e "${RED}[ERROR]${NC} $*" >&2; }
info() { echo -e "${CYAN}[INFO]${NC} $*"; }

usage() {
  cat <<EOF
${BOLD}MockData v${VERSION}${NC} — Mock Data Generator
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

${BOLD}Usage:${NC}
  $SCRIPT_NAME name [count]              Random full names
  $SCRIPT_NAME email [count]             Random email addresses
  $SCRIPT_NAME phone [count]             Random phone numbers
  $SCRIPT_NAME address [count]           Random addresses
  $SCRIPT_NAME uuid [count]              Random UUIDs (v4)
  $SCRIPT_NAME csv <rows> <cols>         Generate CSV with random data
  $SCRIPT_NAME json [count]              Generate JSON records

${BOLD}Examples:${NC}
  $SCRIPT_NAME name 5
  $SCRIPT_NAME email 10
  $SCRIPT_NAME uuid 3
  $SCRIPT_NAME csv 100 5
  $SCRIPT_NAME json 5
EOF
}

# --- Data Arrays ---

FIRST_NAMES=(
  James Mary Robert Patricia John Jennifer Michael Linda David Elizabeth
  William Barbara Richard Susan Joseph Jessica Thomas Sarah Charles Karen
  Christopher Nancy Daniel Lisa Matthew Betty Mark Sandra Donald Ashley
  Steven Emily Andrew Kimberly Paul Donna Joshua Michelle Kenneth Carol
  Kevin Amanda Brian Dorothy George Melissa Edward Deborah Ronald Stephanie
  Timothy Rebecca Jason Sharon Jeffrey Laura Ryan Cynthia Jacob Kathleen
  Gary Amy Nicholas Shirley Eric Angela Jonathan Anna Stephen Brenda
  Larry Pamela Justin Emma Scott Virginia Frank Catherine Brandon Kelly
  Raymond Debra Gregory Rachel Samuel Janet Benjamin Marie Jack Virginia
  Dennis Theresa Jerry Denise Alexander Beverly Tyler Jean Gerald Cheryl
  Aaron Megan Jose Natalie Henry Meghan Douglas Hannah Peter Brittany
  Adam Samantha Nathan Jane Zachary Victoria Louis Gloria Russell Martha
  Randy Janice Eugene Frances Harry Evelyn Carl Jean Wayne Teresa
)

LAST_NAMES=(
  Smith Johnson Williams Brown Jones Garcia Miller Davis Rodriguez Martinez
  Hernandez Lopez Gonzalez Wilson Anderson Thomas Taylor Moore Jackson Martin
  Lee Perez Thompson White Harris Sanchez Clark Ramirez Lewis Robinson
  Walker Young Allen King Wright Scott Torres Nguyen Hill Flores Green
  Adams Nelson Baker Hall Rivera Campbell Mitchell Carter Roberts Gomez
  Phillips Evans Turner Diaz Parker Cruz Edwards Collins Reyes Stewart
  Morris Morales Murphy Cook Rogers Gutierrez Ortiz Morgan Cooper Peterson
  Bailey Reed Kelly Howard Ramos Kim Cox Ward Richardson Watson Brooks
  Chavez Wood James Bennett Gray Mendoza Ruiz Hughes Price Alvarez
  Castillo Sanders Patel Myers Long Ross Foster Jimenez Powell Jenkins
)

DOMAINS=( "gmail.com" "yahoo.com" "outlook.com" "hotmail.com" "proton.me"
  "example.com" "testmail.org" "mockmail.io" "devbox.net" "fastmail.com" )

STREETS=( "Main St" "Oak Ave" "Maple Dr" "Cedar Ln" "Pine Rd"
  "Elm St" "Washington Blvd" "Park Ave" "Lake Dr" "River Rd"
  "Broadway" "Market St" "Church St" "Highland Ave" "Sunset Blvd"
  "Franklin St" "Spring St" "Lincoln Ave" "Valley Rd" "Hill St" )

CITIES=( "New York" "Los Angeles" "Chicago" "Houston" "Phoenix"
  "Philadelphia" "San Antonio" "San Diego" "Dallas" "Austin"
  "Jacksonville" "San Jose" "Columbus" "Charlotte" "Indianapolis"
  "Seattle" "Denver" "Boston" "Portland" "Nashville" )

STATES=( "NY" "CA" "IL" "TX" "AZ" "PA" "FL" "OH" "NC" "IN"
  "WA" "CO" "MA" "OR" "TN" "GA" "MI" "VA" "NJ" "MN" )

# --- Helper Functions ---

rand_int() {
  local max="$1"
  echo $(( RANDOM % max ))
}

pick_random() {
  local -n arr=$1
  echo "${arr[$(rand_int ${#arr[@]})]}"
}

random_first() { pick_random FIRST_NAMES; }
random_last()  { pick_random LAST_NAMES; }

random_name() {
  echo "$(random_first) $(random_last)"
}

random_email() {
  local first last domain
  first=$(random_first | tr '[:upper:]' '[:lower:]')
  last=$(random_last | tr '[:upper:]' '[:lower:]')
  domain=$(pick_random DOMAINS)
  local sep
  case $(( RANDOM % 3 )) in
    0) echo "${first}.${last}@${domain}" ;;
    1) echo "${first}${last}$(( RANDOM % 100 ))@${domain}" ;;
    2) echo "${first:0:1}${last}@${domain}" ;;
  esac
}

random_phone() {
  printf "+1-%03d-%03d-%04d\n" $(( RANDOM % 900 + 100 )) $(( RANDOM % 900 + 100 )) $(( RANDOM % 10000 ))
}

random_address() {
  local num street city state zip
  num=$(( RANDOM % 9900 + 100 ))
  street=$(pick_random STREETS)
  city=$(pick_random CITIES)
  state=$(pick_random STATES)
  zip=$(printf "%05d" $(( RANDOM % 99999 )))
  echo "${num} ${street}, ${city}, ${state} ${zip}"
}

random_uuid() {
  # Generate UUID v4 format
  local hex
  hex=$(od -An -tx1 -N16 /dev/urandom 2>/dev/null | tr -d ' \n' || \
    printf '%04x%04x%04x%04x%04x%04x%04x%04x' \
      $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM)

  # Set version (4) and variant (8,9,a,b)
  printf '%s-%s-4%s-%x%s-%s\n' \
    "${hex:0:8}" \
    "${hex:8:4}" \
    "${hex:13:3}" \
    $(( (0x${hex:16:1} & 0x3) | 0x8 )) \
    "${hex:17:3}" \
    "${hex:20:12}"
}

random_word() {
  local words=( "alpha" "beta" "gamma" "delta" "epsilon" "zeta" "theta"
    "lambda" "sigma" "omega" "phoenix" "atlas" "nexus" "vertex" "prism"
    "matrix" "nova" "pulse" "quantum" "vortex" "zenith" "apex" )
  pick_random words
}

# --- Command Functions ---

cmd_name() {
  local count="${1:-1}"
  local i
  for (( i = 0; i < count; i++ )); do
    random_name
  done
}

cmd_email() {
  local count="${1:-1}"
  local i
  for (( i = 0; i < count; i++ )); do
    random_email
  done
}

cmd_phone() {
  local count="${1:-1}"
  local i
  for (( i = 0; i < count; i++ )); do
    random_phone
  done
}

cmd_address() {
  local count="${1:-1}"
  local i
  for (( i = 0; i < count; i++ )); do
    random_address
  done
}

cmd_uuid() {
  local count="${1:-1}"
  local i
  for (( i = 0; i < count; i++ )); do
    random_uuid
  done
}

cmd_csv() {
  local rows="${1:?Usage: $SCRIPT_NAME csv <rows> <cols>}"
  local cols="${2:?Usage: $SCRIPT_NAME csv <rows> <cols>}"

  # Header
  local headers=()
  local col_types=()
  for (( c = 0; c < cols; c++ )); do
    case $(( c % 6 )) in
      0) headers+=("id"); col_types+=("id") ;;
      1) headers+=("name"); col_types+=("name") ;;
      2) headers+=("email"); col_types+=("email") ;;
      3) headers+=("phone"); col_types+=("phone") ;;
      4) headers+=("city"); col_types+=("city") ;;
      5) headers+=("score"); col_types+=("score") ;;
    esac
  done

  # Print header
  local IFS=','
  echo "${headers[*]}"

  # Print rows
  local r
  for (( r = 1; r <= rows; r++ )); do
    local row=()
    for (( c = 0; c < cols; c++ )); do
      case "${col_types[$c]}" in
        id)    row+=("$r") ;;
        name)  row+=("$(random_name)") ;;
        email) row+=("$(random_email)") ;;
        phone) row+=("$(random_phone)") ;;
        city)  row+=("$(pick_random CITIES)") ;;
        score) row+=("$(( RANDOM % 100 ))") ;;
      esac
    done
    echo "${row[*]}"
  done
}

cmd_json() {
  local count="${1:-1}"

  echo "["
  local i
  for (( i = 0; i < count; i++ )); do
    local name email phone city age uuid_val
    name=$(random_name)
    email=$(random_email)
    phone=$(random_phone)
    city=$(pick_random CITIES)
    age=$(( RANDOM % 50 + 18 ))
    uuid_val=$(random_uuid)

    local comma=""
    if [[ $i -lt $((count - 1)) ]]; then
      comma=","
    fi

    cat <<JSONEOF
  {
    "id": "${uuid_val}",
    "name": "${name}",
    "email": "${email}",
    "phone": "${phone}",
    "age": ${age},
    "city": "${city}"
  }${comma}
JSONEOF
  done
  echo "]"
}

# --- Main Dispatch ---

case "${1:-}" in
  name)    shift; cmd_name "$@" ;;
  email)   shift; cmd_email "$@" ;;
  phone)   shift; cmd_phone "$@" ;;
  address) shift; cmd_address "$@" ;;
  uuid)    shift; cmd_uuid "$@" ;;
  csv)     shift; cmd_csv "$@" ;;
  json)    shift; cmd_json "$@" ;;
  -h|--help|"") usage ;;
  *)
    err "Unknown command: $1"
    usage
    exit 1
    ;;
esac
