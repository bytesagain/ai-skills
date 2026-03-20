---
version: "1.0.0"
name: persona-forge
description: "角色设计工具。创建角色档案、背景故事、性格特征、人物关系、角色弧光、角色卡。Character creator with profiles, backstories, personality traits, relationships, character arcs."
---

# Persona Forge

Utility toolkit v2.0.0 — run, check, convert, analyze, and manage utility tasks from the command line.

## Commands

All commands follow the pattern: `persona-forge <command> [input]`

When called without input, each command displays its recent entries. When called with input, it records a new timestamped entry.

| Command        | Description                                      |
|----------------|--------------------------------------------------|
| `run`          | Record or view run entries                       |
| `check`        | Record or view check entries                     |
| `convert`      | Record or view convert entries                   |
| `analyze`      | Record or view analyze entries                   |
| `generate`     | Record or view generate entries                  |
| `preview`      | Record or view preview entries                   |
| `batch`        | Record or view batch processing entries          |
| `compare`      | Record or view compare entries                   |
| `export`       | Record or view export entries                    |
| `config`       | Record or view config entries                    |
| `status`       | Record or view status entries                    |
| `report`       | Record or view report entries                    |
| `stats`        | Summary statistics across all log files          |
| `export <fmt>` | Export all data (json, csv, or txt)              |
| `search <term>`| Search across all log entries                    |
| `recent`       | Show the 20 most recent activity log entries     |
| `status`       | Health check — version, entry count, disk usage  |
| `help`         | Show help with all available commands            |
| `version`      | Print version string                             |

## How It Works

Each domain command (`run`, `check`, `convert`, etc.) works in two modes:

- **Read mode** (no arguments): displays the last 20 entries from its log file
- **Write mode** (with arguments): appends a timestamped `YYYY-MM-DD HH:MM|<input>` line to its log file and logs the action to `history.log`

The built-in utility commands (`stats`, `export <fmt>`, `search`, `recent`, `status`) aggregate data across all log files for reporting and analysis.

## Data Storage

All data is stored locally in `~/.local/share/persona-forge/`:

- Each command writes to its own log file (e.g., `run.log`, `check.log`, `generate.log`)
- `history.log` records all write operations with timestamps
- Export files are saved as `export.json`, `export.csv`, or `export.txt`
- No external network calls — everything stays on disk

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `sed`, `cat`
- No external dependencies or package installations needed

## When to Use

1. **Creating character profiles** — use `generate` to log new persona ideas and `run` to execute creation workflows
2. **Analyzing personality traits** — record trait analysis with `analyze` and validation results with `check`
3. **Comparing characters** — use `compare` to track side-by-side persona evaluations and differences
4. **Batch persona generation** — log bulk character creation jobs with `batch` and review outputs with `preview`
5. **Exporting character data** — export all persona records to JSON, CSV, or TXT for use in writing tools or game engines

## Examples

```bash
# Generate a new persona
persona-forge generate "林夜 — protagonist, 武侠 setting, INTJ personality"

# Run a creation workflow
persona-forge run "Full character sheet for 林夜: backstory + traits + relationships"

# Analyze personality traits
persona-forge analyze "林夜: 沉稳 85%, 机敏 90%, 孤傲 70% — INTJ archetype match"

# Check character consistency
persona-forge check "林夜 backstory vs personality: no contradictions found"

# Compare two characters
persona-forge compare "林夜 vs 萧无痕: opposing motivations, complementary skills"

# Preview a character card
persona-forge preview "林夜 RPG card: STR 14, DEX 18, INT 16, WIS 12"

# Batch process multiple personas
persona-forge batch "Generate 5 NPCs for Act 2 tavern scene"

# Log configuration
persona-forge config "Default world: 武侠, output format: markdown"

# Export all persona data to JSON
persona-forge export json

# Search for a character
persona-forge search 林夜

# View recent activity
persona-forge recent

# Check system status
persona-forge status
```

## Output

All commands return results to stdout. Redirect to a file if needed:

```bash
persona-forge stats > persona-summary.txt
persona-forge export csv
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
