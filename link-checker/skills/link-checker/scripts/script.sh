#!/usr/bin/env bash
# ============================================================
# Link Checker — check URLs for HTTP status, find broken links
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
# ============================================================
set -euo pipefail

VERSION="2.1.0"
DATA_DIR="${HOME}/.link-checker"
RESULTS_FILE="$DATA_DIR/results.log"
HISTORY_FILE="$DATA_DIR/history.log"
CONFIG_FILE="$DATA_DIR/config"

# Defaults
DEFAULT_TIMEOUT=10
DEFAULT_RETRIES=2
DEFAULT_USER_AGENT="LinkChecker/${VERSION}"

# ------------------------------------------------------------
# Init & Config helpers
# ------------------------------------------------------------
_init() {
    mkdir -p "$DATA_DIR"
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "timeout=${DEFAULT_TIMEOUT}" > "$CONFIG_FILE"
        echo "retries=${DEFAULT_RETRIES}" >> "$CONFIG_FILE"
        echo "user_agent=${DEFAULT_USER_AGENT}" >> "$CONFIG_FILE"
    fi
}

_get_config() {
    local key="$1"
    local fallback="${2:-}"
    if [ -f "$CONFIG_FILE" ]; then
        local val
        val=$(grep "^${key}=" "$CONFIG_FILE" 2>/dev/null | head -1 | cut -d'=' -f2-)
        if [ -n "$val" ]; then
            echo "$val"
            return
        fi
    fi
    echo "$fallback"
}

_set_config() {
    local key="$1"
    local val="$2"
    if grep -q "^${key}=" "$CONFIG_FILE" 2>/dev/null; then
        sed -i "s|^${key}=.*|${key}=${val}|" "$CONFIG_FILE"
    else
        echo "${key}=${val}" >> "$CONFIG_FILE"
    fi
    echo "  Set ${key} = ${val}"
}

# ------------------------------------------------------------
# Core: check a single URL
# Returns: status_code (or TIMEOUT / ERROR)
# ------------------------------------------------------------
_check_url() {
    local url="$1"
    local timeout
    timeout=$(_get_config "timeout" "$DEFAULT_TIMEOUT")
    local retries
    retries=$(_get_config "retries" "$DEFAULT_RETRIES")
    local ua
    ua=$(_get_config "user_agent" "$DEFAULT_USER_AGENT")

    local attempt=0
    local code=""
    while [ $attempt -le "$retries" ]; do
        code=$(curl -sI -o /dev/null -w "%{http_code}" \
            --connect-timeout "$timeout" \
            --max-time "$((timeout * 2))" \
            -A "$ua" \
            -L "$url" 2>/dev/null) || code="ERROR"

        if [ "$code" = "000" ]; then
            code="TIMEOUT"
        fi

        # If we got a valid response (not timeout/error), stop retrying
        if [ "$code" != "TIMEOUT" ] && [ "$code" != "ERROR" ]; then
            break
        fi
        attempt=$((attempt + 1))
    done

    echo "$code"
}

# Classify status code
_status_label() {
    local code="$1"
    case "$code" in
        2[0-9][0-9]) echo "OK" ;;
        3[0-9][0-9]) echo "REDIRECT" ;;
        4[0-9][0-9]) echo "CLIENT_ERROR" ;;
        5[0-9][0-9]) echo "SERVER_ERROR" ;;
        TIMEOUT)     echo "TIMEOUT" ;;
        *)           echo "ERROR" ;;
    esac
}

_status_icon() {
    local code="$1"
    case "$code" in
        2[0-9][0-9]) echo "✅" ;;
        3[0-9][0-9]) echo "🔄" ;;
        4[0-9][0-9]) echo "❌" ;;
        5[0-9][0-9]) echo "⚠️" ;;
        TIMEOUT)     echo "⏱️" ;;
        *)           echo "🚫" ;;
    esac
}

# Record a result to history
_record() {
    local url="$1"
    local code="$2"
    local label
    label=$(_status_label "$code")
    local ts
    ts=$(date '+%Y-%m-%d %H:%M:%S')
    echo "${ts}|${url}|${code}|${label}" >> "$RESULTS_FILE"
    echo "${ts}|${url}|${code}|${label}" >> "$HISTORY_FILE"
}

