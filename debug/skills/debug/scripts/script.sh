#!/usr/bin/env bash
# debug — error tracing, log analysis, memory leak detection, HTTP debugging
set -euo pipefail
VERSION="3.0.0"

# === trace: find error patterns in log files ===
cmd_trace() {
    local pattern="ERROR\|FATAL\|Exception\|Traceback\|WARN\|OOM\|Segfault\|panic\|SIGKILL\|SIGSEGV"
    local time_filter=""
    local file=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --pattern) pattern="$2"; shift 2 ;;
            --last)
                local duration="$2"
                local unit="${duration: -1}"
                local num="${duration%?}"
                case "$unit" in
                    h) time_filter=$(date -d "$num hours ago" '+%Y-%m-%d %H' 2>/dev/null || date -v-"${num}H" '+%Y-%m-%d %H' 2>/dev/null || echo "") ;;
                    m) time_filter=$(date -d "$num minutes ago" '+%Y-%m-%d %H:%M' 2>/dev/null || echo "") ;;
                    d) time_filter=$(date -d "$num days ago" '+%Y-%m-%d' 2>/dev/null || echo "") ;;
                    *) time_filter="" ;;
                esac
                shift 2 ;;
            *) file="$1"; shift ;;
        esac
    done

    if [[ -z "$file" ]]; then
        echo "Usage: debug trace [--pattern REGEX] [--last 1h|30m|2d] <logfile>" >&2
        return 1
    fi

    if [[ ! -f "$file" ]]; then
        echo "File not found: $file" >&2
        return 1
    fi

    local total_lines
    total_lines=$(wc -l < "$file" 2>/dev/null || echo "0")

    echo "=== Debug Trace: $file ==="
    echo "Total lines: $total_lines"
    echo "Pattern: $pattern"
    echo ""

    # Count matches
    local match_count
    if [[ -n "$time_filter" ]]; then
        match_count=$(grep -c "$time_filter" "$file" 2>/dev/null | grep -c "$pattern" 2>/dev/null || echo "0")
        echo "Time filter: since $time_filter"
    else
        match_count=$(grep -c "$pattern" "$file" 2>/dev/null || echo "0")
    fi
    echo "Matches: $match_count"
    echo ""

    # Show error breakdown
    echo "--- Error Breakdown ---"
    grep -oE "(ERROR|FATAL|Exception|Traceback|WARN|OOM|Segfault|panic|SIGKILL|SIGSEGV)" "$file" 2>/dev/null | sort | uniq -c | sort -rn | head -10
    echo ""

    # Show last 20 matching lines
    echo "--- Last 20 Matches ---"
    if [[ -n "$time_filter" ]]; then
        grep "$time_filter" "$file" 2>/dev/null | grep "$pattern" 2>/dev/null | tail -20
    else
        grep "$pattern" "$file" 2>/dev/null | tail -20
    fi
    echo ""

    # Unique error messages (dedup)
    echo "--- Unique Error Patterns (top 10) ---"
    grep "$pattern" "$file" 2>/dev/null | \
        sed 's/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}[T ][0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}[^ ]*/TIMESTAMP/g' | \
        sed 's/0x[0-9a-fA-F]*/0xADDR/g' | \
        sed 's/pid=[0-9]*/pid=N/g' | \
        sort | uniq -c | sort -rn | head -10

    [[ "$match_count" -gt 0 ]] && return 1 || return 0
}

