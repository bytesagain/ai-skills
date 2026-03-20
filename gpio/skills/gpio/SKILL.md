---
name: "Gpio"
description: "Control GPIO pins on Raspberry Pi or embedded boards with logging support. Use when reading sensors, toggling relays, or logging pin state changes."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["gpio", "tool", "terminal", "cli", "utility"]
---

# GPIO

Utility toolkit for running, checking, converting, analyzing, and managing GPIO-related entries. Log operations, review trends, and export reports — all from the command line.

## Why GPIO?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Commands

| Command | Description |
|---------|-------------|
| `gpio run <input>` | Log a run operation |
| `gpio check <input>` | Log a check operation |
| `gpio convert <input>` | Log a conversion task |
| `gpio analyze <input>` | Log an analysis entry |
| `gpio generate <input>` | Log a generation task |
| `gpio preview <input>` | Log a preview entry |
| `gpio batch <input>` | Log a batch operation |
| `gpio compare <input>` | Log a comparison entry |
| `gpio export <input>` | Log an export operation |
| `gpio config <input>` | Log a configuration change |
| `gpio status <input>` | Log a status entry |
| `gpio report <input>` | Log a report entry |
| `gpio stats` | Show summary statistics across all categories |
| `gpio search <term>` | Search across all logged entries |
| `gpio recent` | Show last 20 activity entries |
| `gpio help` | Show help and available commands |
| `gpio version` | Show version (v2.0.0) |

Each domain command (run, check, convert, etc.) works the same way:
- **With arguments:** logs the input with a timestamp to its own `.log` file
- **Without arguments:** displays the last 20 entries from that log

> **Note:** The `export` and `status` commands in the case block act as log-and-retrieve commands (like the other domain commands). The utility-level `_export` and `_status` functions are available via `stats` and internal calls.

## Data Storage

All data is stored locally at `~/.local/share/gpio/`. Each action type has its own log file (e.g., `run.log`, `check.log`, `config.log`). A unified `history.log` tracks all activity across commands.

## Requirements

- Bash (standard system shell)
- No external dependencies — pure bash implementation
- Works on Linux and macOS

## When to Use

- Tracking GPIO pin operations and state changes
- Logging sensor readings and relay toggles over time
- Recording batch operations across multiple pins
- Comparing configurations between different setups
- Generating reports on GPIO activity
- Analyzing patterns in pin state data
- As part of an embedded systems or IoT automation pipeline

## Examples

```bash
# Log a run operation
gpio run "Set pin 17 HIGH for relay activation"

# Log a check
gpio check "Pin 4 reading: 3.3V — sensor active"

# Log a configuration change
gpio config "Switched pin 22 from INPUT to OUTPUT mode"

# Log an analysis
gpio analyze "Temperature sensor trend: +2.1°C over 24h"

# Batch operation
gpio batch "Toggled pins 17,18,22 to LOW for shutdown"

# Compare setups
gpio compare "Board A vs Board B: 3 pin assignments differ"

# Generate a report entry
gpio report "Daily GPIO summary — 142 state changes logged"

# View all statistics
gpio stats

# Search entries mentioning pin 17
gpio search "pin 17"

# Check recent activity
gpio recent

# Show help
gpio help
```

## Output

All commands return formatted output to stdout. Redirect to a file with `> output.txt` if needed.

## Configuration

Set `GPIO_DIR` environment variable to change the data directory. Default: `~/.local/share/gpio/`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
