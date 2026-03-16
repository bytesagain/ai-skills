---
version: "2.0.0"
name: Genai Toolbox
description: "MCP Toolbox for Databases is an open source MCP server for databases. genai toolbox, go, agent, agents, ai, bigquery, clickhouse. Use when you need genai toolbox capabilities. Triggers on: genai toolbox."
---

# Genai Toolbox

MCP Toolbox for Databases is an open source MCP server for databases. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from googleapis/genai-toolkit

## Usage

Run any command: `genai-toolkit <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
genai-toolkit help
genai-toolkit run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick genai toolkit from the command line

## Output

Returns structured data to stdout. Redirect to a file with `genai-toolkit run > output.txt`.

## Configuration

Set `GENAI_TOOLKIT_DIR` environment variable to change the data directory. Default: `~/.local/share/genai-toolkit/`
