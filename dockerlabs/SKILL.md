---
name: Dockerlabs
description: "Learn Docker hands-on with tutorials on containers and orchestration. Use when studying Docker, practicing networking, exploring swarm mode."
version: "1.0.0"
license: Apache-2.0
runtime: python3
---

# Dockerlabs

Devtools toolkit for Docker-related workflows — check, validate, generate, format, lint, explain, convert, template, diff, preview, fix, and report on Docker configurations. All entries are logged locally with timestamps for full traceability.

## Commands

| Command | Description |
|---------|-------------|
| `dockerlabs check <input>` | Check a Docker configuration or record a check entry |
| `dockerlabs validate <input>` | Validate a Docker setup or record a validation entry |
| `dockerlabs generate <input>` | Generate Docker artifacts or record a generation entry |
| `dockerlabs format <input>` | Format Docker files or record a format entry |
| `dockerlabs lint <input>` | Lint Dockerfiles or record a lint entry |
| `dockerlabs explain <input>` | Explain Docker concepts or record an explanation entry |
| `dockerlabs convert <input>` | Convert Docker configurations or record a conversion entry |
| `dockerlabs template <input>` | Manage Docker templates or record a template entry |
| `dockerlabs diff <input>` | Diff Docker configurations or record a diff entry |
| `dockerlabs preview <input>` | Preview Docker setups or record a preview entry |
| `dockerlabs fix <input>` | Fix Docker issues or record a fix entry |
| `dockerlabs report <input>` | Generate reports or record a report entry |
| `dockerlabs stats` | Show summary statistics across all entry types |
| `dockerlabs export <fmt>` | Export all data (json, csv, or txt) |
| `dockerlabs search <term>` | Search across all log entries |
| `dockerlabs recent` | Show the 20 most recent activity entries |
| `dockerlabs status` | Health check — version, data dir, entry count, disk usage |
| `dockerlabs help` | Show help with all available commands |
| `dockerlabs version` | Show current version (v2.0.0) |

Each command (check, validate, generate, format, lint, explain, convert, template, diff, preview, fix, report) works in two modes:
- **No arguments**: displays the 20 most recent entries from that command's log
- **With arguments**: records the input with a timestamp and appends to the command's log file

## Data Storage

All data is stored locally at `~/.local/share/dockerlabs/`. Each action is logged to its own file (e.g., `check.log`, `lint.log`, `generate.log`). A unified `history.log` tracks all operations. Use `export` to back up your data anytime in JSON, CSV, or plain text format.

## Requirements

- bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities (`wc`, `du`, `grep`, `tail`, `sed`, `date`)

## When to Use

- Tracking Docker configuration checks, validations, and linting results
- Logging Docker file generation, conversion, and formatting operations
- Keeping an audit trail of Docker troubleshooting and fixes
- Exporting Docker operation history for reporting or compliance
- Searching past Docker operations by keyword

## Examples

```bash
# Record a Dockerfile lint result
dockerlabs lint "Dockerfile uses latest tag — pin to specific version"

# Record a validation check
dockerlabs validate "docker-compose.yml syntax OK, 3 services defined"

# Generate a template entry
dockerlabs generate "multi-stage build for Node.js app"

# View recent lint entries
dockerlabs lint

# Search for entries mentioning "nginx"
dockerlabs search nginx

# Export all data as JSON
dockerlabs export json

# Check overall health
dockerlabs status

# View summary stats
dockerlabs stats
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
