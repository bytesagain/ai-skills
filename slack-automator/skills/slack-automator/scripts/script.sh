#!/usr/bin/env bash
# Slack Automator — Send messages to Slack via Incoming Webhooks
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="4.0.0"
DATA_DIR="${HOME}/.slack-automator"
CONFIG_FILE="$DATA_DIR/config.json"
HISTORY_FILE="$DATA_DIR/history.json"
TEMPLATES_DIR="$DATA_DIR/templates"
SCHEDULE_FILE="$DATA_DIR/schedule.json"

# ── Initialization ──────────────────────────────────────────────

_init() {
    mkdir -p "$DATA_DIR" "$TEMPLATES_DIR"
    [ -f "$CONFIG_FILE" ]  || echo '{}' > "$CONFIG_FILE"
    [ -f "$HISTORY_FILE" ] || echo '[]' > "$HISTORY_FILE"
    [ -f "$SCHEDULE_FILE" ] || echo '[]' > "$SCHEDULE_FILE"
}

# ── JSON helpers (python3 heredoc — no shell interpolation issues) ──

_json_get() {
    # Usage: _json_get <file> <key>
    local file="$1" key="$2"
    python3 <<PYEOF
import json, sys
try:
    with open("$file") as f:
        data = json.load(f)
    val = data.get("$key", "")
    print(val if val else "")
except Exception:
    print("")
PYEOF
}

_json_set() {
    # Usage: _json_set <file> <key> <value>
    local file="$1" key="$2" value="$3"
    python3 <<PYEOF
import json
try:
    with open("$file") as f:
        data = json.load(f)
except Exception:
    data = {}
data["$key"] = """$value"""
with open("$file", "w") as f:
    json.dump(data, f, indent=2)
PYEOF
}

_build_payload() {
    # Build JSON payload safely using python3 heredoc
    # Usage: _build_payload <text> [channel]
    local text="$1"
    local channel="${2:-}"
    python3 <<PYEOF
import json, sys
payload = {}
payload["text"] = """$text"""
channel = """$channel"""
if channel:
    payload["channel"] = channel
print(json.dumps(payload))
PYEOF
}

_record_history() {
    # Append an entry to history.json
    # Usage: _record_history <action> <message> <status> [channel]
    local action="$1" message="$2" status="$3" channel="${4:-}"
    python3 <<PYEOF
import json, datetime
entry = {
    "timestamp": datetime.datetime.now().isoformat(),
    "action": """$action""",
    "message": """$message""",
    "status": """$status""",
    "channel": """$channel"""
}
try:
    with open("$HISTORY_FILE") as f:
        history = json.load(f)
except Exception:
    history = []
history.append(entry)
with open("$HISTORY_FILE", "w") as f:
    json.dump(history, f, indent=2)
PYEOF
}

# ── Webhook helpers ─────────────────────────────────────────────

_get_webhook_url() {
    local url
    url=$(_json_get "$CONFIG_FILE" "webhook_url")
    if [ -z "$url" ]; then
        echo "Error: No webhook URL configured." >&2
        echo "Run: slack-automator connect <webhook_url>" >&2
        return 1
    fi
    echo "$url"
}

_send_to_slack() {
    # Usage: _send_to_slack <payload_json>
    local payload="$1"
    local webhook_url
    webhook_url=$(_get_webhook_url) || return 1

    local http_code
    http_code=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST \
        -H 'Content-type: application/json' \
        --data "$payload" \
        --max-time 10 \
        "$webhook_url" 2>/dev/null) || {
        echo "Error: Failed to connect to Slack webhook." >&2
        return 1
    }

    if [ "$http_code" = "200" ]; then
        return 0
    else
        echo "Error: Slack returned HTTP $http_code." >&2
        return 1
    fi
}

# ── Commands ────────────────────────────────────────────────────

