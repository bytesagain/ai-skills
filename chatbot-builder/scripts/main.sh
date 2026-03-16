#!/usr/bin/env bash
# Telegram Bot Builder — Manage Telegram bots via Bot API
# Usage: bash main.sh --action <action> --token <token> [options]
set -euo pipefail

ACTION="" TOKEN="${TELEGRAM_BOT_TOKEN:-}" CHAT_ID="" MESSAGE="" PARSE_MODE="HTML" FILE_PATH="" OUTPUT=""

show_help() { cat << 'HELPEOF'
Telegram Bot Builder — Full Telegram Bot API toolkit

Usage: bash main.sh --action <action> --token <token> [options]

Actions: send-message, get-me, get-updates, set-webhook, delete-webhook,
         send-photo, send-document, get-chat, get-members, set-commands,
         pin-message, forward-message

Options:
  --token <token>      Bot token (or TELEGRAM_BOT_TOKEN env)
  --chat-id <id>       Chat/Group/Channel ID
  --message <text>     Message text (supports HTML)
  --parse-mode <mode>  Parse mode: HTML, Markdown, MarkdownV2
  --file <path>        File path for uploads
  --output <file>      Save to file

Examples:
  bash main.sh --action get-me --token 123:ABC
  bash main.sh --action send-message --chat-id 123456 --message "<b>Hello!</b>"
  bash main.sh --action get-updates
  bash main.sh --action set-commands --message "start:Start bot,help:Get help,status:Check status"
  bash main.sh --action set-webhook --message "https://example.com/webhook"

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --action) ACTION="$2"; shift 2;; --token) TOKEN="$2"; shift 2;;
        --chat-id) CHAT_ID="$2"; shift 2;; --message) MESSAGE="$2"; shift 2;;
        --parse-mode) PARSE_MODE="$2"; shift 2;; --file) FILE_PATH="$2"; shift 2;;
        --output) OUTPUT="$2"; shift 2;; --help|-h) show_help; exit 0;; *) shift;;
    esac
done

[ -z "$ACTION" ] && { echo "Error: --action required"; show_help; exit 1; }
[ -z "$TOKEN" ] && { echo "Error: --token required"; exit 1; }

API="https://api.telegram.org/bot$TOKEN"

tg_api() {
    local method="$1" data="${2:-}"
    if [ -n "$data" ]; then
        curl -s -X POST "$API/$method" -H "Content-Type: application/json" -d "$data" 2>/dev/null
    else
        curl -s "$API/$method" 2>/dev/null
    fi
}

check_ok() {
    python3 -c "
import json, sys
data = json.load(sys.stdin)
if not data.get('ok'):
    print('Error: {}'.format(data.get('description', 'Unknown error')))
    sys.exit(1)
result = data.get('result', data)
if isinstance(result, dict):
    for k, v in result.items():
        if isinstance(v, (dict, list)):
            import json as j
            print('{}: {}'.format(k, j.dumps(v, ensure_ascii=False)[:200]))
        else:
            print('{}: {}'.format(k, v))
elif isinstance(result, list):
    print('Items: {}'.format(len(result)))
    for item in result[:10]:
        if isinstance(item, dict):
            msg = item.get('message', {})
            if msg:
                chat = msg.get('chat', {})
                text = msg.get('text', '')[:100]
                print('  [{}] {}: {}'.format(
                    msg.get('date',''), 
                    msg.get('from',{}).get('first_name','?'),
                    text))
            else:
                print('  {}'.format(str(item)[:200]))
else:
    print(result)
"
}

