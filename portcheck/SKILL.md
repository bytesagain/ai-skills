---
name: PortCheck
description: "Scan open ports and validate network services. Use when checking port availability, validating firewall rules, generating reports, linting configs."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["port","scanner","network","security","tcp","service","firewall","devops"]
categories: ["Security", "System Tools", "Developer Tools"]
---

# PortCheck

A thorough devtools toolkit for checking, validating, formatting, linting, and analyzing port configurations and network services. Works entirely offline with local storage, zero configuration, and a clean command-line interface.

## Why PortCheck?

- Works entirely offline — your data never leaves your machine
- 12 core network/devtools commands plus utility commands
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging with timestamps

## Commands

| Command | Description |
|---------|-------------|
| `portcheck check <input>` | Check port availability, service status, or network configurations |
| `portcheck validate <input>` | Validate firewall rules, network configs, or port mappings |
| `portcheck generate <input>` | Generate port scan reports, firewall rule templates, or config files |
| `portcheck format <input>` | Format network configuration files to consistent standards |
| `portcheck lint <input>` | Lint firewall rules or network configs for common issues |
| `portcheck explain <input>` | Explain port numbers, protocols, or network error messages |
| `portcheck convert <input>` | Convert between configuration formats or port notation styles |
| `portcheck template <input>` | Create or manage network configuration templates |
| `portcheck diff <input>` | Diff firewall rules or network configurations |
| `portcheck preview <input>` | Preview changes before applying to network configs |
| `portcheck fix <input>` | Auto-fix common network configuration issues |
| `portcheck report <input>` | Generate network analysis and port scan reports |
| `portcheck stats` | Show summary statistics for all logged entries |
| `portcheck export <fmt>` | Export data (json, csv, or txt) |
| `portcheck search <term>` | Search across all logged entries |
| `portcheck recent` | Show last 20 activity entries |
| `portcheck status` | Health check — version, data dir, disk usage |
| `portcheck help` | Show full help with all available commands |
| `portcheck version` | Show current version (v2.0.0) |

Each core command (check, validate, generate, format, lint, explain, convert, template, diff, preview, fix, report) works in two modes:
- **Without arguments:** shows recent entries from that command's log
- **With arguments:** records the input with a timestamp and saves to the command-specific log file

## Data Storage

All data is stored locally at `~/.local/share/portcheck/`. Each command maintains its own `.log` file (e.g., `check.log`, `validate.log`, `lint.log`). A unified `history.log` tracks all activity across commands with timestamps. Use the `export` command to back up your data in JSON, CSV, or plain text format at any time.

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No external dependencies or API keys required
- Works on Linux, macOS, and WSL

## When to Use

1. **Pre-deployment port validation** — Run `portcheck check` and `portcheck validate` to verify port availability and firewall rules before deploying services
2. **Firewall rule auditing** — Use `portcheck lint` and `portcheck report` to audit firewall configurations for security gaps or redundant rules
3. **Network troubleshooting** — Use `portcheck explain` and `portcheck diff` to understand port conflicts, protocol issues, or configuration drift
4. **Configuration management** — Run `portcheck template` and `portcheck generate` to create standardized network configuration files across environments
5. **Change management workflow** — Use `portcheck preview`, `portcheck diff`, and `portcheck fix` to safely review and apply network configuration changes

## Examples

```bash
# Check if a port is available
portcheck check "prod-web-01:8080 — verify service is listening"

# Validate firewall rules
portcheck validate "iptables rules — ensure port 443 is open for HTTPS"

# Lint a network configuration
portcheck lint "nginx.conf — check for insecure port bindings"

# Generate a port scan report
portcheck generate "Full TCP scan report for 192.168.1.0/24"

# Explain a port number
portcheck explain "Port 3306 — what service uses this by default?"

# Diff two firewall configurations
portcheck diff "staging vs production iptables rules"

# View statistics across all commands
portcheck stats

# Export all data as JSON
portcheck export json

# Search for a specific term in all logs
portcheck search "443"

# Check system health
portcheck status
```

## Output

All commands return structured text to stdout. Redirect to a file with `portcheck <command> > output.txt`. Exported files are saved to the data directory with the chosen format extension.

## Configuration

The data directory defaults to `~/.local/share/portcheck/`. The tool auto-creates this directory on first run.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
