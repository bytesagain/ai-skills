---
version: "2.0.0"
name: Browser Fingerprinting
description: "Analysis of Bot Protection systems with available countermeasures 🚿. How to defeat anti-bot system 👻 browser fingerprinting, javascript, abck, arkose."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Browser Fingerprinting

Browser Fingerprinting v2.0.0 — a multi-purpose utility tool for managing browser fingerprinting research data, tracking anti-bot countermeasure notes, and organizing web scraping configurations from the command line.

## Why Browser Fingerprinting?

- Lightweight CLI tool for managing fingerprinting research and anti-bot analysis data
- No external dependencies, accounts, or API keys needed
- Local-first storage — your research notes and configurations stay on your machine
- Simple subcommand interface for adding, listing, searching, and exporting entries
- Works on any system with Bash
- Perfect for security researchers, web scrapers, and bot detection analysts

## Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `run` | `browser-fingerprinting run <args>` | Execute the main function and log the action |
| `config` | `browser-fingerprinting config` | Show configuration file path |
| `status` | `browser-fingerprinting status` | Show current tool status (ready/not ready) |
| `init` | `browser-fingerprinting init` | Initialize the data directory |
| `list` | `browser-fingerprinting list` | List all entries from the data log |
| `add` | `browser-fingerprinting add <entry>` | Add a new entry to the data log (timestamped) |
| `remove` | `browser-fingerprinting remove <entry>` | Remove an entry from the log |
| `search` | `browser-fingerprinting search <term>` | Search entries by keyword (case-insensitive) |
| `export` | `browser-fingerprinting export` | Export all data from the log to stdout |
| `info` | `browser-fingerprinting info` | Show version and data directory path |
| `help` | `browser-fingerprinting help` | Show the help message with all commands |
| `version` | `browser-fingerprinting version` | Print the current version string |

## Data Storage

All data is stored in `~/.local/share/browser-fingerprinting/` (override with `BROWSER_FINGERPRINTING_DIR` or `XDG_DATA_HOME`):

- `data.log` — main data file, one entry per line in `YYYY-MM-DD <content>` format
- `history.log` — activity log tracking all command invocations with timestamps
- `config.json` — configuration file path (referenced by `config` command)

## Requirements

- Bash (with `set -euo pipefail`)
- Standard Unix utilities: `date`, `grep`, `cat`
- No Python, no Node.js, no API keys

## When to Use

1. **Cataloging anti-bot systems** — Use `browser-fingerprinting add "Akamai Bot Manager: uses sensor data, cookie _abck, challenge scripts"` to build a research database of bot protection systems you've encountered and analyzed.
2. **Tracking fingerprint vectors** — Use `browser-fingerprinting add "Canvas fingerprint: toDataURL hash varies by GPU driver version"` to log different browser fingerprinting techniques and their detection characteristics.
3. **Documenting countermeasures** — Use `browser-fingerprinting add "Countermeasure: spoof navigator.webdriver=false, override canvas noise"` to maintain a reference of working countermeasures for different protection systems.
4. **Web scraping config notes** — Use `browser-fingerprinting add "Target: example.com, protection: Cloudflare, solution: undetected-chromedriver v2"` to track per-site scraping configurations and search them with `browser-fingerprinting search "Cloudflare"`.
5. **Exporting research data** — Use `browser-fingerprinting export` to dump all logged fingerprinting research entries for inclusion in reports, blog posts, or team knowledge bases.

## Examples

```bash
# Initialize the tool
browser-fingerprinting init

# Log anti-bot system research
browser-fingerprinting add "Arkose Labs: FunCaptcha challenge, uses canvas + WebGL fingerprint"
browser-fingerprinting add "PerimeterX: human challenge, behavioral biometrics, mouse movement analysis"
browser-fingerprinting add "DataDome: server-side + client-side detection, JS challenge on suspicious requests"

# Add fingerprint technique notes
browser-fingerprinting add "WebGL renderer string: ANGLE (NVIDIA GeForce GTX 1080) - unique per GPU"
browser-fingerprinting add "AudioContext fingerprint: oscillator + compressor node hash"

# List all entries
browser-fingerprinting list

# Search for a specific anti-bot system
browser-fingerprinting search "Arkose"

# Check tool status
browser-fingerprinting status

# View version and data location
browser-fingerprinting info

# Export all research data
browser-fingerprinting export
```

## Configuration

Set `BROWSER_FINGERPRINTING_DIR` environment variable to change the data directory. Falls back to `XDG_DATA_HOME/browser-fingerprinting` or `~/.local/share/browser-fingerprinting/`.

## Output

All commands print results to stdout. Redirect output to a file if needed:

```bash
browser-fingerprinting list > all-research.txt
browser-fingerprinting export > fingerprint-data.txt
```

> **Note**: This is an original, independent implementation by BytesAgain. Not affiliated with or derived from any third-party project.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
