#!/usr/bin/env bash
# Discord Toolkit — Manage Discord servers via Bot API
# Usage: bash main.sh --action <action> --token <token> [options]
set -euo pipefail

ACTION="" TOKEN="${DISCORD_TOKEN:-}" GUILD_ID="" CHANNEL_ID="" MESSAGE="" USER_ID="" OUTPUT=""

show_help() { cat << 'HELPEOF'
Discord Toolkit — Full Discord Bot API toolkit

Usage: bash main.sh --action <action> --token <token> [options]

Actions: send-message, list-guilds, list-channels, list-members, channel-messages,
         create-channel, delete-message, get-user, guild-info, send-embed

Options:
  --token <token>      Bot token (or DISCORD_TOKEN env)
  --guild-id <id>      Server/Guild ID
  --channel-id <id>    Channel ID
  --message <text>     Message content
  --user-id <id>       User ID
  --output <file>      Save to file

Examples:
  bash main.sh --action list-guilds --token Bot_xxx
  bash main.sh --action send-message --channel-id 123 --message "Hello!"
  bash main.sh --action list-channels --guild-id 456
  bash main.sh --action send-embed --channel-id 123 --message "Title|Description|#ff0000"

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --action) ACTION="$2"; shift 2;; --token) TOKEN="$2"; shift 2;;
        --guild-id) GUILD_ID="$2"; shift 2;; --channel-id) CHANNEL_ID="$2"; shift 2;;
        --message) MESSAGE="$2"; shift 2;; --user-id) USER_ID="$2"; shift 2;;
        --output) OUTPUT="$2"; shift 2;; --help|-h) show_help; exit 0;; *) shift;;
    esac
done

[ -z "$ACTION" ] && { echo "Error: --action required"; show_help; exit 1; }
[ -z "$TOKEN" ] && { echo "Error: --token required"; exit 1; }

API="https://discord.com/api/v10"

discord_api() {
    local method="$1" endpoint="$2" data="${3:-}"
    local args=(-s -X "$method" "$API/$endpoint" -H "Authorization: Bot $TOKEN" -H "Content-Type: application/json")
    [ -n "$data" ] && args+=(-d "$data")
    curl "${args[@]}" 2>/dev/null
}

case "$ACTION" in
    list-guilds)
        discord_api GET "users/@me/guilds" | python3 -c "
import json, sys
guilds = json.load(sys.stdin)
if isinstance(guilds, dict) and 'message' in guilds:
    print('Error:', guilds['message']); sys.exit(1)
print('Found {} servers'.format(len(guilds)))
for g in guilds:
    owner = ' 👑' if g.get('owner') else ''
    print('  {} — {}{}'.format(g.get('name',''), g.get('id',''), owner))
    members = g.get('approximate_member_count')
    if members: print('     Members: {}'.format(members))
"
        ;;
    list-channels)
        [ -z "$GUILD_ID" ] && { echo "Error: --guild-id required"; exit 1; }
        discord_api GET "guilds/$GUILD_ID/channels" | python3 -c "
import json, sys
channels = json.load(sys.stdin)
if isinstance(channels, dict) and 'message' in channels:
    print('Error:', channels['message']); sys.exit(1)
types = {0:'💬text', 2:'🔊voice', 4:'📁category', 5:'📢news', 13:'🎤stage', 15:'📋forum'}
for ch in sorted(channels, key=lambda x: (x.get('position',0))):
    t = types.get(ch.get('type',0), '?')
    print('  {} #{} — {}'.format(t, ch.get('name',''), ch.get('id','')))
"
        ;;
    send-message)
        [ -z "$CHANNEL_ID" ] && { echo "Error: --channel-id required"; exit 1; }
        [ -z "$MESSAGE" ] && { echo "Error: --message required"; exit 1; }
        payload=$(python3 -c "import json; print(json.dumps({'content':'$MESSAGE'}))")
        discord_api POST "channels/$CHANNEL_ID/messages" "$payload" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'id' in data: print('✅ Message sent (ID: {})'.format(data['id']))
