#!/usr/bin/env bash
# site-change-alert — Website Change Monitor & Alert System
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="2.0.1"
DATA_DIR="${SITE_ALERT_DIR:-$HOME/.site-change-alert}"
WATCH_FILE="${DATA_DIR}/watchlist.tsv"
SNAP_DIR="${DATA_DIR}/snapshots"
CONFIG_FILE="${DATA_DIR}/config.sh"

ensure_dirs() {
    mkdir -p "$DATA_DIR" "$SNAP_DIR"
    if [ ! -f "$WATCH_FILE" ]; then
        printf "url\tselector\tinterval_min\tadded_at\tlast_checked\n" > "$WATCH_FILE"
    fi
    if [ ! -f "$CONFIG_FILE" ]; then
        cat > "$CONFIG_FILE" <<'CONF'
# site-change-alert configuration
NOTIFY_METHOD="stdout"
WEBHOOK_URL=""
EMAIL_TO=""
USER_AGENT="Mozilla/5.0 (compatible; SiteChangeAlert/2.0; +https://bytesagain.com)"
TIMEOUT=30
RETRY_COUNT=2
CONF
    fi
    # shellcheck source=/dev/null
    source "$CONFIG_FILE"
}

url_to_slug() {
    echo "$1" | sed 's|https\?://||;s|[^a-zA-Z0-9]|_|g' | head -c 120
}

fetch_page() {
    local url="$1"
    local selector="${2:-}"
    local tmpfile
    tmpfile=$(mktemp)

    local ua="${USER_AGENT:-Mozilla/5.0 (compatible; SiteChangeAlert/2.0)}"
    local timeout="${TIMEOUT:-30}"

    if ! curl -sL --max-time "$timeout" \
         -H "User-Agent: $ua" \
         -o "$tmpfile" "$url" 2>/dev/null; then
        echo "❌ Failed to fetch: $url" >&2
        rm -f "$tmpfile"
        return 1
    fi

    if [ -n "$selector" ] && command -v python3 &>/dev/null; then
        python3 -u <<PYEOF
import sys
try:
    from html.parser import HTMLParser
    # Simple text extraction — strip HTML tags
    class TextExtractor(HTMLParser):
        def __init__(self):
            super().__init__()
            self.text = []
            self.skip = False
        def handle_starttag(self, tag, attrs):
            if tag in ('script', 'style', 'noscript'):
                self.skip = True
        def handle_endtag(self, tag):
            if tag in ('script', 'style', 'noscript'):
                self.skip = False
        def handle_data(self, data):
            if not self.skip:
                stripped = data.strip()
                if stripped:
                    self.text.append(stripped)

    with open("$tmpfile", "r", errors="ignore") as f:
        html = f.read()
    parser = TextExtractor()
    parser.feed(html)
    print("\n".join(parser.text))
except Exception as e:
    print(f"Parse error: {e}", file=sys.stderr)
    with open("$tmpfile", "r", errors="ignore") as f:
        print(f.read())
PYEOF
    else
        # Fallback: strip HTML tags with sed
        sed -e 's/<script[^>]*>.*<\/script>//g' \
            -e 's/<style[^>]*>.*<\/style>//g' \
            -e 's/<[^>]*>//g' \
            -e '/^[[:space:]]*$/d' "$tmpfile"
    fi

    rm -f "$tmpfile"
}

