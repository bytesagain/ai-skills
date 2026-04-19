---
name: "BytesAgain MCP"
description: "Connect AI agents to BytesAgain skill search via MCP SSE. Shows setup commands for OpenClaw, Claude Desktop, and curl. No files modified."
version: "1.1.0"
author: "bytesagain-lab"
tags: ["mcp", "skills", "agent", "openclaw", "setup"]
---

# BytesAgain MCP

Connect your AI agent to BytesAgain skill search via MCP SSE protocol. Works with OpenClaw, Claude Desktop, and any MCP-compatible client.

**MCP SSE:** `https://bytesagain.com/api/mcp/sse` (streamable-http)
**REST API:** `https://bytesagain.com/api/mcp?action=search&q=<query>` (sandbox-friendly)
**Auth:** none required
**Languages:** English, Chinese, Japanese, Korean, German, French, Portuguese, Spanish

## Commands

### setup
Show MCP connection commands for your client.

```bash
bash scripts/script.sh setup
```

### setup --client openclaw
Show OpenClaw setup command.

```bash
bash scripts/script.sh setup --client openclaw
```

### setup --client claude
Show Claude Desktop config JSON.

```bash
bash scripts/script.sh setup --client claude
```

### test
Test the MCP endpoint is reachable and responding.

```bash
bash scripts/script.sh test
```

### tools
List available MCP tools exposed by BytesAgain.

```bash
bash scripts/script.sh tools
```

## Available MCP Tools

Once connected, your agent can call:

| Tool | Description |
|------|-------------|
| `search_skills` | Search 788+ BytesAgain skills by keyword |
| `get_skill` | Get full details + install command for a skill |
| `popular_skills` | Top skills ranked by downloads |

## Requirements

- curl
- python3 (for JSON formatting)

## Notes

- After registering, restart your gateway and start a **new session** to activate tools
- Only returns skills published by BytesAgain authors
- Free, no API key needed
- Docs: https://bytesagain.com/mcp