cmd_connect() {
    local url="${1:-}"
    if [ -z "$url" ]; then
        echo "Usage: slack-automator connect <webhook_url>"
        echo ""
        echo "Example:"
        echo "  slack-automator connect https://hooks.slack.com/services/T00/B00/xxxx"
        return 1
    fi

    # Validate URL format
    if [[ ! "$url" =~ ^https://hooks\.slack\.com/ ]]; then
        echo "Warning: URL does not look like a standard Slack webhook."
        echo "Expected: https://hooks.slack.com/services/..."
        read -r -p "Continue anyway? [y/N] " confirm
        if [[ ! "$confirm" =~ ^[yY] ]]; then
            echo "Aborted."
            return 1
        fi
    fi

    _json_set "$CONFIG_FILE" "webhook_url" "$url"
    echo "✅ Webhook URL saved."
    echo "Run 'slack-automator webhook test' to verify connectivity."
    _record_history "connect" "Webhook URL configured" "ok"
}

cmd_send() {
    if [ $# -eq 0 ]; then
        echo "Usage: slack-automator send <message>"
        echo ""
        echo "Example:"
        echo "  slack-automator send \"Hello from Slack Automator!\""
        return 1
    fi

    local message="$*"
    local payload
    payload=$(_build_payload "$message")

    echo "Sending message to Slack..."
    if _send_to_slack "$payload"; then
        echo "✅ Message sent successfully."
        _record_history "send" "$message" "ok"
    else
        echo "❌ Failed to send message."
        _record_history "send" "$message" "failed"
        return 1
    fi
}

cmd_notify() {
    if [ $# -lt 2 ]; then
        echo "Usage: slack-automator notify <channel> <message>"
        echo ""
        echo "Example:"
        echo "  slack-automator notify \"#alerts\" \"Server CPU at 95%!\""
        return 1
    fi

    local channel="$1"
    shift
    local message="$*"

    # Ensure channel starts with #
    [[ "$channel" != \#* ]] && channel="#$channel"

    local payload
    payload=$(_build_payload "$message" "$channel")

    echo "Sending notification to $channel..."
    if _send_to_slack "$payload"; then
        echo "✅ Notification sent to $channel."
        _record_history "notify" "$message" "ok" "$channel"
    else
        echo "❌ Failed to send notification."
        _record_history "notify" "$message" "failed" "$channel"
        return 1
    fi
}

cmd_schedule() {
    local subcmd="${1:-}"
    shift 2>/dev/null || true

    case "$subcmd" in
        add)
            if [ $# -lt 2 ]; then
                echo "Usage: slack-automator schedule add <time> <message>"
                echo ""
                echo "Time format: HH:MM (24-hour) or cron expression (e.g., '*/30 * * * *')"
                echo ""
                echo "Examples:"
                echo "  slack-automator schedule add 09:00 \"Good morning, team!\""
                echo "  slack-automator schedule add \"0 18 * * 5\" \"Happy Friday!\""
                return 1
            fi
            local time_spec="$1"
            shift
            local message="$*"

            # Convert HH:MM to cron format
            local cron_expr
            if [[ "$time_spec" =~ ^[0-9]{1,2}:[0-9]{2}$ ]]; then
                local hour minute
                hour=$(echo "$time_spec" | cut -d: -f1)
                minute=$(echo "$time_spec" | cut -d: -f2)
                cron_expr="$minute $hour * * *"
            else
                cron_expr="$time_spec"
            fi

            python3 <<PYEOF
import json, datetime
entry = {
    "id": int(datetime.datetime.now().timestamp()),
    "cron": """$cron_expr""",
    "message": """$message""",
    "created": datetime.datetime.now().isoformat(),
    "enabled": True
}
try:
    with open("$SCHEDULE_FILE") as f:
        schedule = json.load(f)
except Exception:
    schedule = []
schedule.append(entry)
with open("$SCHEDULE_FILE", "w") as f:
    json.dump(schedule, f, indent=2)
print(f"✅ Scheduled message (ID: {entry['id']})")
print(f"   Cron: {entry['cron']}")
print(f"   Message: {entry['message']}")
PYEOF
            _record_history "schedule-add" "$message" "ok"
            ;;
        list)
            echo "=== Scheduled Messages ==="
            python3 <<PYEOF
import json
try:
    with open("$SCHEDULE_FILE") as f:
        schedule = json.load(f)
except Exception:
    schedule = []
if not schedule:
    print("  No scheduled messages.")
else:
    for i, entry in enumerate(schedule, 1):
        status = "✅" if entry.get("enabled", True) else "⏸️"
        print(f"  {status} [{entry.get('id', '?')}] {entry.get('cron', '?')} — {entry.get('message', '?')}")
    print(f"\n  Total: {len(schedule)} scheduled message(s)")
PYEOF
            ;;
        remove)
            local sid="${1:-}"
            if [ -z "$sid" ]; then
                echo "Usage: slack-automator schedule remove <id>"
                return 1
            fi
            python3 <<PYEOF
import json
try:
    with open("$SCHEDULE_FILE") as f:
        schedule = json.load(f)
except Exception:
    schedule = []
new_schedule = [e for e in schedule if str(e.get("id", "")) != "$sid"]
if len(new_schedule) == len(schedule):
    print(f"Error: Schedule ID $sid not found.")
else:
    with open("$SCHEDULE_FILE", "w") as f:
        json.dump(new_schedule, f, indent=2)
    print(f"✅ Removed schedule $sid.")
PYEOF
            ;;
        *)
            echo "Usage: slack-automator schedule <add|list|remove>"
            echo ""
            echo "Subcommands:"
            echo "  add <time> <message>    Add a scheduled message"
            echo "  list                    List all scheduled messages"
            echo "  remove <id>             Remove a scheduled message"
            return 1
            ;;
    esac
}

cmd_template() {
    local subcmd="${1:-}"
    shift 2>/dev/null || true

    case "$subcmd" in
        list)
            echo "=== Message Templates ==="
            local count=0
            for tpl in "$TEMPLATES_DIR"/*.txt; do
                [ -f "$tpl" ] || continue
                local name
                name=$(basename "$tpl" .txt)
                local preview
                preview=$(head -1 "$tpl")
                echo "  📝 $name — $preview"
                count=$((count + 1))
            done
            if [ "$count" -eq 0 ]; then
                echo "  No templates saved."
                echo "  Use: slack-automator template save <name> <message>"
            else
                echo ""
                echo "  Total: $count template(s)"
            fi
            ;;
        save)
            if [ $# -lt 2 ]; then
                echo "Usage: slack-automator template save <name> <message>"
                echo ""
                echo "Example:"
                echo "  slack-automator template save deploy \"🚀 Deployed *{{service}}* to production.\""
                return 1
            fi
            local name="$1"
            shift
            local message="$*"
            echo "$message" > "$TEMPLATES_DIR/${name}.txt"
            echo "✅ Template '$name' saved."
            _record_history "template-save" "Saved template: $name" "ok"
            ;;
        use)
            if [ $# -lt 1 ]; then
                echo "Usage: slack-automator template use <name> [var=value ...]"
                echo ""
                echo "Example:"
                echo "  slack-automator template use deploy service=api-server"
                return 1
            fi
            local name="$1"
            shift
            local tpl_file="$TEMPLATES_DIR/${name}.txt"
            if [ ! -f "$tpl_file" ]; then
                echo "Error: Template '$name' not found."
                echo "Available templates:"
                cmd_template list
                return 1
            fi
            local message
            message=$(cat "$tpl_file")

            # Simple variable substitution: var=value replaces {{var}}
            for arg in "$@"; do
                local key="${arg%%=*}"
                local val="${arg#*=}"
                message="${message//\{\{$key\}\}/$val}"
            done

            local payload
            payload=$(_build_payload "$message")
            echo "Sending template '$name'..."
            if _send_to_slack "$payload"; then
                echo "✅ Template message sent."
                _record_history "template-use" "$message" "ok"
            else
                echo "❌ Failed to send template message."
                _record_history "template-use" "$message" "failed"
                return 1
            fi
            ;;
        *)
            echo "Usage: slack-automator template <list|save|use>"
            echo ""
            echo "Subcommands:"
            echo "  list                         List saved templates"
            echo "  save <name> <message>        Save a new template"
            echo "  use <name> [var=value ...]   Send using a template"
            return 1
            ;;
    esac
}

cmd_webhook() {
    local subcmd="${1:-}"

    case "$subcmd" in
        test)
            local webhook_url
            webhook_url=$(_get_webhook_url) || return 1

            echo "Testing webhook connectivity..."
            local payload
            payload=$(_build_payload "🔧 Slack Automator — webhook test ($(date '+%Y-%m-%d %H:%M:%S'))")

            if _send_to_slack "$payload"; then
                echo "✅ Webhook is working! Test message sent."
                _record_history "webhook-test" "Webhook test successful" "ok"
            else
                echo "❌ Webhook test failed."
                _record_history "webhook-test" "Webhook test failed" "failed"
                return 1
            fi
            ;;
        info)
            echo "=== Webhook Configuration ==="
            local url
            url=$(_json_get "$CONFIG_FILE" "webhook_url")
            if [ -n "$url" ]; then
                # Mask the URL for security (show first 40 chars + last 8)
                local masked
                if [ ${#url} -gt 50 ]; then
                    masked="${url:0:40}...${url: -8}"
                else
                    masked="$url"
                fi
                echo "  URL: $masked"
                echo "  Full URL stored in: $CONFIG_FILE"
            else
                echo "  No webhook URL configured."
                echo "  Run: slack-automator connect <webhook_url>"
            fi
            ;;
        *)
            echo "Usage: slack-automator webhook <test|info>"
            echo ""
            echo "Subcommands:"
            echo "  test    Send a test message to verify webhook"
            echo "  info    Show current webhook configuration"
            return 1
            ;;
    esac
}

cmd_format() {
    if [ $# -lt 2 ]; then
        echo "Usage: slack-automator format <style> <message>"
        echo ""
        echo "Styles:"
        echo "  bold      *bold text*"
        echo "  italic    _italic text_"
        echo "  code      \`inline code\`"
        echo "  codeblock \`\`\`code block\`\`\`"
        echo "  quote     > quoted text"
        echo "  list      • bullet list (comma-separated items)"
        echo "  strike    ~strikethrough~"
        return 1
    fi

    local style="$1"
    shift
    local text="$*"
    local formatted

    case "$style" in
        bold)      formatted="*${text}*" ;;
        italic)    formatted="_${text}_" ;;
        code)      formatted="\`${text}\`" ;;
        codeblock) formatted="\`\`\`${text}\`\`\`" ;;
        quote)     formatted="> ${text}" ;;
        strike)    formatted="~${text}~" ;;
        list)
            # Split comma-separated items into bullet list
            formatted=""
            IFS=',' read -ra items <<< "$text"
            for item in "${items[@]}"; do
                item=$(echo "$item" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                formatted="${formatted}• ${item}\n"
            done
            formatted=$(echo -e "$formatted" | sed '/^$/d')
            ;;
        *)
            echo "Unknown style: $style"
            echo "Available: bold, italic, code, codeblock, quote, list, strike"
            return 1
            ;;
    esac

    echo "Formatted message:"
    echo "$formatted"
    echo ""
    read -r -p "Send to Slack? [y/N] " confirm
    if [[ "$confirm" =~ ^[yY] ]]; then
        local payload
        payload=$(_build_payload "$formatted")
        if _send_to_slack "$payload"; then
            echo "✅ Formatted message sent."
            _record_history "format" "$formatted" "ok"
        else
            echo "❌ Failed to send."
            _record_history "format" "$formatted" "failed"
            return 1
        fi
    else
        echo "Message not sent. You can copy the formatted text above."
    fi
}

cmd_history() {
    echo "=== Message History ==="
    python3 <<PYEOF
import json
try:
    with open("$HISTORY_FILE") as f:
        history = json.load(f)
except Exception:
    history = []
if not history:
    print("  No messages sent yet.")
else:
    # Show last 20 entries
    recent = history[-20:]
    for entry in recent:
        ts = entry.get("timestamp", "?")[:19].replace("T", " ")
        action = entry.get("action", "?")
        status = "✅" if entry.get("status") == "ok" else "❌"
        msg = entry.get("message", "")
        channel = entry.get("channel", "")
        ch_str = f" → {channel}" if channel else ""
        # Truncate long messages
        if len(msg) > 60:
            msg = msg[:57] + "..."
        print(f"  {status} [{ts}] {action}{ch_str}: {msg}")
    if len(history) > 20:
        print(f"\n  (showing last 20 of {len(history)} entries)")
    print(f"\n  Total: {len(history)} message(s)")
PYEOF
}

cmd_stats() {
    echo "=== Slack Automator Stats ==="
    python3 <<PYEOF
import json, os
from collections import Counter

hist_file = "$HISTORY_FILE"
sched_file = "$SCHEDULE_FILE"
tpl_dir = "$TEMPLATES_DIR"

try:
    with open(hist_file) as f:
        history = json.load(f)
except Exception:
    history = []

try:
    with open(sched_file) as f:
        schedule = json.load(f)
except Exception:
    schedule = []

tpl_count = len([f for f in os.listdir(tpl_dir) if f.endswith(".txt")]) if os.path.isdir(tpl_dir) else 0

total = len(history)
success = sum(1 for e in history if e.get("status") == "ok")
failed = sum(1 for e in history if e.get("status") == "failed")

actions = Counter(e.get("action", "unknown") for e in history)

print(f"  Messages sent:    {total}")
print(f"  Successful:       {success}")
print(f"  Failed:           {failed}")
print(f"  Success rate:     {(success/total*100):.1f}%" if total > 0 else "  Success rate:     N/A")
print(f"  Scheduled:        {len(schedule)}")
print(f"  Templates:        {tpl_count}")
print()
if actions:
    print("  Actions breakdown:")
    for action, count in actions.most_common():
        print(f"    {action}: {count}")
if history:
    first = history[0].get("timestamp", "?")[:10]
    last = history[-1].get("timestamp", "?")[:10]
    print(f"\n  Period: {first} → {last}")
PYEOF
}

cmd_export() {
    local fmt="${1:-json}"
    local out="$DATA_DIR/export.$fmt"

    case "$fmt" in
        json)
            cp "$HISTORY_FILE" "$out"
            echo "✅ Exported history to $out"
            ;;
        csv)
            python3 <<PYEOF
import json, csv
try:
    with open("$HISTORY_FILE") as f:
        history = json.load(f)
except Exception:
    history = []
with open("$out", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["timestamp", "action", "message", "status", "channel"])
    for e in history:
        writer.writerow([
            e.get("timestamp", ""),
            e.get("action", ""),
            e.get("message", ""),
            e.get("status", ""),
            e.get("channel", "")
        ])
print(f"✅ Exported {len(history)} entries to $out")
PYEOF
            ;;
        txt)
            python3 <<PYEOF
import json
try:
    with open("$HISTORY_FILE") as f:
        history = json.load(f)
except Exception:
    history = []
with open("$out", "w") as f:
    f.write("=== Slack Automator History Export ===\n\n")
    for e in history:
        ts = e.get("timestamp", "?")[:19].replace("T", " ")
        action = e.get("action", "?")
        status = e.get("status", "?")
        msg = e.get("message", "")
        ch = e.get("channel", "")
        ch_str = f" → {ch}" if ch else ""
        f.write(f"[{ts}] {action} ({status}){ch_str}: {msg}\n")
print(f"✅ Exported {len(history)} entries to $out")
PYEOF
            ;;
        *)
            echo "Supported formats: json, csv, txt"
            return 1
            ;;
    esac
}

cmd_config() {
    local key="${1:-}"
    local val="${2:-}"

    if [ -z "$key" ]; then
        echo "=== Slack Automator Configuration ==="
        echo "  Config file: $CONFIG_FILE"
        echo "  Data dir:    $DATA_DIR"
        echo ""
        python3 <<PYEOF
import json
try:
    with open("$CONFIG_FILE") as f:
        data = json.load(f)
except Exception:
    data = {}
if not data:
    print("  (no settings configured)")
else:
    for k, v in data.items():
        # Mask webhook URL
        if k == "webhook_url" and len(str(v)) > 50:
            v = str(v)[:40] + "..." + str(v)[-8:]
        print(f"  {k} = {v}")
PYEOF
        echo ""
        echo "Set a value:  slack-automator config <key> <value>"
        echo "Keys: webhook_url, default_channel, username, icon_emoji"
        return 0
    fi

    if [ -z "$val" ]; then
        # Get a specific key
        local result
        result=$(_json_get "$CONFIG_FILE" "$key")
        if [ -n "$result" ]; then
            echo "$key = $result"
        else
            echo "Key '$key' is not set."
        fi
    else
        # Set a key
        _json_set "$CONFIG_FILE" "$key" "$val"
        echo "✅ Set $key = $val"
        _record_history "config" "Set $key" "ok"
    fi
}

cmd_help() {
    cat <<'EOF'
Slack Automator — Send messages to Slack via Incoming Webhooks

Usage: slack-automator <command> [arguments]

Setup:
  connect <url>                     Save Slack Incoming Webhook URL
  webhook test                      Test webhook connectivity
  webhook info                      Show webhook configuration

Messaging:
  send <message>                    Send a message to Slack
  notify <channel> <message>        Send to a specific channel
  format <style> <message>          Format and optionally send a message

Templates:
  template list                     List saved templates
  template save <name> <message>    Save a message template
  template use <name> [var=val]     Send using a template

Scheduling:
  schedule add <time> <message>     Add a scheduled message
  schedule list                     List scheduled messages
  schedule remove <id>              Remove a scheduled message

History & Stats:
  history                           Show message history
  stats                             Show usage statistics
  export <json|csv|txt>             Export history

Configuration:
  config                            View all settings
  config <key> <value>              Set a configuration value

Other:
  help                              Show this help
  version                           Show version

Data directory: ~/.slack-automator/
EOF
}

cmd_version() {
    echo "slack-automator v${VERSION}"
}

# ── Main ────────────────────────────────────────────────────────

_init

case "${1:-help}" in
    connect)     shift; cmd_connect "$@" ;;
    send)        shift; cmd_send "$@" ;;
    notify)      shift; cmd_notify "$@" ;;
    schedule)    shift; cmd_schedule "$@" ;;
    template)    shift; cmd_template "$@" ;;
    webhook)     shift; cmd_webhook "$@" ;;
    format)      shift; cmd_format "$@" ;;
    history)     cmd_history ;;
    stats)       cmd_stats ;;
    export)      shift; cmd_export "$@" ;;
    config)      shift; cmd_config "$@" ;;
    help|--help|-h)       cmd_help ;;
    version|--version|-v) cmd_version ;;
    *)
        echo "Unknown command: $1"
        echo "Run 'slack-automator help' for available commands."
        exit 1
        ;;
esac
