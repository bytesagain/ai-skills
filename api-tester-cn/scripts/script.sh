#!/usr/bin/env bash
# api-tester-cn — API testing and debugging toolkit
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="3.0.2"
DATA_DIR="${API_TESTER_CN_DIR:-$HOME/.api-tester-cn}"

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; DIM='\033[2m'; BOLD='\033[1m'; RESET='\033[0m'

mkdir -p "$DATA_DIR"/{requests,responses,templates,reports}

die() { echo -e "${RED}Error: $1${RESET}" >&2; exit 1; }
info() { echo -e "${GREEN}✓${RESET} $1"; }
warn() { echo -e "${YELLOW}⚠${RESET} $1"; }

# === check: test API endpoint status ===
cmd_check() {
    local url="${1:-}"
    [ -z "$url" ] && die "Usage: api-tester-cn check <url>"

    echo -e "${BOLD}Checking: $url${RESET}"
    echo ""

    local http_code response_time
    http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" 2>/dev/null) || http_code="000"
    response_time=$(curl -s -o /dev/null -w "%{time_total}" --max-time 10 "$url" 2>/dev/null) || response_time="timeout"

    case "$http_code" in
        2??) echo -e "  Status:  ${GREEN}$http_code OK${RESET}" ;;
        3??) echo -e "  Status:  ${YELLOW}$http_code Redirect${RESET}" ;;
        4??) echo -e "  Status:  ${RED}$http_code Client Error${RESET}" ;;
        5??) echo -e "  Status:  ${RED}$http_code Server Error${RESET}" ;;
        000) echo -e "  Status:  ${RED}Connection failed${RESET}" ;;
        *)   echo -e "  Status:  ${YELLOW}$http_code${RESET}" ;;
    esac

    echo "  Time:    ${response_time}s"

    # Check headers
    local headers
    headers=$(curl -sI --max-time 10 "$url" 2>/dev/null || echo "")
    if [ -n "$headers" ]; then
        local ct
        ct=$(echo "$headers" | grep -i "content-type" | head -1 | sed 's/.*: //' | tr -d '\r')
        [ -n "$ct" ] && echo "  Type:    $ct"
        local server
        server=$(echo "$headers" | grep -i "^server:" | head -1 | sed 's/.*: //' | tr -d '\r')
        [ -n "$server" ] && echo "  Server:  $server"
    fi

    # Log
    local ts
    ts=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$ts|check|$url|$http_code|${response_time}s" >> "$DATA_DIR/history.log"
    echo ""
    info "Result logged to history"
}