case "$ACTION" in
    get-me)
        tg_api "getMe" | check_ok
        ;;
    get-updates)
        tg_api "getUpdates?limit=10" | check_ok
        ;;
    send-message)
        [ -z "$CHAT_ID" ] && { echo "Error: --chat-id required"; exit 1; }
        [ -z "$MESSAGE" ] && { echo "Error: --message required"; exit 1; }
        payload=$(python3 -c "
import json
print(json.dumps({
    'chat_id': '$CHAT_ID',
    'text': '''$MESSAGE''',
    'parse_mode': '$PARSE_MODE'
}))
")
        tg_api "sendMessage" "$payload" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if data.get('ok'):
    msg = data['result']
    print('✅ Message sent (ID: {})'.format(msg.get('message_id','')))
    print('   Chat: {} ({})'.format(msg.get('chat',{}).get('title', msg.get('chat',{}).get('first_name','')), msg.get('chat',{}).get('id','')))
else:
    print('Error:', data.get('description',''))
"
        ;;
    send-photo)
        [ -z "$CHAT_ID" ] && { echo "Error: --chat-id required"; exit 1; }
        [ -z "$FILE_PATH" ] && { echo "Error: --file required"; exit 1; }
        curl -s -X POST "$API/sendPhoto" -F "chat_id=$CHAT_ID" -F "photo=@$FILE_PATH" ${MESSAGE:+-F "caption=$MESSAGE"} 2>/dev/null | check_ok
        ;;
    send-document)
        [ -z "$CHAT_ID" ] && { echo "Error: --chat-id required"; exit 1; }
        [ -z "$FILE_PATH" ] && { echo "Error: --file required"; exit 1; }
        curl -s -X POST "$API/sendDocument" -F "chat_id=$CHAT_ID" -F "document=@$FILE_PATH" ${MESSAGE:+-F "caption=$MESSAGE"} 2>/dev/null | check_ok
        ;;
    set-webhook)
        [ -z "$MESSAGE" ] && { echo "Error: --message required (webhook URL)"; exit 1; }
        tg_api "setWebhook" "{\"url\":\"$MESSAGE\"}" | check_ok
        ;;
    delete-webhook)
        tg_api "deleteWebhook" | check_ok
        ;;
    get-chat)
        [ -z "$CHAT_ID" ] && { echo "Error: --chat-id required"; exit 1; }
        tg_api "getChat" "{\"chat_id\":\"$CHAT_ID\"}" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if not data.get('ok'): print('Error:', data.get('description','')); sys.exit(1)
chat = data['result']
print('Chat: {}'.format(chat.get('title', chat.get('first_name',''))))
print('ID: {}'.format(chat.get('id','')))
print('Type: {}'.format(chat.get('type','')))
if chat.get('description'): print('Description: {}'.format(chat['description']))
if chat.get('username'): print('Username: @{}'.format(chat['username']))
members = chat.get('active_usernames', [])
if members: print('Usernames: {}'.format(', '.join(members)))
"
        ;;
    get-members)
        [ -z "$CHAT_ID" ] && { echo "Error: --chat-id required"; exit 1; }
        tg_api "getChatMemberCount" "{\"chat_id\":\"$CHAT_ID\"}" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if data.get('ok'): print('Members: {}'.format(data['result']))
else: print('Error:', data.get('description',''))
"
        ;;
    set-commands)
        [ -z "$MESSAGE" ] && { echo "Error: --message required (cmd1:desc1,cmd2:desc2)"; exit 1; }
        payload=$(python3 -c "
import json
cmds = []
for pair in '$MESSAGE'.split(','):
    parts = pair.strip().split(':',1)
    if len(parts) == 2:
        cmds.append({'command': parts[0].strip(), 'description': parts[1].strip()})
print(json.dumps({'commands': cmds}))
")
        tg_api "setMyCommands" "$payload" | check_ok
        echo "✅ Bot commands updated"
        ;;
    pin-message)
        [ -z "$CHAT_ID" ] && { echo "Error: --chat-id required"; exit 1; }
        [ -z "$MESSAGE" ] && { echo "Error: --message required (message_id)"; exit 1; }
        tg_api "pinChatMessage" "{\"chat_id\":\"$CHAT_ID\",\"message_id\":$MESSAGE}" | check_ok
        ;;
    *) echo "Unknown action: $ACTION"; show_help; exit 1;;
esac