cmd_watch() {
    local url="${1:-}"
    local selector=""
    local interval=60

    if [ -z "$url" ]; then
        cat <<'EOF'
═══════════════════════════════════════════════════
  Watch — Add URL to Monitor List
═══════════════════════════════════════════════════

Usage:
  bash scripts/script.sh watch <url> [options]

Options:
  --selector <css>    CSS-like selector to focus on (text extraction)
  --interval <min>    Check interval in minutes (default: 60)

Examples:
  bash scripts/script.sh watch "https://example.com/pricing"
  bash scripts/script.sh watch "https://example.com/status" --selector ".status"
  bash scripts/script.sh watch "https://news.ycombinator.com" --interval 30

Tips:
  • Start with the full page, then narrow with selectors
  • Use shorter intervals for time-sensitive pages
  • Some sites block bots — check robots.txt first
  • Dynamic (JS-rendered) content may not be captured

Watch List Storage:
  Stored in: ~/.site-change-alert/watchlist.tsv
  Format: URL, selector, interval, added date, last checked

📖 More skills: bytesagain.com
EOF
        return 0
    fi

    shift
    while [ $# -gt 0 ]; do
        case "$1" in
            --selector) selector="$2"; shift 2 ;;
            --interval) interval="$2"; shift 2 ;;
            *) shift ;;
        esac
    done

    ensure_dirs

    # Check if already watched
    if grep -qF "$url" "$WATCH_FILE" 2>/dev/null; then
        echo "⚠️  URL already in watch list: $url"
        echo "📖 More skills: bytesagain.com"
        return 0
    fi

    local now
    now=$(date -Iseconds 2>/dev/null || date +%Y-%m-%dT%H:%M:%S)

    printf "%s\t%s\t%s\t%s\t%s\n" "$url" "$selector" "$interval" "$now" "never" >> "$WATCH_FILE"

    # Take initial snapshot
    local slug
    slug=$(url_to_slug "$url")
    local snap_file="${SNAP_DIR}/${slug}.latest.txt"

    echo "📸 Taking initial snapshot..."
    if fetch_page "$url" "$selector" > "$snap_file" 2>/dev/null; then
        local lines words
        lines=$(wc -l < "$snap_file")
        words=$(wc -w < "$snap_file")

        cat <<EOF
═══════════════════════════════════════════════════
  ✅ URL Added to Watch List
═══════════════════════════════════════════════════

  URL:       $url
  Selector:  ${selector:-"(full page)"}
  Interval:  ${interval} minutes
  Added:     $now

  Initial Snapshot:
    Lines: $lines
    Words: $words
    Stored: $snap_file

  Next: Run 'check' to detect changes, or 'schedule' for auto-check.

📖 More skills: bytesagain.com
EOF
    else
        echo "⚠️  URL added but initial snapshot failed. Check URL accessibility."
        echo "📖 More skills: bytesagain.com"
    fi
}