# === validate: validate JSON response ===
cmd_validate() {
    local url="${1:-}"
    [ -z "$url" ] && die "Usage: api-tester-cn validate <url>"

    echo -e "${BOLD}Validating JSON response: $url${RESET}"
    echo ""

    local body
    body=$(curl -s --max-time 15 "$url" 2>/dev/null) || die "Failed to fetch $url"

    # Check if valid JSON
    if echo "$body" | python3 -c "import json,sys; json.load(sys.stdin)" 2>/dev/null; then
        info "Valid JSON response"
        local size=${#body}
        echo "  Size:    $size bytes"
        # Count keys
        local keys
        keys=$(echo "$body" | python3 << 'PYEOF'
import json, sys
try:
    d = json.load(sys.stdin)
    if isinstance(d, dict):
        print("  Keys:    {}".format(len(d)))
        for k in list(d.keys())[:10]:
            t = type(d[k]).__name__
            print("    {} ({})".format(k, t))
    elif isinstance(d, list):
        print("  Items:   {}".format(len(d)))
        if d and isinstance(d[0], dict):
            print("  Schema:  {}".format(", ".join(list(d[0].keys())[:8])))
except:
    pass
PYEOF
)
        echo "$keys"
    else
        warn "Not valid JSON"
        echo "  First 200 chars:"
        echo "  ${body:0:200}"
    fi

    local ts
    ts=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$ts|validate|$url" >> "$DATA_DIR/history.log"
}

# === format: pretty-print JSON ===
cmd_format() {
    local input="${1:-}"
    if [ -z "$input" ]; then
        # Read from stdin
        python3 -m json.tool 2>/dev/null || die "Invalid JSON input"
    elif [ -f "$input" ]; then
        python3 -m json.tool "$input" 2>/dev/null || die "Invalid JSON in $input"
    else
        echo "$input" | python3 -m json.tool 2>/dev/null || die "Invalid JSON string"
    fi
}

# === lint: check API response for common issues ===
cmd_lint() {
    local url="${1:-}"
    [ -z "$url" ] && die "Usage: api-tester-cn lint <url>"

    echo -e "${BOLD}Linting API: $url${RESET}"
    echo ""

    local issues=0

    # Check HTTPS
    if [[ "$url" != https://* ]]; then
        warn "Not using HTTPS"
        issues=$((issues + 1))
    else
        info "Using HTTPS"
    fi

    # Check response
    local headers body http_code
    headers=$(curl -sI --max-time 10 "$url" 2>/dev/null || echo "")
    http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" 2>/dev/null || echo "000")

    # CORS
    if echo "$headers" | grep -qi "access-control-allow"; then
        info "CORS headers present"
    else
        warn "No CORS headers"
        issues=$((issues + 1))
    fi

    # Content-Type
    if echo "$headers" | grep -qi "content-type.*json"; then
        info "Returns JSON content-type"
    else
        warn "Content-Type is not JSON"
        issues=$((issues + 1))
    fi

    # Rate limit headers
    if echo "$headers" | grep -qi "x-ratelimit\|rate-limit"; then
        info "Rate limit headers present"
    else
        warn "No rate limit headers"
        issues=$((issues + 1))
    fi

    # Cache headers
    if echo "$headers" | grep -qi "cache-control\|etag"; then
        info "Cache headers present"
    else
        warn "No cache headers"
        issues=$((issues + 1))
    fi

    echo ""
    if [ "$issues" -eq 0 ]; then
        info "No issues found"
    else
        echo -e "  ${YELLOW}$issues issue(s) found${RESET}"
    fi

    local ts
    ts=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$ts|lint|$url|issues=$issues" >> "$DATA_DIR/history.log"
}

# === convert: convert between JSON and other formats ===
cmd_convert() {
    local from_fmt="${1:-}"
    local input="${2:-}"
    [ -z "$from_fmt" ] && die "Usage: api-tester-cn convert <json2csv|csv2json> <file>"
    [ -z "$input" ] && die "Usage: api-tester-cn convert <json2csv|csv2json> <file>"
    [ ! -f "$input" ] && die "File not found: $input"

    case "$from_fmt" in
        json2csv)
            python3 << PYEOF
import json, csv, sys
with open("$input") as f:
    data = json.load(f)
if isinstance(data, list) and data:
    w = csv.DictWriter(sys.stdout, fieldnames=data[0].keys())
    w.writeheader()
    for row in data:
        w.writerow(row)
elif isinstance(data, dict):
    w = csv.DictWriter(sys.stdout, fieldnames=data.keys())
    w.writeheader()
    w.writerow(data)
PYEOF
            ;;
        csv2json)
            python3 << PYEOF
import csv, json, sys
with open("$input") as f:
    reader = csv.DictReader(f)
    print(json.dumps(list(reader), indent=2))
PYEOF
            ;;
        *) die "Unknown format: $from_fmt (use json2csv or csv2json)" ;;
    esac
}

