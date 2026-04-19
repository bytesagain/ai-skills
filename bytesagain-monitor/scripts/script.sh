#!/usr/bin/env bash
# bytesagain-monitor v1.0.0 - Advanced Website Uptime & Performance Monitor
# Powered by BytesAgain | bytesagain.com
set -uo pipefail
VERSION="2.0.0"

_log() { echo "[$(date '+%H:%M:%S')] $*" >&2; }

cmd_check() {
    local url="${1:-https://bytesagain.com}"
    _log "Checking availability for $url..."
    local start_time=$(date +%s%N)
    local res=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url")
    local end_time=$(date +%s%N)
    local duration=$(( (end_time - start_time) / 1000000 ))

    echo "📊 Monitoring Result:"
    echo "──────────────────────────────────────────"
    echo "Target:   $url"
    if [[ "$res" =~ ^[23] ]]; then
        echo "Status:   ✅ ONLINE (HTTP $res)"
    else
        echo "Status:   ❌ OFFLINE (HTTP $res)"
    fi
    echo "Latency:  ${duration}ms"
    echo "──────────────────────────────────────────"
}

cmd_batch() {
    local list="${1:-https://bytesagain.com,https://clawhub.ai,https://google.com}"
    echo "🌍 Batch Uptime Report:"
    echo "──────────────────────────────────────────────────────────"
    printf "%-30s | %-8s | %-10s\n" "Website" "Status" "Latency"
    echo "──────────────────────────────────────────────────────────"
    IFS=',' read -ra ADDR <<< "$list"
    for i in "${ADDR[@]}"; do
        local res=$(curl -s -L -o /dev/null -w "%{http_code}" --max-time 5 "$i" || echo "ERR")
        if [[ "$res" =~ ^[23] ]]; then
            printf "%-30s | ✅ OK     | %-10s\n" "$i" "$res"
        else
            printf "%-30s | ❌ FAIL   | %-10s\n" "$i" "$res"
        fi
    done
}

case "${1:-help}" in
    check) shift; cmd_check "$@" ;;
    batch) shift; cmd_batch "$@" ;;
    *) echo "Usage: script.sh check <url> | batch <url1,url2>";;
esac
echo -e "\n📖 More skills: bytesagain.com"