# === stacktrace: parse and summarize a stack trace ===
cmd_stacktrace() {
    local input="${1:--}"

    if [[ "$input" == "-" ]]; then
        local content
        content=$(cat)
    elif [[ -f "$input" ]]; then
        local content
        content=$(cat "$input")
    else
        echo "Usage: debug stacktrace <file|-> " >&2
        return 1
    fi

    echo "=== Stack Trace Analysis ==="
    echo ""

    # Detect language
    local lang="unknown"
    if echo "$content" | grep -q "Traceback (most recent call last)"; then
        lang="python"
    elif echo "$content" | grep -q "at .*(.*\.java:[0-9]*)"; then
        lang="java"
    elif echo "$content" | grep -q "at .*(.*\.[jt]s:[0-9]*)"; then
        lang="javascript"
    elif echo "$content" | grep -q "goroutine [0-9]*"; then
        lang="go"
    elif echo "$content" | grep -q "thread.*#[0-9]"; then
        lang="c/c++"
    fi
    echo "Language: $lang"

    # Extract error message
    echo ""
    echo "--- Error Message ---"
    case "$lang" in
        python)
            echo "$content" | tail -1
            echo ""
            echo "--- Call Chain (bottom = root cause) ---"
            echo "$content" | grep -E "File \"" | while IFS= read -r line; do
                local file_info
                file_info=$(echo "$line" | grep -oE "File \"[^\"]+\", line [0-9]+")
                local func
                func=$(echo "$line" | grep -oE "in [a-zA-Z_]+")
                echo "  $file_info $func"
            done
            ;;
        java)
            echo "$content" | head -1
            echo ""
            echo "--- Call Chain ---"
            echo "$content" | grep "^\s*at " | head -10 | while IFS= read -r line; do
                echo "  $(echo "$line" | sed 's/^\s*//')"
            done
            ;;
        javascript)
            echo "$content" | head -1
            echo ""
            echo "--- Call Chain ---"
            echo "$content" | grep "^\s*at " | head -10 | while IFS= read -r line; do
                echo "  $(echo "$line" | sed 's/^\s*//')"
            done
            ;;
        go)
            echo "$content" | grep -E "^(panic|fatal|runtime)" | head -1
            echo ""
            echo "--- Goroutine Info ---"
            echo "$content" | grep "goroutine " | head -5
            ;;
        *)
            echo "$content" | head -3
            ;;
    esac

    # Count frames
    local frames
    frames=$(echo "$content" | grep -cE "^\s*(at |File \")" 2>/dev/null || echo "0")
    echo ""
    echo "Stack depth: $frames frames"
}

