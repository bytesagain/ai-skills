---
version: "2.0.0"
name: Brook
description: "Configure cross-platform proxy and VPN tunnels with programmable rules. Use when setting up SOCKS proxies, bypassing firewalls, or routing traffic."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Brook

Brook v2.0.0 — a multi-purpose utility tool for managing network configuration data, tracking entries, and organizing proxy/VPN tunnel information from the command line.

## Why Brook?

- Lightweight CLI tool for managing proxy and tunnel configuration data
- No external dependencies, accounts, or API keys needed
- Local-first storage — all your data stays on your machine
- Simple subcommand interface for adding, listing, searching, and exporting entries
- Works on any system with Bash

## Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `run` | `brook run <args>` | Execute the main function and log the action |
| `config` | `brook config` | Show configuration file path |
| `status` | `brook status` | Show current tool status (ready/not ready) |
| `init` | `brook init` | Initialize the data directory |
| `list` | `brook list` | List all entries from the data log |
| `add` | `brook add <entry>` | Add a new entry to the data log (timestamped) |
| `remove` | `brook remove <entry>` | Remove an entry from the log |
| `search` | `brook search <term>` | Search entries by keyword (case-insensitive) |
| `export` | `brook export` | Export all data from the log to stdout |
| `info` | `brook info` | Show version and data directory path |
| `help` | `brook help` | Show the help message with all commands |
| `version` | `brook version` | Print the current version string |

## Data Storage

All data is stored in `~/.local/share/brook/` (override with `BROOK_DIR` or `XDG_DATA_HOME`):

- `data.log` — main data file, one entry per line in `YYYY-MM-DD <content>` format
- `history.log` — activity log tracking all command invocations with timestamps
- `config.json` — configuration file path (referenced by `config` command)

## Requirements

- Bash (with `set -euo pipefail`)
- Standard Unix utilities: `date`, `grep`, `cat`
- No Python, no Node.js, no API keys

## When to Use

1. **Logging proxy configurations** — Use `brook add "SOCKS5 proxy: 192.168.1.100:1080, auth enabled"` to record proxy server details for later reference and search.
2. **Tracking VPN tunnel setups** — Use `brook add "WireGuard tunnel: office-vpn, endpoint 10.0.0.1:51820"` to maintain a log of all VPN tunnel configurations across environments.
3. **Network troubleshooting notes** — Use `brook add "Firewall rule: allow port 8443 outbound for API gateway"` to document firewall changes and routing decisions during troubleshooting sessions.
4. **Multi-server inventory** — Use `brook add "Server: prod-us-east, proxy port 3128, bypass: internal.corp"` to build a searchable inventory of server proxy configurations with `brook search "prod"`.
5. **Export for documentation** — Use `brook export` to dump all logged network configuration data into documentation or hand it off to a team member.

## Examples

```bash
# Initialize the tool
brook init

# Add proxy configuration entries
brook add "SOCKS5 proxy at 10.0.1.50:1080 for dev environment"
brook add "HTTP proxy at proxy.corp.com:8080 with PAC file"
brook add "WireGuard peer: remote-office, allowed IPs: 10.10.0.0/24"

# List all entries
brook list

# Search for specific configurations
brook search "SOCKS5"

# Check tool status
brook status

# View version and data location
brook info

# Export all data
brook export

# Run main function
brook run "test-connection"
```

## Configuration

Set `BROOK_DIR` environment variable to change the data directory. Falls back to `XDG_DATA_HOME/brook` or `~/.local/share/brook/`.

## Output

All commands print results to stdout. Redirect output to a file if needed:

```bash
brook list > all-configs.txt
brook export > brook-data.txt
```

> **Note**: This is an original, independent implementation by BytesAgain. Not affiliated with or derived from any third-party project.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