# ------------------------------------------------------------
# Commands
# ------------------------------------------------------------

cmd_check() {
    local url="${1:?Usage: link-checker check <url>}"
    echo "Checking: ${url}"
    local code
    code=$(_check_url "$url")
    local icon
    icon=$(_status_icon "$code")
    local label
    label=$(_status_label "$code")
    echo "  ${icon} ${code} — ${label}"
    _record "$url" "$code"
}

cmd_scan() {
    local file="${1:?Usage: link-checker scan <file>}"
    if [ ! -f "$file" ]; then
        echo "Error: file not found: ${file}"
        exit 1
    fi

    echo "Scanning file: ${file}"
    echo "Extracting URLs..."

    # Extract URLs using grep — matches http:// and https://
    local urls
    urls=$(grep -oE 'https?://[^ "'"'"'<>()]+' "$file" | sort -u) || true

    if [ -z "$urls" ]; then
        echo "  No URLs found in ${file}"
        return
    fi

    local count
    count=$(echo "$urls" | wc -l)
    echo "Found ${count} unique URL(s)"
    echo ""

    local ok=0 fail=0
    while IFS= read -r url; do
        local code
        code=$(_check_url "$url")
        local icon
        icon=$(_status_icon "$code")
        echo "  ${icon} ${code}  ${url}"
        _record "$url" "$code"
        case "$code" in
            2[0-9][0-9]|3[0-9][0-9]) ok=$((ok + 1)) ;;
            *) fail=$((fail + 1)) ;;
        esac
    done <<< "$urls"

    echo ""
    echo "Summary: ${ok} OK, ${fail} failed out of ${count} URLs"
}

cmd_batch() {
    if [ $# -eq 0 ]; then
        echo "Usage: link-checker batch <url1> <url2> ..."
        exit 1
    fi

    echo "Batch checking ${#} URL(s)..."
    echo ""

    local ok=0 fail=0 total=0
    for url in "$@"; do
        total=$((total + 1))
        local code
        code=$(_check_url "$url")
        local icon
        icon=$(_status_icon "$code")
        echo "  ${icon} ${code}  ${url}"
        _record "$url" "$code"
        case "$code" in
            2[0-9][0-9]|3[0-9][0-9]) ok=$((ok + 1)) ;;
            *) fail=$((fail + 1)) ;;
        esac
    done

    echo ""
    echo "Summary: ${ok} OK, ${fail} failed out of ${total} URLs"
}

cmd_report() {
    local fmt="${1:-txt}"

    if [ ! -f "$RESULTS_FILE" ]; then
        echo "No results yet. Run 'check', 'scan', or 'batch' first."
        return
    fi

    local outfile="$DATA_DIR/report.${fmt}"

    case "$fmt" in
        txt)
            {
                echo "=== Link Checker Report ==="
                echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
                echo ""
                printf "%-20s  %-6s  %-14s  %s\n" "TIMESTAMP" "CODE" "STATUS" "URL"
                printf "%-20s  %-6s  %-14s  %s\n" "-------------------" "------" "--------------" "---"
                while IFS='|' read -r ts url code label; do
                    printf "%-20s  %-6s  %-14s  %s\n" "$ts" "$code" "$label" "$url"
                done < "$RESULTS_FILE"
            } > "$outfile"
            ;;
        csv)
            {
                echo "timestamp,url,status_code,status"
                while IFS='|' read -r ts url code label; do
                    echo "${ts},${url},${code},${label}"
                done < "$RESULTS_FILE"
            } > "$outfile"
            ;;
        json)
            {
                echo "["
                local first=1
                while IFS='|' read -r ts url code label; do
                    [ $first -eq 1 ] && first=0 || echo ","
                    printf '  {"timestamp":"%s","url":"%s","status_code":"%s","status":"%s"}' \
                        "$ts" "$url" "$code" "$label"
                done < "$RESULTS_FILE"
                echo ""
                echo "]"
            } > "$outfile"
            ;;
        *)
            echo "Unknown format: ${fmt}"
            echo "Supported: txt, csv, json"
            return 1
            ;;
    esac

    local size
    size=$(wc -c < "$outfile")
    echo "Report saved: ${outfile} (${size} bytes)"
}

