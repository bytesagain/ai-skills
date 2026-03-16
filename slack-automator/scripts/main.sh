#!/usr/bin/env bash
# Slack Automator — Manage Slack workspace via API
# Usage: bash main.sh --action <action> --token <token> [options]
set -euo pipefail

ACTION=""
TOKEN="${SLACK_TOKEN:-}"
CHANNEL=""
MESSAGE=""
USER_ID=""
QUERY=""
OUTPUT=""

show_help() {
    cat << 'HELPEOF'
Slack Automator — Full Slack API toolkit

Usage: bash main.sh --action <action> --token <token> [options]

Actions:
  send-message       Send message to channel (--channel --message)
  list-channels      List all channels
  list-members       List workspace members
  channel-history    Get channel messages (--channel)
  search             Search messages (--query)
  set-topic          Set channel topic (--channel --message)
  user-info          Get user info (--user-id)
  upload-file        Upload file (--channel --file)

Options:
  --token <token>      Slack Bot Token (or SLACK_TOKEN env)
  --channel <id>       Channel ID or name
  --message <text>     Message text
  --user-id <id>       User ID
  --query <text>       Search query
  --output <file>      Save output to file

Examples:
  bash main.sh --action send-message --channel "#general" --message "Hello!" --token xoxb-xxx
  bash main.sh --action list-channels
  bash main.sh --action search --query "deployment"
  bash main.sh --action channel-history --channel C01234

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --action) ACTION="$2"; shift 2;;
        --token) TOKEN="$2"; shift 2;;
        --channel) CHANNEL="$2"; shift 2;;
        --message) MESSAGE="$2"; shift 2;;
        --user-id) USER_ID="$2"; shift 2;;
        --query) QUERY="$2"; shift 2;;
        --output) OUTPUT="$2"; shift 2;;
        --help|-h) show_help; exit 0;;
        *) shift;;
    esac
done

[ -z "$ACTION" ] && { echo "Error: --action required"; show_help; exit 1; }
[ -z "$TOKEN" ] && { echo "Error: --token required (or set SLACK_TOKEN env)"; exit 1; }

API="https://slack.com/api"

slack_api() {
    local method="$1" endpoint="$2" data="${3:-}"
    local url="$API/$endpoint"
    if [ "$method" = "GET" ]; then
        curl -s "$url${data:+?$data}" -H "Authorization: Bearer $TOKEN" 2>/dev/null
    else
        curl -s -X POST "$url" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" ${data:+-d "$data"} 2>/dev/null
    fi
}

format_json() {
    python3 << 'PYEOF'
import json, sys
data = json.load(sys.stdin)
if not data.get("ok"):
    print("Error: {}".format(data.get("error", "unknown")))
    sys.exit(1)
json.dump(data, sys.stdout, indent=2)
PYEOF
}

case "$ACTION" in
    send-message)
        [ -z "$CHANNEL" ] && { echo "Error: --channel required"; exit 1; }
        [ -z "$MESSAGE" ] && { echo "Error: --message required"; exit 1; }
        payload=$(python3 -c "import json; print(json.dumps({'channel':'$CHANNEL','text':'$MESSAGE'}))")
        slack_api POST "chat.postMessage" "$payload" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if data.get('ok'):
    print('✅ Message sent to {}'.format(data.get('channel','')))
    print('   ts: {}'.format(data.get('ts','')))
else:
    print('Error: {}'.format(data.get('error','')))
"
        ;;
    list-channels)
        slack_api GET "conversations.list" "types=public_channel,private_channel&limit=200" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if not data.get('ok'): print('Error:', data.get('error','')); sys.exit(1)
channels = data.get('channels', [])
print('Found {} channels'.format(len(channels)))
print('')
for ch in sorted(channels, key=lambda x: x.get('name','')):
    members = ch.get('num_members', 0)
    priv = '🔒' if ch.get('is_private') else '📢'
    archived = ' [archived]' if ch.get('is_archived') else ''
    print('  {} #{} — {} members{}'.format(priv, ch.get('name',''), members, archived))
    print('     ID: {}'.format(ch.get('id','')))
"
        ;;
    list-members)
        slack_api GET "users.list" "limit=200" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if not data.get('ok'): print('Error:', data.get('error','')); sys.exit(1)
members = [m for m in data.get('members',[]) if not m.get('is_bot') and not m.get('deleted')]
print('Found {} members'.format(len(members)))
print('')
for m in sorted(members, key=lambda x: x.get('real_name','')):
    status = m.get('profile',{}).get('status_emoji','')
    print('  {} {} (@{})'.format(status, m.get('real_name',''), m.get('name','')))
    print('     ID: {} | TZ: {}'.format(m.get('id',''), m.get('tz','')))
"
        ;;
    channel-history)
        [ -z "$CHANNEL" ] && { echo "Error: --channel required"; exit 1; }
        slack_api GET "conversations.history" "channel=$CHANNEL&limit=20" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if not data.get('ok'): print('Error:', data.get('error','')); sys.exit(1)
msgs = data.get('messages', [])
print('Last {} messages:'.format(len(msgs)))
print('')
for msg in reversed(msgs):
    user = msg.get('user', 'bot')
    text = msg.get('text', '')[:200]
    ts = msg.get('ts', '')
    print('  [{}] {}: {}'.format(ts[:10], user, text))
"
        ;;
    search)
        [ -z "$QUERY" ] && { echo "Error: --query required"; exit 1; }
        slack_api GET "search.messages" "query=$QUERY&count=10" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if not data.get('ok'): print('Error:', data.get('error','')); sys.exit(1)
matches = data.get('messages',{}).get('matches',[])
total = data.get('messages',{}).get('total',0)
print('Found {} results (showing {})'.format(total, len(matches)))
print('')
for m in matches:
    channel = m.get('channel',{}).get('name','?')
    user = m.get('username','?')
    text = m.get('text','')[:150]
    print('  #{} — {}: {}'.format(channel, user, text))
    print('')
"
        ;;
    set-topic)
        [ -z "$CHANNEL" ] && { echo "Error: --channel required"; exit 1; }
        [ -z "$MESSAGE" ] && { echo "Error: --message required (topic text)"; exit 1; }
        payload=$(python3 -c "import json; print(json.dumps({'channel':'$CHANNEL','topic':'$MESSAGE'}))")
        slack_api POST "conversations.setTopic" "$payload" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if data.get('ok'):
    print('✅ Topic updated')
else:
    print('Error: {}'.format(data.get('error','')))
"
        ;;
    user-info)
        [ -z "$USER_ID" ] && { echo "Error: --user-id required"; exit 1; }
        slack_api GET "users.info" "user=$USER_ID" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if not data.get('ok'): print('Error:', data.get('error','')); sys.exit(1)
u = data.get('user', {})
p = u.get('profile', {})
print('User: {} (@{})'.format(u.get('real_name',''), u.get('name','')))
print('ID: {}'.format(u.get('id','')))
print('Email: {}'.format(p.get('email','')))
print('Title: {}'.format(p.get('title','')))
print('Status: {} {}'.format(p.get('status_emoji',''), p.get('status_text','')))
print('TZ: {}'.format(u.get('tz','')))
print('Admin: {} | Owner: {}'.format(u.get('is_admin',False), u.get('is_owner',False)))
"
        ;;
    *) echo "Unknown action: $ACTION"; show_help; exit 1;;
esac
