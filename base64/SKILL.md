---
name: Base64
description: "Encode and decode Base64 strings and files from the terminal. Use when encoding binary data, decoding API payloads, or converting file content."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["base64","encode","decode","developer","data","utility"]
categories: ["Developer Tools", "Utility"]
---

# Base64

Utility toolkit for logging, tracking, and managing data entries. Each command records timestamped entries to individual log files and supports viewing recent entries, searching, exporting, and statistics.

## Commands

| Command | Description |
|---------|-------------|
| `base64 run <input>` | Record a run entry; without args shows recent run entries |
| `base64 check <input>` | Record a check entry; without args shows recent check entries |
| `base64 convert <input>` | Record a convert entry; without args shows recent convert entries |
| `base64 analyze <input>` | Record an analyze entry; without args shows recent analyze entries |
| `base64 generate <input>` | Record a generate entry; without args shows recent generate entries |
| `base64 preview <input>` | Record a preview entry; without args shows recent preview entries |
| `base64 batch <input>` | Record a batch entry; without args shows recent batch entries |
| `base64 compare <input>` | Record a compare entry; without args shows recent compare entries |
| `base64 export <input>` | Record an export entry; without args shows recent export entries |
| `base64 config <input>` | Record a config entry; without args shows recent config entries |
| `base64 status <input>` | Record a status entry; without args shows recent status entries |
| `base64 report <input>` | Record a report entry; without args shows recent report entries |
| `base64 stats` | Show summary statistics across all log files (entry counts, data size) |
| `base64 search <term>` | Search all log files for a term (case-insensitive) |
| `base64 recent` | Show last 20 lines from history.log |
| `base64 help` | Show help message with all available commands |
| `base64 version` | Show version (v2.0.0) |

Note: The script also defines internal `_export <fmt>` (json/csv/txt) and `_status` health check functions, but the case-branch commands for `export` and `status` take priority and operate as log entry recorders.

## Data Storage

Data stored in `~/.local/share/base64/`

Each command writes timestamped entries to its own `.log` file (e.g., `run.log`, `convert.log`). All actions are also recorded in `history.log`.

## Requirements

- Bash 4+

## When to Use

- Tracking and logging various data processing operations with timestamps
- Searching across historical log entries for specific terms
- Reviewing recent activity across all command categories
- Getting summary statistics on logged data volume and disk usage
- Recording conversion, analysis, and batch processing activities

## Examples

```bash
# Record a convert entry
base64 convert "encoded payload.json to base64"

# Search all logs for a keyword
base64 search "payload"

# View summary stats across all log categories
base64 stats

# Show last 20 history entries
base64 recent
```

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