cmd_history() {
    if [ ! -f "$HISTORY_FILE" ]; then
        echo "No history yet."
        return
    fi

    echo "=== Check History ==="
    echo ""
    local count
    count=$(wc -l < "$HISTORY_FILE")
    echo "Showing last 50 of ${count} entries:"
    echo ""
    printf "%-20s  %-6s  %-14s  %s\n" "TIMESTAMP" "CODE" "STATUS" "URL"
    printf "%-20s  %-6s  %-14s  %s\n" "-------------------" "------" "--------------" "---"
    tail -50 "$HISTORY_FILE" | while IFS='|' read -r ts url code label; do
        printf "%-20s  %-6s  %-14s  %s\n" "$ts" "$code" "$label" "$url"
    done
}

cmd_broken() {
    if [ ! -f "$RESULTS_FILE" ]; then
        echo "No results yet."
        return
    fi

    echo "=== Broken Links ==="
    echo ""
    local found=0
    while IFS='|' read -r ts url code label; do
        case "$code" in
            4[0-9][0-9]|5[0-9][0-9]|TIMEOUT|ERROR)
                local icon
                icon=$(_status_icon "$code")
                echo "  ${icon} ${code}  ${url}  (${ts})"
                found=$((found + 1))
                ;;
        esac
    done < "$RESULTS_FILE"

    if [ $found -eq 0 ]; then
        echo "  No broken links found. All checks passed."
    else
        echo ""
        echo "${found} broken link(s) found."
    fi
}

cmd_stats() {
    if [ ! -f "$HISTORY_FILE" ]; then
        echo "No data yet."
        return
    fi

    local total ok redirect client_err server_err timeout_count error_count
    total=$(wc -l < "$HISTORY_FILE")
    ok=$(grep -c '|OK$' "$HISTORY_FILE" 2>/dev/null || echo 0)
    redirect=$(grep -c '|REDIRECT$' "$HISTORY_FILE" 2>/dev/null || echo 0)
    client_err=$(grep -c '|CLIENT_ERROR$' "$HISTORY_FILE" 2>/dev/null || echo 0)
    server_err=$(grep -c '|SERVER_ERROR$' "$HISTORY_FILE" 2>/dev/null || echo 0)
    timeout_count=$(grep -c '|TIMEOUT$' "$HISTORY_FILE" 2>/dev/null || echo 0)
    error_count=$(grep -c '|ERROR$' "$HISTORY_FILE" 2>/dev/null || echo 0)

    local success_rate=0
    if [ "$total" -gt 0 ]; then
        success_rate=$(( (ok + redirect) * 100 / total ))
    fi

    echo "=== Link Checker Stats ==="
    echo ""
    echo "  Total checks:   ${total}"
    echo "  ✅ OK (2xx):     ${ok}"
    echo "  🔄 Redirect:     ${redirect}"
    echo "  ❌ Client (4xx): ${client_err}"
    echo "  ⚠️  Server (5xx): ${server_err}"
    echo "  ⏱️  Timeout:      ${timeout_count}"
    echo "  🚫 Error:        ${error_count}"
    echo ""
    echo "  Success rate:   ${success_rate}%"
    echo ""

    # Top error codes
    echo "  Common status codes:"
    awk -F'|' '{print $3}' "$HISTORY_FILE" | sort | uniq -c | sort -rn | head -10 | while read -r cnt code; do
        printf "    %-8s  %s occurrences\n" "$code" "$cnt"
    done

    echo ""
    echo "  Data size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    echo "  First check: $(head -1 "$HISTORY_FILE" | cut -d'|' -f1)"
    echo "  Last check:  $(tail -1 "$HISTORY_FILE" | cut -d'|' -f1)"
}

