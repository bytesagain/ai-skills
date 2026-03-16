#!/usr/bin/env bash
# Notion Powertools — Manage Notion workspace via API
# Usage: bash main.sh --action <action> --token <token> [options]
set -euo pipefail

ACTION=""
TOKEN="${NOTION_TOKEN:-}"
DATABASE_ID=""
PAGE_ID=""
TITLE=""
CONTENT=""
QUERY=""
OUTPUT=""

show_help() {
    cat << 'HELPEOF'
Notion Powertools — Full Notion API toolkit

Usage: bash main.sh --action <action> --token <token> [options]

Actions:
  list-databases       List all databases
  query-database       Query a database (--database-id)
  create-page          Create a page (--database-id --title --content)
  get-page             Get page details (--page-id)
  update-page          Update a page (--page-id --title)
  search               Search workspace (--query)
  list-blocks          List page blocks (--page-id)
  append-block         Append content to page (--page-id --content)

Options:
  --token <token>      Notion API token (or set NOTION_TOKEN env)
  --database-id <id>   Database ID
  --page-id <id>       Page ID
  --title <title>      Page title
  --content <text>     Page content / block content
  --query <text>       Search query
  --output <file>      Save output to file

Examples:
  bash main.sh --action search --query "meeting notes" --token secret_xxx
  bash main.sh --action list-databases --token secret_xxx
  bash main.sh --action create-page --database-id abc123 --title "New Page" --content "Hello"
  bash main.sh --action query-database --database-id abc123

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --action) ACTION="$2"; shift 2;;
        --token) TOKEN="$2"; shift 2;;
        --database-id) DATABASE_ID="$2"; shift 2;;
        --page-id) PAGE_ID="$2"; shift 2;;
        --title) TITLE="$2"; shift 2;;
        --content) CONTENT="$2"; shift 2;;
        --query) QUERY="$2"; shift 2;;
        --output) OUTPUT="$2"; shift 2;;
        --help|-h) show_help; exit 0;;
        *) echo "Unknown: $1"; shift;;
    esac
done

[ -z "$ACTION" ] && { echo "Error: --action required"; show_help; exit 1; }
[ -z "$TOKEN" ] && { echo "Error: --token required (or set NOTION_TOKEN env)"; exit 1; }

API="https://api.notion.com/v1"
NOTION_VERSION="2022-06-28"

notion_api() {
    local method="$1" endpoint="$2" data="${3:-}"
    local url="$API/$endpoint"
    local args=(-s -X "$method" "$url"
        -H "Authorization: Bearer $TOKEN"
        -H "Notion-Version: $NOTION_VERSION"
        -H "Content-Type: application/json")
    [ -n "$data" ] && args+=(-d "$data")
    curl "${args[@]}" 2>/dev/null
}

format_output() {
    python3 << 'PYEOF'
import json, sys
try:
    data = json.load(sys.stdin)
except:
    print("Error: Invalid JSON response")
    sys.exit(1)

if "object" in data and data["object"] == "error":
    print("Error: {} — {}".format(data.get("code","?"), data.get("message","?")))
    sys.exit(1)

def extract_title(props):
    for key, val in props.items():
        if val.get("type") == "title":
            texts = val.get("title", [])
            return "".join(t.get("plain_text","") for t in texts)
    return "(untitled)"

if data.get("object") == "list":
    results = data.get("results", [])
    print("Found {} items".format(len(results)))
    print("")
    for item in results:
        obj_type = item.get("object", "?")
        item_id = item.get("id", "?")
        if obj_type == "database":
            title_parts = item.get("title", [])
            title = "".join(t.get("plain_text","") for t in title_parts)
            print("  [DB] {} — {}".format(title, item_id))
        elif obj_type == "page":
            props = item.get("properties", {})
            title = extract_title(props)
            print("  [Page] {} — {}".format(title, item_id))
        else:
            print("  [{}] {}".format(obj_type, item_id))

elif data.get("object") == "page":
    props = data.get("properties", {})
    title = extract_title(props)
    print("Page: {}".format(title))
    print("ID: {}".format(data.get("id","")))
    print("URL: {}".format(data.get("url","")))
    print("Created: {}".format(data.get("created_time","")))
    print("Updated: {}".format(data.get("last_edited_time","")))
    print("")
    print("Properties:")
    for key, val in props.items():
        vtype = val.get("type", "?")
        if vtype == "title":
            texts = val.get("title", [])
            print("  {}: {}".format(key, "".join(t.get("plain_text","") for t in texts)))
        elif vtype == "rich_text":
            texts = val.get("rich_text", [])
            print("  {}: {}".format(key, "".join(t.get("plain_text","") for t in texts)))
        elif vtype == "number":
            print("  {}: {}".format(key, val.get("number","")))
        elif vtype == "select":
            sel = val.get("select")
            print("  {}: {}".format(key, sel.get("name","") if sel else ""))
        elif vtype == "date":
            dt = val.get("date")
            print("  {}: {}".format(key, dt.get("start","") if dt else ""))
        elif vtype == "checkbox":
            print("  {}: {}".format(key, val.get("checkbox","")))
        else:
            print("  {}: [{}]".format(key, vtype))

elif data.get("object") == "block":
    print("Block: {} ({})".format(data.get("id",""), data.get("type","")))

else:
    print(json.dumps(data, indent=2)[:2000])
PYEOF
}