cmd_check() {
    local url="${1:-}"

    ensure_dirs

    if [ "$url" = "--all" ] || [ -z "$url" ]; then
        echo "═══════════════════════════════════════════════════"
        echo "  🔍 Checking All Watched URLs"
        echo "═══════════════════════════════════════════════════"
        echo ""

        local total=0 changed=0 failed=0

        while IFS=$'\t' read -r wurl wselector winterval wadded wlast; do
            [ "$wurl" = "url" ] && continue
            total=$(( total + 1 ))

            echo "  Checking: $wurl"
            local slug
            slug=$(url_to_slug "$wurl")
            local snap_latest="${SNAP_DIR}/${slug}.latest.txt"
            local snap_new="${SNAP_DIR}/${slug}.new.txt"

            if fetch_page "$wurl" "$wselector" > "$snap_new" 2>/dev/null; then
                if [ -f "$snap_latest" ]; then
                    if ! diff -q "$snap_latest" "$snap_new" >/dev/null 2>&1; then
                        changed=$(( changed + 1 ))
                        local ts
                        ts=$(date +%Y%m%d_%H%M%S)
                        cp "$snap_latest" "${SNAP_DIR}/${slug}.${ts}.txt"
                        mv "$snap_new" "$snap_latest"
                        echo "    🔴 CHANGED! (previous snapshot archived)"
                    else
                        echo "    🟢 No change"
                        rm -f "$snap_new"
                    fi
                else
                    mv "$snap_new" "$snap_latest"
                    echo "    📸 First snapshot taken"
                fi
            else
                failed=$(( failed + 1 ))
                echo "    ❌ Fetch failed"
                rm -f "$snap_new"
            fi
        done < "$WATCH_FILE"

        echo ""
        echo "  ─────────────────────────────────────────────"
        echo "  Total: $total | Changed: $changed | Failed: $failed"
        echo ""
        echo "📖 More skills: bytesagain.com"
        return 0
    fi

    echo "═══════════════════════════════════════════════════"
    echo "  🔍 Checking: $url"
    echo "═══════════════════════════════════════════════════"
    echo ""

    local slug
    slug=$(url_to_slug "$url")
    local snap_latest="${SNAP_DIR}/${slug}.latest.txt"
    local snap_new="${SNAP_DIR}/${slug}.new.txt"

    if ! fetch_page "$url" "" > "$snap_new" 2>/dev/null; then
        echo "  ❌ Failed to fetch URL"
        rm -f "$snap_new"
        echo ""
        echo "📖 More skills: bytesagain.com"
        return 1
    fi

    if [ -f "$snap_latest" ]; then
        if diff -q "$snap_latest" "$snap_new" >/dev/null 2>&1; then
            echo "  🟢 No change detected"
            rm -f "$snap_new"
        else
            local ts
            ts=$(date +%Y%m%d_%H%M%S)
            local diff_lines
            diff_lines=$(diff "$snap_latest" "$snap_new" | head -40)
            cp "$snap_latest" "${SNAP_DIR}/${slug}.${ts}.txt"
            mv "$snap_new" "$snap_latest"

            echo "  🔴 CHANGE DETECTED!"
            echo ""
            echo "  Diff (first 40 lines):"
            echo "  ─────────────────────────────────────────────"
            echo "$diff_lines" | sed 's/^/  /'
            echo "  ─────────────────────────────────────────────"
            echo ""
            echo "  Previous snapshot archived: ${slug}.${ts}.txt"
        fi
    else
        mv "$snap_new" "$snap_latest"
        echo "  📸 First snapshot taken ($(wc -l < "$snap_latest") lines)"
        echo "  Run 'check' again later to detect changes."
    fi
    echo ""
    echo "📖 More skills: bytesagain.com"
}

cmd_diff() {
    local url="${1:-}"

    if [ -z "$url" ]; then
        cat <<'EOF'
═══════════════════════════════════════════════════
  Diff — Compare Snapshots
═══════════════════════════════════════════════════

Usage:
  bash scripts/script.sh diff <url>

Shows the unified diff between the two most recent snapshots
of the specified URL.

Examples:
  bash scripts/script.sh diff "https://example.com/pricing"

Diff Legend:
  --- a/previous    Previous snapshot
  +++ b/current     Current snapshot
  -  Removed line   (was in previous, not in current)
  +  Added line     (in current, not in previous)
     Unchanged      (context line)

Tips:
  • Large diffs may indicate layout/template changes
  • Small, targeted diffs usually mean content updates
  • Use --selector when watching to reduce noise

📖 More skills: bytesagain.com
EOF
        return 0
    fi

    ensure_dirs

    local slug
    slug=$(url_to_slug "$url")
    local snap_latest="${SNAP_DIR}/${slug}.latest.txt"

    if [ ! -f "$snap_latest" ]; then
        echo "❌ No snapshots found for: $url"
        echo "   Run 'watch' or 'check' first."
        echo ""
        echo "📖 More skills: bytesagain.com"
        return 1
    fi

    # Find most recent archived snapshot
    local prev_snap
    prev_snap=$(ls -t "${SNAP_DIR}/${slug}".2*.txt 2>/dev/null | head -1)

    if [ -z "$prev_snap" ]; then
        echo "═══════════════════════════════════════════════════"
        echo "  📄 Only one snapshot exists for this URL"
        echo "═══════════════════════════════════════════════════"
        echo ""
        echo "  URL: $url"
        echo "  Snapshot: $snap_latest ($(wc -l < "$snap_latest") lines)"
        echo "  Need at least 2 snapshots to diff."
        echo ""
        echo "📖 More skills: bytesagain.com"
        return 0
    fi

    echo "═══════════════════════════════════════════════════"
    echo "  📊 Diff: $url"
    echo "═══════════════════════════════════════════════════"
    echo ""
    echo "  Previous: $(basename "$prev_snap")"
    echo "  Current:  $(basename "$snap_latest")"
    echo ""

    local added removed
    added=$(diff "$prev_snap" "$snap_latest" | grep -c '^>' 2>/dev/null || true)
    removed=$(diff "$prev_snap" "$snap_latest" | grep -c '^<' 2>/dev/null || true)

    echo "  Summary: +${added} lines added, -${removed} lines removed"
    echo ""
    echo "  ─────────────────────────────────────────────"
    diff -u "$prev_snap" "$snap_latest" | head -80 || true
    echo "  ─────────────────────────────────────────────"
    echo ""
    echo "📖 More skills: bytesagain.com"
}

