#!/usr/bin/env bash
# site-monitor — Website uptime monitoring
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
#
# Check HTTP status, response time, SSL expiry, alert on downtime.
# Cron-compatible output with Nagios-style exit codes.

set -euo pipefail

VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Defaults ───
FORMAT="text"
TIMEOUT=10
WARN_MS=2000
CRIT_MS=5000
SSL_WARN_DAYS=30
SSL_CRIT_DAYS=7
LOG_FILE=""
QUIET="false"
EXPECTED_STATUS=200

# ─── Usage ───
usage() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  site-monitor — Website Uptime Monitoring                    ║
║  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com║
╚══════════════════════════════════════════════════════════════╝

USAGE:
    bash scripts/main.sh <command> <url|domain|file> [options]

COMMANDS:
    check <url>         Check a single URL (status, response time, SSL)
    batch <file>        Check multiple URLs from a file (one per line)
    ssl <domain>        Check SSL certificate expiry
    history <logfile>   Show check history from log file
    report              Generate summary report from log
    cron <url>          Cron-optimized single-line output

OPTIONS:
    --timeout <secs>        Request timeout (default: 10)
    --warn-ms <ms>          Response time warning threshold (default: 2000)
    --crit-ms <ms>          Response time critical threshold (default: 5000)
    --ssl-warn-days <days>  SSL expiry warning (default: 30)
    --ssl-crit-days <days>  SSL expiry critical (default: 7)
    --log <file>            Append results to log file
    --format json|text|nagios  Output format (default: text)
    --quiet                 Only output on errors
    --expected-status <code> Expected HTTP status (default: 200)
    --version               Show version
    --help                  Show this help

EXIT CODES:
    0 = OK, 1 = WARNING, 2 = CRITICAL

EXAMPLES:
    bash scripts/main.sh check https://example.com
    bash scripts/main.sh cron https://example.com --warn-ms 1000 --log uptime.log
    bash scripts/main.sh ssl example.com --ssl-warn-days 14
    bash scripts/main.sh batch urls.txt --format json
EOF
}

# ─── Logging ───
log() {
    if [[ "${QUIET}" != "true" ]]; then
        echo "[site-monitor] $*" >&2
    fi
}

error() {
    echo "[ERROR] $*" >&2
    exit 1
}

# ─── Argument Parsing ───
COMMAND=""
TARGET=""
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --format)       FORMAT="${2:-text}"; shift 2 ;;
        --timeout)      TIMEOUT="${2:-10}"; shift 2 ;;
        --warn-ms)      WARN_MS="${2:-2000}"; shift 2 ;;
        --crit-ms)      CRIT_MS="${2:-5000}"; shift 2 ;;
        --ssl-warn-days) SSL_WARN_DAYS="${2:-30}"; shift 2 ;;
        --ssl-crit-days) SSL_CRIT_DAYS="${2:-7}"; shift 2 ;;
        --log)          LOG_FILE="${2:-}"; shift 2 ;;
        --quiet)        QUIET="true"; shift ;;
        --expected-status) EXPECTED_STATUS="${2:-200}"; shift 2 ;;
        --version)
            echo "site-monitor v${VERSION}"
            echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
            exit 0 ;;
        --help|-h) usage; exit 0 ;;
        -*) error "Unknown option: $1" ;;
        *) POSITIONAL_ARGS+=("$1"); shift ;;
    esac
done

if [[ ${#POSITIONAL_ARGS[@]} -lt 1 ]]; then
    usage
    exit 1
fi

COMMAND="${POSITIONAL_ARGS[0]}"
TARGET="${POSITIONAL_ARGS[1]:-}"

case "${COMMAND}" in
    check|cron|ssl)
        [[ -z "${TARGET}" ]] && error "URL/domain is required for '${COMMAND}' command"
        ;;
    batch)
        [[ -z "${TARGET}" ]] && error "File path is required for 'batch' command"
        [[ ! -f "${TARGET}" ]] && error "File not found: ${TARGET}"
        ;;
    history)
        TARGET="${TARGET:-${LOG_FILE}}"
        [[ -z "${TARGET}" ]] && error "Log file path is required. Use --log or provide as argument."
        ;;
    report)
        [[ -z "${LOG_FILE}" ]] && error "Log file required. Use --log <file>"
        ;;
    *) error "Unknown command: ${COMMAND}. Use --help for usage." ;;
esac