# === template: manage request templates ===
cmd_template() {
    local action="${1:-list}"
    case "$action" in
        list)
            echo -e "${BOLD}Request templates:${RESET}"
            if [ -d "$DATA_DIR/templates" ] && [ "$(ls -A "$DATA_DIR/templates" 2>/dev/null)" ]; then
                for f in "$DATA_DIR/templates"/*.json; do
                    local name
                    name=$(basename "$f" .json)
                    local method url_t
                    method=$(python3 -c "import json; d=json.load(open('$f')); print(d.get('method','GET'))" 2>/dev/null || echo "?")
                    url_t=$(python3 -c "import json; d=json.load(open('$f')); print(d.get('url','?'))" 2>/dev/null || echo "?")
                    echo "  $name: $method $url_t"
                done
            else
                echo "  No templates yet."
                echo "  Create: api-tester-cn template save <name> <method> <url>"
            fi
            ;;
        save)
            local name="${2:-}" method="${3:-GET}" url_t="${4:-}"
            [ -z "$name" ] && die "Usage: template save <name> <method> <url>"
            [ -z "$url_t" ] && die "Usage: template save <name> <method> <url>"
            python3 << PYEOF
import json
d = {"name": "$name", "method": "$method", "url": "$url_t"}
with open("$DATA_DIR/templates/$name.json", "w") as f:
    json.dump(d, f, indent=2)
PYEOF
            info "Template '$name' saved"
            ;;
        run)
            local name="${2:-}"
            [ -z "$name" ] && die "Usage: template run <name>"
            local tfile="$DATA_DIR/templates/$name.json"
            [ ! -f "$tfile" ] && die "Template not found: $name"
            local method url_t
            method=$(python3 -c "import json; print(json.load(open('$tfile')).get('method','GET'))" 2>/dev/null)
            url_t=$(python3 -c "import json; print(json.load(open('$tfile')).get('url',''))" 2>/dev/null)
            echo -e "${BOLD}Running template: $name${RESET}"
            echo "  $method $url_t"
            curl -s -X "$method" --max-time 15 "$url_t" 2>/dev/null | python3 -m json.tool 2>/dev/null || echo "(non-JSON response)"
            ;;
        *) die "Unknown template action: $action (use list, save, run)" ;;
    esac
}

# === diff: compare two API responses ===
cmd_diff() {
    local url1="${1:-}" url2="${2:-}"
    [ -z "$url1" ] || [ -z "$url2" ] && die "Usage: api-tester-cn diff <url1> <url2>"

    echo -e "${BOLD}Comparing API responses${RESET}"
    echo "  URL 1: $url1"
    echo "  URL 2: $url2"
    echo ""

    local tmp1 tmp2
    tmp1=$(mktemp)
    tmp2=$(mktemp)

    curl -s --max-time 15 "$url1" | python3 -m json.tool > "$tmp1" 2>/dev/null || echo "(non-JSON)" > "$tmp1"
    curl -s --max-time 15 "$url2" | python3 -m json.tool > "$tmp2" 2>/dev/null || echo "(non-JSON)" > "$tmp2"

    if diff -u "$tmp1" "$tmp2" > /dev/null 2>&1; then
        info "Responses are identical"
    else
        warn "Responses differ:"
        diff -u --label "URL1" --label "URL2" "$tmp1" "$tmp2" | head -40
    fi

    rm -f "$tmp1" "$tmp2"
}

# === report: generate test report ===
cmd_report() {
    echo -e "${BOLD}API Test Report${RESET}"
    echo "  Generated: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""

    if [ -f "$DATA_DIR/history.log" ]; then
        local total
        total=$(wc -l < "$DATA_DIR/history.log")
        echo "  Total tests: $total"

        local checks validates lints
        checks=$(grep -c "|check|" "$DATA_DIR/history.log" 2>/dev/null || echo 0)
        validates=$(grep -c "|validate|" "$DATA_DIR/history.log" 2>/dev/null || echo 0)
        lints=$(grep -c "|lint|" "$DATA_DIR/history.log" 2>/dev/null || echo 0)

        echo "  Checks:     $checks"
        echo "  Validates:  $validates"
        echo "  Lints:      $lints"
        echo ""
        echo -e "${DIM}Recent:${RESET}"
        tail -10 "$DATA_DIR/history.log" | while IFS='|' read -r ts cmd url rest; do
            echo "  $ts  $cmd  $url"
        done
    else
        echo "  No test history yet."
    fi
}

# === stats ===
cmd_stats() {
    echo -e "${BOLD}Statistics${RESET}"
    if [ -f "$DATA_DIR/history.log" ]; then
        echo "  Total requests: $(wc -l < "$DATA_DIR/history.log")"
        echo "  Templates:      $(ls "$DATA_DIR/templates"/*.json 2>/dev/null | wc -l)"
        echo "  First test:     $(head -1 "$DATA_DIR/history.log" | cut -d'|' -f1)"
        echo "  Last test:      $(tail -1 "$DATA_DIR/history.log" | cut -d'|' -f1)"
    else
        echo "  No data yet."
    fi
}

# === export ===
cmd_export() {
    local fmt="${1:-json}"
    [ ! -f "$DATA_DIR/history.log" ] && die "No history to export"

    case "$fmt" in
        json)
            echo "["
            local first=true
            while IFS='|' read -r ts cmd url rest; do
                [ "$first" = true ] && first=false || echo ","
                printf '  {"timestamp":"%s","command":"%s","url":"%s"}' "$ts" "$cmd" "$url"
            done < "$DATA_DIR/history.log"
            echo ""
            echo "]"
            ;;
        csv)
            echo "timestamp,command,url"
            while IFS='|' read -r ts cmd url rest; do
                echo "$ts,$cmd,$url"
            done < "$DATA_DIR/history.log"
            ;;
        txt)
            cat "$DATA_DIR/history.log"
            ;;
        *) die "Unknown format: $fmt (use json, csv, txt)" ;;
    esac
}

# === status ===
cmd_status() {
    echo -e "${BOLD}api-tester-cn Status${RESET}"
    echo "  Version:     $VERSION"
    echo "  Data dir:    $DATA_DIR"
    echo "  History:     $(wc -l < "$DATA_DIR/history.log" 2>/dev/null || echo 0) entries"
    echo "  Templates:   $(ls "$DATA_DIR/templates"/*.json 2>/dev/null | wc -l) saved"
    echo "  Disk usage:  $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
}

# === recent ===
cmd_recent() {
    local n="${1:-10}"
    if [ -f "$DATA_DIR/history.log" ]; then
        echo -e "${BOLD}Recent $n tests:${RESET}"
        tail -"$n" "$DATA_DIR/history.log" | while IFS='|' read -r ts cmd url rest; do
            echo "  $ts  $cmd  $url"
        done
    else
        echo "  No history yet."
    fi
}

# === search ===
cmd_search() {
    local query="${1:-}"
    [ -z "$query" ] && die "Usage: api-tester-cn search <query>"
    if [ -f "$DATA_DIR/history.log" ]; then
        echo -e "${BOLD}Search results for '$query':${RESET}"
        grep -i "$query" "$DATA_DIR/history.log" | while IFS='|' read -r ts cmd url rest; do
            echo "  $ts  $cmd  $url"
        done
    else
        echo "  No history."
    fi
}

show_help() {
    cat << EOF
api-tester-cn v$VERSION — API testing and debugging toolkit

Usage: api-tester-cn <command> [args]

Testing:
  check <url>                Check API endpoint status code and response time
  validate <url>             Fetch and validate JSON response structure
  lint <url>                 Check API for best practices (HTTPS, CORS, headers)
  diff <url1> <url2>         Compare responses from two endpoints

Data:
  format [file|-]            Pretty-print JSON (file or stdin)
  convert <fmt> <file>       Convert between formats (json2csv, csv2json)

Templates:
  template list              List saved request templates
  template save <n> <m> <u>  Save a template (name, method, url)
  template run <name>        Execute a saved template

Reports:
  report                     Generate test summary report
  recent [n]                 Show recent test history
  search <query>             Search test history
  stats                      Usage statistics
  export <fmt>               Export history (json, csv, txt)
  status                     Show tool status

  help                       Show this help
  version                    Show version

Data dir: $DATA_DIR
EOF
}

show_version() {
    echo "api-tester-cn v$VERSION"
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

# === Main dispatch ===
[ $# -eq 0 ] && { show_help; exit 0; }

case "$1" in
    check)      shift; cmd_check "$@" ;;
    validate)   shift; cmd_validate "$@" ;;
    format)     shift; cmd_format "$@" ;;
    lint)       shift; cmd_lint "$@" ;;
    convert)    shift; cmd_convert "$@" ;;
    template)   shift; cmd_template "$@" ;;
    diff)       shift; cmd_diff "$@" ;;
    report)     cmd_report ;;
    recent)     shift; cmd_recent "$@" ;;
    search)     shift; cmd_search "$@" ;;
    stats)      cmd_stats ;;
    export)     shift; cmd_export "$@" ;;
    status)     cmd_status ;;
    help|-h)    show_help ;;
    version|-v) show_version ;;
    *)          echo "Unknown command: $1"; show_help; exit 1 ;;
esac
