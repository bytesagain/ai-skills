---
version: "2.0.0"
name: Awesome Cloudflare
description: "⛅️ 精选的 Cloudflare 工具、开源项目、指南、博客和其他资源列表。/ ⛅️ A curated list of Cloudflare tools, open source projects awesome cloudflare."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Awesome Cloudflare

A system operations and monitoring tool for checking system health, viewing logs, managing backups, setting alerts, and getting optimization tips. Provides a lightweight CLI interface for common sysadmin tasks.

## Commands

| Command    | Description                                          |
|------------|------------------------------------------------------|
| `status`   | Show system status including uptime                  |
| `check`    | Run a health check (CPU cores, memory usage)         |
| `monitor`  | Start monitoring a specified service or resource     |
| `logs`     | View recent system logs from syslog                  |
| `config`   | Show the current configuration directory             |
| `restart`  | Display the systemctl restart command for a service  |
| `backup`   | Generate a tar.gz backup command for a given path    |
| `alert`    | Set an alert with a resource name and threshold      |
| `optimize` | Display optimization tips (cache, logs, processes)   |
| `info`     | Show full system info (uname) and disk usage         |
| `help`     | Show the help message with all available commands    |
| `version`  | Print the current version number                     |

## Data Storage

- **Data directory:** `~/.local/share/awesome-cloudflare/` (override with `AWESOME_CLOUDFLARE_DIR` env variable)
- **Data log:** `$DATA_DIR/data.log` — general data storage
- **History log:** `$DATA_DIR/history.log` — tracks all command executions with timestamps

## Requirements

- Bash 4.0+
- Standard Unix utilities (`uptime`, `free`, `grep`, `df`, `uname`, `tail`, `tar`)
- Access to `/proc/cpuinfo` for CPU info (Linux)
- Access to `/var/log/syslog` for log viewing (may require elevated permissions)
- No API keys or external services needed
- Works on Linux (some commands are Linux-specific)

## When to Use

1. **Quick health checks** — When you need to verify a server's CPU count and memory usage at a glance
2. **Log inspection** — When you want to quickly view the most recent system log entries without remembering log file paths
3. **Backup generation** — When you need a quick backup command for a directory, generating a timestamped tar.gz archive
4. **Service management** — When you need to see the correct systemctl restart command for a given service
5. **System optimization** — When you want quick tips for clearing cache, compressing logs, and cleaning up zombie processes

## Examples

```bash
# Check system status (uptime)
awesome-cloudflare status

# Run a health check (CPU cores + memory)
awesome-cloudflare check

# View recent system logs
awesome-cloudflare logs

# Show full system info and disk usage
awesome-cloudflare info

# Start monitoring a specific service
awesome-cloudflare monitor nginx

# Get the restart command for a service
awesome-cloudflare restart nginx

# Generate a backup command for /var/www
awesome-cloudflare backup /var/www

# Set an alert on CPU usage at 90%
awesome-cloudflare alert cpu 90

# Get optimization tips
awesome-cloudflare optimize

# Show config directory
awesome-cloudflare config
```

## Output

All command results are printed to stdout. You can redirect output with standard shell operators:

```bash
awesome-cloudflare check > health-report.txt
awesome-cloudflare info | tee system-info.log
awesome-cloudflare logs > recent-logs.txt
```

## Configuration

Set the `AWESOME_CLOUDFLARE_DIR` environment variable to change the data directory:

```bash
export AWESOME_CLOUDFLARE_DIR="/custom/path/to/awesome-cloudflare"
```

Default location: `~/.local/share/awesome-cloudflare/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