# === leaks: monitor process memory over time ===
cmd_leaks() {
    local pid=""
    local duration=30
    local interval=5

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --pid) pid="$2"; shift 2 ;;
            --duration) duration="$2"; shift 2 ;;
            --interval) interval="$2"; shift 2 ;;
            *) pid="$1"; shift ;;
        esac
    done

    if [[ -z "$pid" ]]; then
        echo "Usage: debug leaks --pid <PID> [--duration 30] [--interval 5]" >&2
        return 1
    fi

    if ! kill -0 "$pid" 2>/dev/null; then
        echo "Process $pid not found" >&2
        return 1
    fi

    local cmd_name
    cmd_name=$(ps -p "$pid" -o comm= 2>/dev/null || echo "unknown")
    echo "=== Memory Leak Detection ==="
    echo "PID: $pid ($cmd_name)"
    echo "Monitoring: ${duration}s at ${interval}s intervals"
    echo ""

    local samples=()
    local timestamps=()
    local elapsed=0

    echo "Time       RSS(KB)    VSZ(KB)    Delta"
    echo "---------- ---------- ---------- ------"

    local prev_rss=0
    while [[ $elapsed -lt $duration ]]; do
        if ! kill -0 "$pid" 2>/dev/null; then
            echo "Process $pid exited during monitoring" >&2
            break
        fi

        local mem_info
        mem_info=$(ps -p "$pid" -o rss=,vsz= 2>/dev/null || echo "0 0")
        local rss vsz
        rss=$(echo "$mem_info" | awk '{print $1}')
        vsz=$(echo "$mem_info" | awk '{print $2}')

        local delta=""
        if [[ $prev_rss -gt 0 ]]; then
            local diff=$((rss - prev_rss))
            if [[ $diff -gt 0 ]]; then
                delta="+${diff}"
            elif [[ $diff -lt 0 ]]; then
                delta="$diff"
            else
                delta="0"
            fi
        fi
        prev_rss=$rss

        printf "%-10s %-10s %-10s %s\n" "${elapsed}s" "$rss" "$vsz" "$delta"
        samples+=("$rss")

        sleep "$interval"
        elapsed=$((elapsed + interval))
    done

    echo ""
    if [[ ${#samples[@]} -ge 3 ]]; then
        local first=${samples[0]}
        local last=${samples[${#samples[@]}-1]}
        local growth=$((last - first))
        local growth_pct=0
        [[ $first -gt 0 ]] && growth_pct=$((growth * 100 / first))

        echo "--- Summary ---"
        echo "Start RSS: ${first}KB"
        echo "End RSS:   ${last}KB"
        echo "Growth:    ${growth}KB (${growth_pct}%)"

        if [[ $growth_pct -gt 20 ]]; then
            echo "⚠️  POSSIBLE LEAK: Memory grew ${growth_pct}% in ${duration}s"
            return 1
        elif [[ $growth_pct -gt 5 ]]; then
            echo "⚡ WATCH: Memory grew ${growth_pct}%, monitor longer to confirm"
        else
            echo "✅ OK: Memory stable (${growth_pct}% change)"
        fi
    fi
}

# === profile: measure command execution time and resources ===
cmd_profile() {
    local repeat=1
    local cmd=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --repeat) repeat="$2"; shift 2 ;;
            *) cmd="$1"; shift ;;
        esac
    done

    if [[ -z "$cmd" ]]; then
        echo "Usage: debug profile [--repeat N] <command>" >&2
        return 1
    fi

    echo "=== Profiling: $cmd ==="
    echo "Runs: $repeat"
    echo ""

    local total_ms=0
    local min_ms=999999
    local max_ms=0
    local run=1

    while [[ $run -le $repeat ]]; do
        local start_ns end_ns elapsed_ms
        start_ns=$(date +%s%N 2>/dev/null || python3 << 'PYEOF'
import time
print(int(time.time()*1e9))
PYEOF
)
        local exit_code=0

        eval "$cmd" > /dev/null 2>&1 || exit_code=$?

        end_ns=$(date +%s%N 2>/dev/null || python3 << 'PYEOF'
import time
print(int(time.time()*1e9))
PYEOF
)
        elapsed_ms=$(( (end_ns - start_ns) / 1000000 ))

        printf "Run %d: %dms (exit: %d)\n" "$run" "$elapsed_ms" "$exit_code"

        total_ms=$((total_ms + elapsed_ms))
        [[ $elapsed_ms -lt $min_ms ]] && min_ms=$elapsed_ms
        [[ $elapsed_ms -gt $max_ms ]] && max_ms=$elapsed_ms

        run=$((run + 1))
    done

    echo ""
    echo "--- Summary ---"
    local avg_ms=$((total_ms / repeat))
    echo "Avg:   ${avg_ms}ms"
    echo "Min:   ${min_ms}ms"
    echo "Max:   ${max_ms}ms"
    echo "Total: ${total_ms}ms"

    if [[ $avg_ms -gt 5000 ]]; then
        echo "⚠️  SLOW: Average over 5 seconds"
    elif [[ $avg_ms -gt 1000 ]]; then
        echo "⚡ MODERATE: Average over 1 second"
    else
        echo "✅ FAST: Under 1 second"
    fi
}

# === diff-logs: compare two log files ===
cmd_diff_logs() {
    local errors_only=false
    local file1="" file2=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --errors-only) errors_only=true; shift ;;
            *) [[ -z "$file1" ]] && file1="$1" || file2="$1"; shift ;;
        esac
    done

    if [[ -z "$file1" || -z "$file2" ]]; then
        echo "Usage: debug diff-logs [--errors-only] <file1> <file2>" >&2
        return 1
    fi

    echo "=== Log Diff: $file1 vs $file2 ==="
    echo ""

    local lines1 lines2
    lines1=$(wc -l < "$file1")
    lines2=$(wc -l < "$file2")
    echo "Lines: $file1=$lines1, $file2=$lines2 (diff: $((lines2 - lines1)))"

    if [[ "$errors_only" == true ]]; then
        local err_pattern="ERROR\|FATAL\|Exception\|Traceback\|WARN"
        local errs1 errs2
        errs1=$(grep -c "$err_pattern" "$file1" 2>/dev/null || echo "0")
        errs2=$(grep -c "$err_pattern" "$file2" 2>/dev/null || echo "0")
        echo "Errors: $file1=$errs1, $file2=$errs2 (diff: $((errs2 - errs1)))"
        echo ""

        echo "--- New errors in $file2 ---"
        diff <(grep "$err_pattern" "$file1" 2>/dev/null | sort -u) \
             <(grep "$err_pattern" "$file2" 2>/dev/null | sort -u) 2>/dev/null | \
             grep "^>" | sed 's/^> //' | head -20
    else
        echo ""
        echo "--- New lines in $file2 ---"
        diff "$file1" "$file2" 2>/dev/null | grep "^>" | head -30 | sed 's/^> //'
        echo ""
        echo "--- Removed from $file1 ---"
        diff "$file1" "$file2" 2>/dev/null | grep "^<" | head -20 | sed 's/^< //'
    fi
}

# === http: debug HTTP requests ===
cmd_http() {
    local url=""
    local verbose=false
    local timing=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --verbose) verbose=true; shift ;;
            --timing) timing=true; shift ;;
            *) url="$1"; shift ;;
        esac
    done

    if [[ -z "$url" ]]; then
        echo "Usage: debug http [--verbose] [--timing] <url>" >&2
        return 1
    fi

    echo "=== HTTP Debug: $url ==="
    echo ""

    # Basic request
    local status
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
    echo "Status: $status"

    # Timing
    if [[ "$timing" == true ]]; then
        echo ""
        echo "--- Timing ---"
        curl -s -o /dev/null -w \
            "DNS:        %{time_namelookup}s\nConnect:    %{time_connect}s\nTLS:        %{time_appconnect}s\nFirstByte:  %{time_starttransfer}s\nTotal:      %{time_total}s\nSize:       %{size_download} bytes\n" \
            "$url" 2>/dev/null
    fi

    # Headers
    if [[ "$verbose" == true ]]; then
        echo ""
        echo "--- Response Headers ---"
        curl -sI "$url" 2>/dev/null | head -20
    fi

    # SSL info
    if [[ "$url" == https://* ]]; then
        echo ""
        echo "--- SSL ---"
        local ssl_info
        ssl_info=$(curl -s -o /dev/null -w "Protocol: %{ssl_verify_result}\n" "$url" 2>/dev/null)
        echo "$ssl_info"

        local expiry
        expiry=$(echo | openssl s_client -connect "${url#https://}:443" -servername "${url#https://}" 2>/dev/null | \
                 openssl x509 -noout -dates 2>/dev/null | grep "notAfter" | cut -d= -f2)
        [[ -n "$expiry" ]] && echo "Cert expires: $expiry"
    fi

    # Redirect chain
    echo ""
    echo "--- Redirects ---"
    curl -sIL "$url" 2>/dev/null | grep -E "^(HTTP/|Location:)" | head -10

    [[ "$status" -ge 400 ]] && return 1 || return 0
}

# === help ===
cmd_help() {
    cat << 'EOF'
debug v3.0.0 — Error tracing, log analysis, memory leak detection

Commands:
  trace       Find error patterns in log files
  stacktrace  Parse and summarize stack traces / crash dumps
  leaks       Detect memory leaks by monitoring process RSS
  profile     Measure execution time and resource usage
  diff-logs   Compare two log files, highlight new errors
  http        Debug HTTP requests (headers, timing, SSL, redirects)
  help        Show this help

Examples:
  debug trace /var/log/app.log
  debug trace --pattern "OOM|Segfault" --last 1h syslog
  debug stacktrace crash.log
  debug leaks --pid 1234 --duration 60
  debug profile --repeat 5 "curl -s https://api.example.com"
  debug diff-logs --errors-only old.log new.log
  debug http --verbose --timing https://example.com

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    trace)      shift; cmd_trace "$@" ;;
    stacktrace) shift; cmd_stacktrace "$@" ;;
    leaks)      shift; cmd_leaks "$@" ;;
    profile)    shift; cmd_profile "$@" ;;
    diff-logs)  shift; cmd_diff_logs "$@" ;;
    http)       shift; cmd_http "$@" ;;
    help|*)     cmd_help ;;
esac
