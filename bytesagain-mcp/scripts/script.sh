#!/usr/bin/env bash
# BytesAgain MCP — show MCP connection setup commands
set -euo pipefail

MCP_URL="https://bytesagain.com/api/mcp/sse"
DOCS_URL="https://bytesagain.com/mcp"

cmd_setup() {
    local client="${1:-all}"

    case "$client" in
        openclaw|--client)
            # handle --client openclaw
            shift || true
            local c="${1:-all}"
            cmd_setup "$c"
            return
            ;;
    esac

    if [[ "$client" == "openclaw" ]]; then
        echo "=== OpenClaw Setup ==="
        echo ""
        echo "Run this command:"
        echo ""
        echo "  openclaw mcp set bytesagain '{\"url\":\"${MCP_URL}\",\"transport\":\"streamable-http\"}'"
        echo ""
        echo "Then restart your gateway and start a new session."
    elif [[ "$client" == "claude" ]]; then
        echo "=== Claude Desktop Setup ==="
        echo ""
        echo "Add to ~/Library/Application Support/Claude/claude_desktop_config.json:"
        echo ""
        cat << 'JSON'
{
  "mcpServers": {
    "bytesagain": {
      "url": "https://bytesagain.com/api/mcp/sse",
      "transport": "streamable-http"
    }
  }
}
JSON
        echo ""
        echo "Then restart Claude Desktop."
    else
        echo "=== BytesAgain MCP Setup ==="
        echo ""
        echo "Endpoint: ${MCP_URL}"
        echo "Transport: streamable-http"
        echo "Auth: none"
        echo ""
        echo "--- OpenClaw ---"
        echo "  openclaw mcp set bytesagain '{\"url\":\"${MCP_URL}\",\"transport\":\"streamable-http\"}'"
        echo ""
        echo "--- Claude Desktop ---"
        echo "  Add to claude_desktop_config.json:"
        echo '  {"mcpServers":{"bytesagain":{"url":"'"${MCP_URL}"'","transport":"streamable-http"}}}'
        echo ""
        echo "--- curl (JSON-RPC) ---"
        echo "  curl -X POST ${MCP_URL} \\"
        echo "    -H 'Content-Type: application/json' \\"
        echo "    -d '{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"tools/list\",\"params\":{}}'"
        echo ""
        echo "Docs: ${DOCS_URL}"
    fi
}

cmd_test() {
    echo "Testing BytesAgain MCP endpoint..."
    echo ""

    response=$(curl -s -w "\n%{http_code}" -X POST "${MCP_URL}" \
        -H "Content-Type: application/json" \
        -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' \
        --max-time 10 2>/dev/null)

    http_code=$(echo "$response" | tail -1)
    body=$(echo "$response" | head -1)

    if [[ "$http_code" == "200" ]]; then
        echo "✅ MCP endpoint reachable (HTTP ${http_code})"
        if echo "$body" | python3 -c "import json,sys; d=json.load(sys.stdin); print('✅ Protocol:', d['result']['protocolVersion'])" 2>/dev/null; then
            :
        else
            echo "Response: ${body}"
        fi
    else
        echo "❌ Endpoint returned HTTP ${http_code}"
        echo "Response: ${body}"
        exit 1
    fi
}

cmd_tools() {
    echo "Fetching available MCP tools..."
    echo ""

    tmpfile=$(mktemp)
    curl -s -X POST "${MCP_URL}" \
        -H "Content-Type: application/json" \
        -d '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}' \
        --max-time 10 2>/dev/null > "$tmpfile"

    python3 - "$tmpfile" << 'PYEOF'
import json, sys
try:
    with open(sys.argv[1]) as f:
        d = json.load(f)
    tools = d.get("result", {}).get("tools", [])
    print(f"Found {len(tools)} tools:")
    print()
    for t in tools:
        print(f'  {t["name"]}')
        print(f'    {t["description"]}')
        print()
except Exception as e:
    print(f"Parse error: {e}")
    sys.exit(1)
PYEOF
    rm -f "$tmpfile"
}


REST_URL="https://bytesagain.com/api/mcp"

cmd_rest() {
    echo "=== BytesAgain REST API (Sandbox-friendly) ==="
    echo ""
    echo "No SSE needed. Works in any environment including sandboxes."
    echo ""
    echo "Search skills:"
    echo "  curl '${REST_URL}?action=search&q=email+automation&limit=10'"
    echo ""
    echo "Get skill details:"
    echo "  curl '${REST_URL}?action=get&slug=<slug>'"
    echo ""
    echo "Popular skills:"
    echo "  curl '${REST_URL}?action=popular&limit=20'"
    echo ""
    echo "Supports 7 languages: ZH/JA/KO/DE/FR/PT/ES"
    echo "Example (Chinese): curl '${REST_URL}?action=search&q=%E9%82%AE%E4%BB%B6%E8%87%AA%E5%8A%A8%E5%8C%96'"
}

cmd_search() {
    local q="${1:-}"
    if [[ -z "$q" ]]; then
        echo "Usage: bash scripts/script.sh search <keyword>"
        exit 1
    fi
    local encoded
    encoded=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$q")
    echo "Searching: $q"
    echo ""
    tmpfile=$(mktemp)
    curl -s "${REST_URL}?action=search&q=${encoded}&limit=5" > "$tmpfile"
    python3 - "$tmpfile" << 'PYEOF'
import json, sys
with open(sys.argv[1]) as f:
    d = json.load(f)
t = d.get('translated_query','')
if t: print(f"Translated: {t}\n")
print(f"Found {d.get('count',0)} results:")
for r in d.get('results',[]):
    print(f"  [{r.get('downloads',0)}dl] {r['name']} — {r['slug']}")
PYEOF
    rm -f "$tmpfile"
}

# ── Main ──────────────────────────────────────────────────────
COMMAND="${1:-setup}"
shift || true

case "$COMMAND" in
    setup)   cmd_setup "$@" ;;
    test)    cmd_test ;;
    tools)   cmd_tools ;;
    rest)    cmd_rest ;;
    search)  cmd_search "$@" ;;
    --help|-h|help)
        echo "Usage: bash scripts/script.sh <command>"
        echo ""
        echo "Commands:"
        echo "  setup                  Show all client setup commands"
        echo "  setup --client openclaw  OpenClaw setup"
        echo "  setup --client claude    Claude Desktop setup"
        echo "  test                   Test MCP endpoint connectivity"
        echo "  tools                  List available MCP tools"
  echo "  rest                   Show REST API usage (sandbox-friendly)"
  echo "  search <keyword>       Search skills via REST API"
        echo ""
        echo "Docs: ${DOCS_URL}"
        ;;
    *)
        echo "Unknown command: $COMMAND"
        echo "Run: bash scripts/script.sh --help"
        exit 1
        ;;
esac