cmd_export() {
    local fmt="${1:?Usage: link-checker export <format> (csv|json|txt)}"

    if [ ! -f "$HISTORY_FILE" ]; then
        echo "No data to export."
        return
    fi

    local outfile="$DATA_DIR/export_$(date '+%Y%m%d_%H%M%S').${fmt}"

    case "$fmt" in
        csv)
            {
                echo "timestamp,url,status_code,status"
                while IFS='|' read -r ts url code label; do
                    echo "${ts},${url},${code},${label}"
                done < "$HISTORY_FILE"
            } > "$outfile"
            ;;
        json)
            {
                echo "["
                local first=1
                while IFS='|' read -r ts url code label; do
                    [ $first -eq 1 ] && first=0 || echo ","
                    printf '  {"timestamp":"%s","url":"%s","status_code":"%s","status":"%s"}' \
                        "$ts" "$url" "$code" "$label"
                done < "$HISTORY_FILE"
                echo ""
                echo "]"
            } > "$outfile"
            ;;
        txt)
            {
                echo "=== Link Checker Export ==="
                echo "Exported: $(date '+%Y-%m-%d %H:%M:%S')"
                echo "Total entries: $(wc -l < "$HISTORY_FILE")"
                echo ""
                printf "%-20s  %-6s  %-14s  %s\n" "TIMESTAMP" "CODE" "STATUS" "URL"
                printf "%-20s  %-6s  %-14s  %s\n" "-------------------" "------" "--------------" "---"
                while IFS='|' read -r ts url code label; do
                    printf "%-20s  %-6s  %-14s  %s\n" "$ts" "$code" "$label" "$url"
                done < "$HISTORY_FILE"
            } > "$outfile"
            ;;
        *)
            echo "Unknown format: ${fmt}"
            echo "Supported: csv, json, txt"
            return 1
            ;;
    esac

    local size
    size=$(wc -c < "$outfile")
    echo "Exported ${fmt} to: ${outfile} (${size} bytes)"
}

cmd_config() {
    if [ $# -eq 0 ]; then
        echo "=== Link Checker Config ==="
        echo ""
        echo "  timeout    = $(_get_config timeout "$DEFAULT_TIMEOUT") seconds"
        echo "  retries    = $(_get_config retries "$DEFAULT_RETRIES")"
        echo "  user_agent = $(_get_config user_agent "$DEFAULT_USER_AGENT")"
        echo ""
        echo "  Config file: ${CONFIG_FILE}"
        echo ""
        echo "  Set a value:  link-checker config set <key> <value>"
        echo "  Keys: timeout, retries, user_agent"
        return
    fi

    local action="$1"
    case "$action" in
        set)
            local key="${2:?Usage: link-checker config set <key> <value>}"
            local val="${3:?Usage: link-checker config set <key> <value>}"
            case "$key" in
                timeout|retries|user_agent)
                    _set_config "$key" "$val"
                    ;;
                *)
                    echo "Unknown config key: ${key}"
                    echo "Valid keys: timeout, retries, user_agent"
                    return 1
                    ;;
            esac
            ;;
        *)
            echo "Usage: link-checker config [set <key> <value>]"
            return 1
            ;;
    esac
}

cmd_help() {
    cat <<EOF
Link Checker v${VERSION} — find broken links, check URL status

Usage: link-checker <command> [arguments]

Commands:
  check <url>            Check a single URL and show its HTTP status
  scan <file>            Extract all URLs from a file and check each one
  batch <url1> <url2>    Check multiple URLs at once
  report [format]        Generate a report from results (txt/csv/json)
  history                Show past check results
  broken                 Show only broken links (4xx/5xx/timeout)
  stats                  Show statistics: total checks, success rate, error codes
  export <format>        Export all history (csv/json/txt)
  config                 View or set configuration (timeout, retries)
  help                   Show this help
  version                Show version

Examples:
  link-checker check https://example.com
  link-checker scan ./README.md
  link-checker batch https://a.com https://b.com https://c.com
  link-checker report json
  link-checker broken
  link-checker config set timeout 15
  link-checker export csv

Data directory: ${DATA_DIR}
EOF
}

cmd_version() {
    echo "link-checker v${VERSION}"
}

# ------------------------------------------------------------
# Init & Dispatch
# ------------------------------------------------------------
_init

case "${1:-help}" in
    check)       shift; cmd_check "$@" ;;
    scan)        shift; cmd_scan "$@" ;;
    batch)       shift; cmd_batch "$@" ;;
    report)      shift; cmd_report "$@" ;;
    history)     cmd_history ;;
    broken)      cmd_broken ;;
    stats)       cmd_stats ;;
    export)      shift; cmd_export "$@" ;;
    config)      shift; cmd_config "$@" ;;
    help|--help|-h)       cmd_help ;;
    version|--version|-v) cmd_version ;;
    *)
        echo "Unknown command: $1"
        echo "Run 'link-checker help' for usage."
        exit 1
        ;;
esac