run_action() {
    case "$ACTION" in
        search)
            [ -z "$QUERY" ] && QUERY=""
            notion_api POST "search" "{\"query\": \"$QUERY\"}" | format_output
            ;;
        list-databases)
            notion_api POST "search" '{"filter": {"value": "database", "property": "object"}}' | format_output
            ;;
        query-database)
            [ -z "$DATABASE_ID" ] && { echo "Error: --database-id required"; exit 1; }
            notion_api POST "databases/$DATABASE_ID/query" '{}' | format_output
            ;;
        create-page)
            [ -z "$DATABASE_ID" ] && { echo "Error: --database-id required"; exit 1; }
            [ -z "$TITLE" ] && { echo "Error: --title required"; exit 1; }
            local payload
            payload=$(python3 -c "
import json
data = {
    'parent': {'database_id': '$DATABASE_ID'},
    'properties': {
        'Name': {'title': [{'text': {'content': '$TITLE'}}]}
    }
}
if '$CONTENT':
    data['children'] = [
        {'object': 'block', 'type': 'paragraph',
         'paragraph': {'rich_text': [{'text': {'content': '$CONTENT'}}]}}
    ]
print(json.dumps(data))
")
            notion_api POST "pages" "$payload" | format_output
            ;;
        get-page)
            [ -z "$PAGE_ID" ] && { echo "Error: --page-id required"; exit 1; }
            notion_api GET "pages/$PAGE_ID" | format_output
            ;;
        update-page)
            [ -z "$PAGE_ID" ] && { echo "Error: --page-id required"; exit 1; }
            local payload="{\"properties\": {\"Name\": {\"title\": [{\"text\": {\"content\": \"$TITLE\"}}]}}}"
            notion_api PATCH "pages/$PAGE_ID" "$payload" | format_output
            ;;
        list-blocks)
            [ -z "$PAGE_ID" ] && { echo "Error: --page-id required"; exit 1; }
            notion_api GET "blocks/$PAGE_ID/children" | format_output
            ;;
        append-block)
            [ -z "$PAGE_ID" ] && { echo "Error: --page-id required"; exit 1; }
            [ -z "$CONTENT" ] && { echo "Error: --content required"; exit 1; }
            local payload="{\"children\": [{\"object\": \"block\", \"type\": \"paragraph\", \"paragraph\": {\"rich_text\": [{\"text\": {\"content\": \"$CONTENT\"}}]}}]}"
            notion_api PATCH "blocks/$PAGE_ID/children" "$payload" | format_output
            ;;
        *)
            echo "Unknown action: $ACTION"
            show_help
            exit 1
            ;;
    esac
}

result=$(run_action)
if [ -n "$OUTPUT" ]; then
    echo "$result" > "$OUTPUT"
    echo "Saved to $OUTPUT"
else
    echo "$result"
fi