# ─── Main Python Script ───
run_monitor() {
    python3 << 'PYEOF'
import sys
import os
import json
import ssl
import socket
import time
import subprocess
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError
from datetime import datetime, timezone

# Config from environment
command = os.environ.get('MON_COMMAND', 'check')
target = os.environ.get('MON_TARGET', '')
fmt = os.environ.get('MON_FORMAT', 'text')
timeout = int(os.environ.get('MON_TIMEOUT', '10'))
warn_ms = int(os.environ.get('MON_WARN_MS', '2000'))
crit_ms = int(os.environ.get('MON_CRIT_MS', '5000'))
ssl_warn_days = int(os.environ.get('MON_SSL_WARN_DAYS', '30'))
ssl_crit_days = int(os.environ.get('MON_SSL_CRIT_DAYS', '7'))
log_file = os.environ.get('MON_LOG_FILE', '')
quiet = os.environ.get('MON_QUIET', 'false') == 'true'
expected_status = int(os.environ.get('MON_EXPECTED_STATUS', '200'))

exit_code = 0


def check_http(url):
    """Check HTTP status and response time."""
    global exit_code
    result = {
        'url': url,
        'timestamp': datetime.now(timezone.utc).isoformat(),
        'status': 'UNKNOWN',
        'status_code': 0,
        'response_time_ms': 0,
        'error': None,
        'ssl_expiry_days': None,
        'content_length': 0
    }

    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    req = Request(url, headers={
        'User-Agent': 'SiteMonitor/1.0.0 (bytesagain.com)',
        'Accept': 'text/html,application/xhtml+xml'
    })

    start = time.time()
    try:
        response = urlopen(req, timeout=timeout, context=ctx)
        elapsed_ms = int((time.time() - start) * 1000)
        result['status_code'] = response.status
        result['response_time_ms'] = elapsed_ms
        result['content_length'] = len(response.read())

        if response.status != expected_status:
            result['status'] = 'WARNING'
            result['error'] = f'Expected status {expected_status}, got {response.status}'
            exit_code = max(exit_code, 1)
        elif elapsed_ms > crit_ms:
            result['status'] = 'CRITICAL'
            result['error'] = f'Response time {elapsed_ms}ms > {crit_ms}ms threshold'
            exit_code = max(exit_code, 2)
        elif elapsed_ms > warn_ms:
            result['status'] = 'WARNING'
            result['error'] = f'Response time {elapsed_ms}ms > {warn_ms}ms threshold'
            exit_code = max(exit_code, 1)
        else:
            result['status'] = 'OK'

    except HTTPError as e:
        elapsed_ms = int((time.time() - start) * 1000)
        result['status_code'] = e.code
        result['response_time_ms'] = elapsed_ms
        result['status'] = 'CRITICAL'
        result['error'] = f'HTTP {e.code}: {e.reason}'
        exit_code = max(exit_code, 2)
    except URLError as e:
        elapsed_ms = int((time.time() - start) * 1000)
        result['response_time_ms'] = elapsed_ms
        result['status'] = 'CRITICAL'
        result['error'] = f'Connection failed: {e.reason}'
        exit_code = max(exit_code, 2)
    except socket.timeout:
        result['status'] = 'CRITICAL'
        result['error'] = f'Timeout after {timeout}s'
        result['response_time_ms'] = timeout * 1000
        exit_code = max(exit_code, 2)
    except Exception as e:
        result['status'] = 'CRITICAL'
        result['error'] = str(e)
        exit_code = max(exit_code, 2)

    # Check SSL if HTTPS
    if url.startswith('https://'):
        from urllib.parse import urlparse
        parsed = urlparse(url)
        domain = parsed.hostname
        ssl_days = check_ssl_expiry(domain)
        result['ssl_expiry_days'] = ssl_days
        if ssl_days is not None:
            if ssl_days <= 0:
                result['status'] = 'CRITICAL'
                result['error'] = (result.get('error') or '') + f'; SSL EXPIRED'
                exit_code = max(exit_code, 2)
            elif ssl_days <= ssl_crit_days:
                if result['status'] != 'CRITICAL':
                    result['status'] = 'CRITICAL'
                result['error'] = (result.get('error') or '') + f'; SSL expires in {ssl_days} days'
                exit_code = max(exit_code, 2)
            elif ssl_days <= ssl_warn_days:
                if result['status'] == 'OK':
                    result['status'] = 'WARNING'
                result['error'] = (result.get('error') or '') + f'; SSL expires in {ssl_days} days'
                exit_code = max(exit_code, 1)

    return result


def check_ssl_expiry(domain, port=443):
    """Check SSL certificate expiry using openssl."""
    try:
        cmd = f'echo | openssl s_client -servername {domain} -connect {domain}:{port} 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null'
        output = subprocess.check_output(cmd, shell=True, timeout=timeout).decode().strip()
        if 'notAfter=' in output:
            date_str = output.split('notAfter=')[1].strip()
            # Parse openssl date format
            from email.utils import parsedate_to_datetime
            try:
                expiry = parsedate_to_datetime(date_str)
            except Exception:
                # Try alternative parsing
                try:
                    expiry = datetime.strptime(date_str, '%b %d %H:%M:%S %Y %Z')
                    expiry = expiry.replace(tzinfo=timezone.utc)
                except Exception:
                    return None
            now = datetime.now(timezone.utc)
            days = (expiry - now).days
            return days
    except Exception:
        return None
    return None


def format_result(result):
    """Format a single check result."""
    if fmt == 'json':
        return json.dumps(result, indent=2)
    elif fmt == 'nagios':
        status = result['status']
        url = result['url']
        rt = result['response_time_ms']
        code = result['status_code']
        ssl_d = result.get('ssl_expiry_days', 'N/A')
        err = result.get('error', '')
        return f'{status} - {url} | status={code} response_time={rt}ms ssl_days={ssl_d} | {err}'
    else:
        lines = []
        status_icon = {'OK': '✅', 'WARNING': '⚠️', 'CRITICAL': '❌', 'UNKNOWN': '❓'}
        icon = status_icon.get(result['status'], '❓')
        lines.append(f'{icon} {result["status"]} — {result["url"]}')
        lines.append(f'   Status Code:    {result["status_code"]}')
        lines.append(f'   Response Time:  {result["response_time_ms"]}ms')
        if result.get('ssl_expiry_days') is not None:
            lines.append(f'   SSL Expiry:     {result["ssl_expiry_days"]} days')
        if result.get('content_length'):
            lines.append(f'   Content Length: {result["content_length"]} bytes')
        if result.get('error'):
            lines.append(f'   Note:           {result["error"]}')
        lines.append(f'   Checked:        {result["timestamp"]}')
        return '\n'.join(lines)


def append_log(result):
    """Append result to log file."""
    if log_file:
        with open(log_file, 'a') as f:
            f.write(json.dumps(result) + '\n')


def cmd_check():
    result = check_http(target)
    output = format_result(result)
    if not quiet or result['status'] != 'OK':
        print(output)
    append_log(result)


def cmd_cron():
    result = check_http(target)
    status = result['status']
    url = result['url']
    rt = result['response_time_ms']
    code = result['status_code']
    ts = result['timestamp']
    err = result.get('error', '')
    line = f'{ts} {status} {url} HTTP/{code} {rt}ms'
    if err:
        line += f' [{err}]'
    if not quiet or status != 'OK':
        print(line)
    append_log(result)


def cmd_ssl():
    domain = target.replace('https://', '').replace('http://', '').split('/')[0]
    days = check_ssl_expiry(domain)
    result = {
        'domain': domain,
        'timestamp': datetime.now(timezone.utc).isoformat(),
        'ssl_expiry_days': days,
        'status': 'UNKNOWN'
    }
    global exit_code
    if days is None:
        result['status'] = 'UNKNOWN'
        result['error'] = 'Could not retrieve SSL certificate'
    elif days <= 0:
        result['status'] = 'CRITICAL'
        result['error'] = 'Certificate has EXPIRED'
        exit_code = 2
    elif days <= ssl_crit_days:
        result['status'] = 'CRITICAL'
        result['error'] = f'Certificate expires in {days} days (< {ssl_crit_days})'
        exit_code = 2
    elif days <= ssl_warn_days:
        result['status'] = 'WARNING'
        result['error'] = f'Certificate expires in {days} days (< {ssl_warn_days})'
        exit_code = 1
    else:
        result['status'] = 'OK'
        result['error'] = f'Certificate valid for {days} days'

    if fmt == 'json':
        print(json.dumps(result, indent=2))
    else:
        icon = {'OK': '✅', 'WARNING': '⚠️', 'CRITICAL': '❌'}.get(result['status'], '❓')
        print(f'{icon} SSL {result["status"]} — {domain}')
        print(f'   Expiry: {days} days remaining' if days else '   Expiry: Unknown')
        if result.get('error'):
            print(f'   Note:   {result["error"]}')
    append_log(result)


def cmd_batch():
    if not os.path.isfile(target):
        print(f'Error: File not found: {target}', file=sys.stderr)
        sys.exit(1)
    with open(target) as f:
        urls = [line.strip() for line in f if line.strip() and not line.startswith('#')]

    results = []
    for url in urls:
        result = check_http(url)
        results.append(result)
        if not quiet or result['status'] != 'OK':
            print(format_result(result))
            if fmt == 'text':
                print()
        append_log(result)

    # Summary
    ok = sum(1 for r in results if r['status'] == 'OK')
    warn = sum(1 for r in results if r['status'] == 'WARNING')
    crit = sum(1 for r in results if r['status'] == 'CRITICAL')
    print(f'\n--- Summary: {len(results)} checked | ✅ {ok} OK | ⚠️ {warn} WARN | ❌ {crit} CRIT ---')


def cmd_history():
    log_path = target
    if not os.path.isfile(log_path):
        print(f'Error: Log file not found: {log_path}', file=sys.stderr)
        sys.exit(1)
    with open(log_path) as f:
        lines = f.readlines()

    entries = []
    for line in lines:
        try:
            entries.append(json.loads(line.strip()))
        except json.JSONDecodeError:
            continue

    if not entries:
        print('No history entries found.')
        return

    if fmt == 'json':
        print(json.dumps(entries, indent=2))
    else:
        print(f'History: {len(entries)} entries')
        print('-' * 80)
        for e in entries[-20:]:
            status = e.get('status', '?')
            url = e.get('url', e.get('domain', '?'))
            ts = e.get('timestamp', '?')
            rt = e.get('response_time_ms', '?')
            icon = {'OK': '✅', 'WARNING': '⚠️', 'CRITICAL': '❌'}.get(status, '❓')
            print(f'{icon} {ts} | {status:10s} | {url} | {rt}ms')


def cmd_report():
    if not os.path.isfile(log_file):
        print(f'Error: Log file not found: {log_file}', file=sys.stderr)
        sys.exit(1)
    with open(log_file) as f:
        lines = f.readlines()

    entries = []
    for line in lines:
        try:
            entries.append(json.loads(line.strip()))
        except json.JSONDecodeError:
            continue

    if not entries:
        print('No entries to report.')
        return

    # Group by URL
    by_url = {}
    for e in entries:
        url = e.get('url', e.get('domain', 'unknown'))
        by_url.setdefault(url, []).append(e)

    print(f'=== Site Monitor Report ===')
    print(f'Generated: {datetime.now().isoformat()}')
    print(f'Total checks: {len(entries)}')
    print(f'URLs monitored: {len(by_url)}')
    print()

    for url, checks in by_url.items():
        ok = sum(1 for c in checks if c.get('status') == 'OK')
        total = len(checks)
        uptime = (ok / total * 100) if total > 0 else 0
        avg_rt = sum(c.get('response_time_ms', 0) for c in checks) / total if total > 0 else 0
        print(f'📊 {url}')
        print(f'   Uptime:       {uptime:.1f}% ({ok}/{total} checks OK)')
        print(f'   Avg Response: {avg_rt:.0f}ms')
        print(f'   Last Status:  {checks[-1].get("status", "?")}')
        print()


# ─── Main ───
commands = {
    'check': cmd_check,
    'cron': cmd_cron,
    'ssl': cmd_ssl,
    'batch': cmd_batch,
    'history': cmd_history,
    'report': cmd_report,
}

if command in commands:
    commands[command]()
    sys.exit(exit_code)
else:
    print(f'Unknown command: {command}', file=sys.stderr)
    sys.exit(1)
PYEOF
}

# ─── Execute ───
export MON_COMMAND="${COMMAND}"
export MON_TARGET="${TARGET}"
export MON_FORMAT="${FORMAT}"
export MON_TIMEOUT="${TIMEOUT}"
export MON_WARN_MS="${WARN_MS}"
export MON_CRIT_MS="${CRIT_MS}"
export MON_SSL_WARN_DAYS="${SSL_WARN_DAYS}"
export MON_SSL_CRIT_DAYS="${SSL_CRIT_DAYS}"
export MON_LOG_FILE="${LOG_FILE}"
export MON_QUIET="${QUIET}"
export MON_EXPECTED_STATUS="${EXPECTED_STATUS}"

log "Running '${COMMAND}' on ${TARGET} (format: ${FORMAT})"
run_monitor
RESULT=$?
log "Done (exit: ${RESULT})."
exit ${RESULT}