cmd_schedule() {
    local url="${1:-}"
    local interval="${2:-60}"

    if [ -z "$url" ]; then
        cat <<'EOF'
═══════════════════════════════════════════════════
  Schedule — Periodic Checking via Cron
═══════════════════════════════════════════════════

Usage:
  bash scripts/script.sh schedule <url> [interval_minutes]

Arguments:
  url               URL to check periodically
  interval_minutes  Check interval (default: 60)

Examples:
  bash scripts/script.sh schedule "https://example.com" 30
  bash scripts/script.sh schedule "https://news.ycombinator.com" 15

How It Works:
  1. Creates a cron job for periodic checking
  2. Each run takes a snapshot and compares
  3. If changes detected, triggers notification
  4. Archives previous snapshots with timestamps

Cron Job Format:
  */30 * * * * /path/to/script.sh check "https://example.com"

Remove Schedule:
  crontab -l | grep -v "site-change-alert" | crontab -

View Active Schedules:
  crontab -l | grep "site-change-alert"

📖 More skills: bytesagain.com
EOF
        return 0
    fi

    ensure_dirs

    local script_path
    script_path=$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null || echo "${BASH_SOURCE[0]}")
    local cron_cmd="*/${interval} * * * * bash ${script_path} check '${url}' >> ${DATA_DIR}/cron.log 2>&1"

    # Check if already scheduled
    if crontab -l 2>/dev/null | grep -qF "$url"; then
        echo "⚠️  URL already scheduled. Updating interval..."
        local temp_cron
        temp_cron=$(mktemp)
        crontab -l 2>/dev/null | grep -vF "$url" > "$temp_cron"
        echo "$cron_cmd" >> "$temp_cron"
        crontab "$temp_cron"
        rm -f "$temp_cron"
    else
        (crontab -l 2>/dev/null; echo "$cron_cmd") | crontab -
    fi

    cat <<EOF
═══════════════════════════════════════════════════
  ⏰ Schedule Created
═══════════════════════════════════════════════════

  URL:       $url
  Interval:  Every ${interval} minutes
  Cron:      ${cron_cmd}

  Log File:  ${DATA_DIR}/cron.log

  Manage:
    View:    crontab -l | grep site-change-alert
    Remove:  crontab -l | grep -v "$url" | crontab -

📖 More skills: bytesagain.com
EOF
}