else: print('Error:', data.get('message',''))
"
        ;;
    send-embed)
        [ -z "$CHANNEL_ID" ] && { echo "Error: --channel-id required"; exit 1; }
        [ -z "$MESSAGE" ] && { echo "Error: --message required (Title|Description|Color)"; exit 1; }
        payload=$(python3 -c "
import json
parts = '$MESSAGE'.split('|')
embed = {'title': parts[0]}
if len(parts) > 1: embed['description'] = parts[1]
if len(parts) > 2:
    try: embed['color'] = int(parts[2].lstrip('#'), 16)
    except: pass
embed['footer'] = {'text': 'Powered by BytesAgain'}
print(json.dumps({'embeds': [embed]}))
")
        discord_api POST "channels/$CHANNEL_ID/messages" "$payload" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'id' in data: print('✅ Embed sent (ID: {})'.format(data['id']))
else: print('Error:', data.get('message',''))
"
        ;;
    channel-messages)
        [ -z "$CHANNEL_ID" ] && { echo "Error: --channel-id required"; exit 1; }
        discord_api GET "channels/$CHANNEL_ID/messages?limit=20" | python3 -c "
import json, sys
msgs = json.load(sys.stdin)
if isinstance(msgs, dict) and 'message' in msgs:
    print('Error:', msgs['message']); sys.exit(1)
print('Last {} messages:'.format(len(msgs)))
for m in reversed(msgs):
    author = m.get('author',{}).get('username','?')
    content = m.get('content','')[:200]
    ts = m.get('timestamp','')[:16]
    print('  [{}] {}: {}'.format(ts, author, content))
"
        ;;
    list-members)
        [ -z "$GUILD_ID" ] && { echo "Error: --guild-id required"; exit 1; }
        discord_api GET "guilds/$GUILD_ID/members?limit=100" | python3 -c "
import json, sys
members = json.load(sys.stdin)
if isinstance(members, dict) and 'message' in members:
    print('Error:', members['message']); sys.exit(1)
print('Found {} members'.format(len(members)))
for m in members:
    user = m.get('user', {})
    nick = m.get('nick') or user.get('global_name') or user.get('username','?')
    print('  {} (@{}) — {}'.format(nick, user.get('username',''), user.get('id','')))
"
        ;;
    guild-info)
        [ -z "$GUILD_ID" ] && { echo "Error: --guild-id required"; exit 1; }
        discord_api GET "guilds/$GUILD_ID?with_counts=true" | python3 -c "
import json, sys
g = json.load(sys.stdin)
if 'message' in g: print('Error:', g['message']); sys.exit(1)
print('Server: {}'.format(g.get('name','')))
print('ID: {}'.format(g.get('id','')))
print('Owner: {}'.format(g.get('owner_id','')))
print('Members: ~{}'.format(g.get('approximate_member_count','?')))
print('Online: ~{}'.format(g.get('approximate_presence_count','?')))
print('Boosts: {} (Tier {})'.format(g.get('premium_subscription_count',0), g.get('premium_tier',0)))
print('Created: {}'.format(g.get('id','')))
"
        ;;
    get-user)
        uid="${USER_ID:-@me}"
        discord_api GET "users/$uid" | python3 -c "
import json, sys
u = json.load(sys.stdin)
if 'message' in u: print('Error:', u['message']); sys.exit(1)
print('User: {} (@{})'.format(u.get('global_name',''), u.get('username','')))
print('ID: {}'.format(u.get('id','')))
print('Bot: {}'.format(u.get('bot', False)))
"
        ;;
    create-channel)
        [ -z "$GUILD_ID" ] && { echo "Error: --guild-id required"; exit 1; }
        [ -z "$MESSAGE" ] && { echo "Error: --message required (channel name)"; exit 1; }
        payload=$(python3 -c "import json; print(json.dumps({'name':'$MESSAGE','type':0}))")
        discord_api POST "guilds/$GUILD_ID/channels" "$payload" | python3 -c "
import json, sys
ch = json.load(sys.stdin)
if 'id' in ch: print('✅ Channel created: #{} ({})'.format(ch.get('name',''), ch.get('id','')))
else: print('Error:', ch.get('message',''))
"
        ;;
    *) echo "Unknown action: $ACTION"; show_help; exit 1;;
esac
