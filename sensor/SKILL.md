---
name: "Sensor"
description: "Read and manage IoT sensor data from the terminal. Use when polling readings, checking device connectivity, converting units, analyzing telemetry trends."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["sensor", "tool", "terminal", "cli", "utility"]
---

# Sensor

A terminal-first utility toolkit for managing sensor data. Log readings, check device status, analyze telemetry, generate reports, and export data — all with timestamped logging and full export support.

## Why Sensor?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging
- Each command maintains its own dedicated log file

## Commands

| Command | Description |
|---------|-------------|
| `sensor run <input>` | Run a sensor task (or view recent runs with no args) |
| `sensor check <input>` | Check sensor readings or device connectivity |
| `sensor convert <input>` | Convert between units or data formats |
| `sensor analyze <input>` | Analyze telemetry trends and patterns |
| `sensor generate <input>` | Generate sensor configurations or test data |
| `sensor preview <input>` | Preview a sensor operation before executing |
| `sensor batch <input>` | Batch-process multiple sensor readings |
| `sensor compare <input>` | Compare sensor readings across devices or time periods |
| `sensor export <input>` | Log an export operation (or view recent exports) |
| `sensor config <input>` | Store or review sensor configuration settings |
| `sensor status <input>` | Log a device status update (or view recent status entries) |
| `sensor report <input>` | Generate or log a sensor data report |
| `sensor stats` | Show summary statistics across all categories |
| `sensor export <fmt>` | Export all data (formats: json, csv, txt) |
| `sensor search <term>` | Search across all logged entries |
| `sensor recent` | Show the 20 most recent activity log entries |
| `sensor status` | Health check — version, data dir, entry count, disk usage |
| `sensor help` | Show full usage information |
| `sensor version` | Show version (v2.0.0) |

Each action command works in two modes:
- **With arguments:** saves the input with a timestamp to `<command>.log` and logs to history
- **Without arguments:** displays the 20 most recent entries for that command

## Data Storage

All data is stored locally in `~/.local/share/sensor/`. Each command writes to its own dedicated log file (e.g., `run.log`, `check.log`, `analyze.log`). A unified `history.log` tracks all activity with timestamps. Data never leaves your machine.

Directory structure:
```
~/.local/share/sensor/
├── run.log
├── check.log
├── convert.log
├── analyze.log
├── generate.log
├── preview.log
├── batch.log
├── compare.log
├── export.log
├── config.log
├── status.log
├── report.log
└── history.log
```

## Requirements

- Bash (with `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or network access required

## When to Use

1. **Logging IoT sensor readings from the field** — use `run` and `check` to record temperature, humidity, pressure, or other sensor readings with automatic timestamps
2. **Analyzing telemetry trends across devices** — use `analyze` and `compare` to identify patterns in sensor data and spot anomalies between devices or time periods
3. **Converting sensor data between units** — use `convert` to log unit conversions (Celsius to Fahrenheit, PSI to bar, etc.) and keep a record of transformations
4. **Generating periodic sensor reports** — use `report`, `stats`, and `export` to compile sensor data into JSON, CSV, or text formats for dashboards or stakeholder reviews
5. **Batch-processing multi-device sensor data** — use `batch` and `config` to handle bulk sensor operations and maintain device configuration records

## Examples

```bash
# Log a temperature reading
sensor run "Sensor-A3: 23.5°C at warehouse zone B"

# Check device connectivity status
sensor check "Gateway-01: online, 12 sensors connected, latency 45ms"

# Analyze a telemetry trend
sensor analyze "Temperature drift: +0.3°C/hour over last 6 hours in cold storage"

# Export all sensor data as CSV for analysis
sensor export csv

# Search for all entries related to a specific sensor
sensor search "Sensor-A3"
```

## Configuration

Set the `SENSOR_DIR` environment variable to change the data directory. Default: `~/.local/share/sensor/`

## Output

All commands output results to stdout. Redirect to a file with `> output.txt` if needed. The `export` command writes directly to `~/.local/share/sensor/export.<fmt>`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