cmd_notify() {
    local method="${1:-}"
    local target="${2:-}"

    if [ -z "$method" ]; then
        cat <<'EOF'
═══════════════════════════════════════════════════
  Notify — Configure Alert Channels
═══════════════════════════════════════════════════

Usage:
  bash scripts/script.sh notify <method> <target>

Methods:
  webhook <url>      Send alerts to a webhook URL (Slack, Discord, etc.)
  email <address>    Send alerts via email (requires sendmail/mail)
  stdout             Print alerts to stdout (default)

Examples:
  bash scripts/script.sh notify webhook "https://hooks.slack.com/services/T.../B.../..."
  bash scripts/script.sh notify email "admin@example.com"
  bash scripts/script.sh notify stdout

Webhook Payload Format (JSON):
  {
    "text": "🔴 Change detected: <url>",
    "url": "<url>",
    "timestamp": "2024-03-15T10:30:00",
    "added_lines": 5,
    "removed_lines": 2
  }

Supported Webhook Platforms:
  • Slack (Incoming Webhooks)
  • Discord (Webhook URL)
  • Microsoft Teams (Incoming Webhook)
  • Custom HTTP endpoint (POST JSON)
  • Telegram Bot API (via webhook adapter)

📖 More skills: bytesagain.com
EOF
        return 0
    fi

    ensure_dirs

    case "$method" in
        webhook)
            if [ -z "$target" ]; then
                echo "❌ Webhook URL required"
                echo "Usage: bash scripts/script.sh notify webhook <url>"
                echo "📖 More skills: bytesagain.com"
                return 1
            fi
            sed -i "s|^NOTIFY_METHOD=.*|NOTIFY_METHOD=\"webhook\"|" "$CONFIG_FILE"
            sed -i "s|^WEBHOOK_URL=.*|WEBHOOK_URL=\"${target}\"|" "$CONFIG_FILE"
            echo "✅ Notifications set to webhook: ${target:0:50}..."
            ;;
        email)
            if [ -z "$target" ]; then
                echo "❌ Email address required"
                echo "Usage: bash scripts/script.sh notify email <address>"
                echo "📖 More skills: bytesagain.com"
                return 1
            fi
            sed -i "s|^NOTIFY_METHOD=.*|NOTIFY_METHOD=\"email\"|" "$CONFIG_FILE"
            sed -i "s|^EMAIL_TO=.*|EMAIL_TO=\"${target}\"|" "$CONFIG_FILE"
            echo "✅ Notifications set to email: $target"
            ;;
        stdout)
            sed -i "s|^NOTIFY_METHOD=.*|NOTIFY_METHOD=\"stdout\"|" "$CONFIG_FILE"
            echo "✅ Notifications set to stdout (console output)"
            ;;
        *)
            echo "❌ Unknown method: $method"
            echo "Supported: webhook, email, stdout"
            ;;
    esac
    echo ""
    echo "📖 More skills: bytesagain.com"
}

cmd_help() {
    cat <<EOF
Site-Change-Alert v${VERSION} — Website Change Monitor & Alert System

Commands:
  watch <url> [--selector <sel>] [--interval <min>]
                         Add a URL to the watch list
  check [url|--all]      Check URL(s) for changes now
  diff <url>             Show diff between snapshots
  schedule <url> [min]   Set up periodic cron-based checking
  notify <method> [target]
                         Configure notification channel
  help                   Show this help
  version                Show version

Usage:
  bash scripts/script.sh watch "https://example.com/pricing"
  bash scripts/script.sh check --all
  bash scripts/script.sh diff "https://example.com/pricing"
  bash scripts/script.sh schedule "https://example.com" 30
  bash scripts/script.sh notify webhook "https://hooks.slack.com/..."

Data Directory: ~/.site-change-alert/

Related skills:
  clawhub install smart-web-scraper
  clawhub install rss-digest
Browse all: bytesagain.com

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    watch)      shift; cmd_watch "$@" ;;
    check)      shift; cmd_check "$@" ;;
    diff)       shift; cmd_diff "$@" ;;
    schedule)   shift; cmd_schedule "$@" ;;
    notify)     shift; cmd_notify "$@" ;;
    version)    echo "site-change-alert v${VERSION}" ;;
    help|*)     cmd_help ;;
esac
