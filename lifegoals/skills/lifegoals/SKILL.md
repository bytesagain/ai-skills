---
version: "1.0.0"
name: lifegoals
description: "Define goals, break them into milestones, and track progress step by step. Use when setting life goals, planning milestones, tracking long-term progress."
---

# Lifegoals

A command-line devtools toolkit for tracking and managing life goals. Check, validate, generate, format, lint, explain, convert, template, diff, preview, fix, and report on your goals — all from your terminal with persistent logging and full activity history.

## Why Lifegoals?

- Works entirely offline — your personal goals never leave your machine
- No external dependencies or accounts needed
- Every action is timestamped and logged for full auditability
- Export your history to JSON, CSV, or plain text anytime
- Simple CLI interface with consistent command patterns

## Commands

| Command | Description |
|---------|-------------|
| `lifegoals check <input>` | Check goal entries for completeness; view recent checks without args |
| `lifegoals validate <input>` | Validate goal structure, format, and feasibility |
| `lifegoals generate <input>` | Generate new goal ideas or milestone breakdowns |
| `lifegoals format <input>` | Format goal data for readability or presentation |
| `lifegoals lint <input>` | Lint goals for vague language or missing deadlines |
| `lifegoals explain <input>` | Explain a goal's structure and progress path |
| `lifegoals convert <input>` | Convert goal data between different formats |
| `lifegoals template <input>` | Create or apply goal templates for common objectives |
| `lifegoals diff <input>` | Diff two goal snapshots to track changes over time |
| `lifegoals preview <input>` | Preview goal output or milestone timeline |
| `lifegoals fix <input>` | Auto-fix common issues in goal definitions |
| `lifegoals report <input>` | Generate a progress report on your goals |
| `lifegoals stats` | Show summary statistics across all actions |
| `lifegoals export <fmt>` | Export all logs (formats: `json`, `csv`, `txt`) |
| `lifegoals search <term>` | Search across all log entries |
| `lifegoals recent` | Show the 20 most recent activity entries |
| `lifegoals status` | Health check — version, disk usage, entry count |
| `lifegoals help` | Show help with all available commands |
| `lifegoals version` | Print current version (v2.0.0) |

Each data command (check, validate, generate, etc.) works in two modes:
- **With arguments** — logs the input with a timestamp and saves to its dedicated log file
- **Without arguments** — displays the 20 most recent entries from that command's log

## Getting Started

```bash
# See all available commands
lifegoals help

# Check current system status
lifegoals status

# View statistics across all commands
lifegoals stats
```

## Data Storage

All data is stored locally in `~/.local/share/lifegoals/`. The directory structure:

- `check.log`, `validate.log`, `generate.log`, `format.log`, etc. — per-command log files
- `history.log` — unified activity log across all commands
- `export.json`, `export.csv`, `export.txt` — generated export files

Modify the `DATA_DIR` variable in `script.sh` to change the storage path.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`)
- **Standard Unix tools**: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- Works on Linux and macOS
- No external packages or network access required

## When to Use

1. **Setting new life goals** — use `lifegoals generate` to brainstorm objectives and `lifegoals template` to apply proven goal-setting frameworks like SMART goals
2. **Breaking goals into milestones** — run `lifegoals check` and `lifegoals validate` to ensure each goal has clear, actionable steps and deadlines
3. **Tracking progress over time** — use `lifegoals diff` to compare goal snapshots at different dates and `lifegoals report` to generate progress summaries
4. **Reviewing and refining goals** — run `lifegoals lint` to catch vague language, then `lifegoals fix` to tighten up weak goal definitions
5. **Exporting goal data for sharing** — use `lifegoals export` and `lifegoals convert` to transform your goal history into JSON, CSV, or text for journals, coaches, or planning tools

## Examples

```bash
# Check a goal for completeness
lifegoals check "Learn Spanish to B2 level by December 2026"

# Validate a goal's structure
lifegoals validate "Run a marathon — target: sub-4-hours"

# Generate milestone ideas for a goal
lifegoals generate "Save $50k emergency fund"

# Lint a goal for vague language
lifegoals lint "Get healthier somehow"

# Format goal data for presentation
lifegoals format "Career: Get promoted to senior engineer"

# Create a goal from a template
lifegoals template "fitness-90-day-challenge"

# Diff two goal snapshots
lifegoals diff "Q1-goals vs Q2-goals"

# Generate a progress report
lifegoals report "2026-goals"

# View summary statistics
lifegoals stats

# Export all history as JSON
lifegoals export json

# Search for goals mentioning fitness
lifegoals search "fitness"

# View recent activity
lifegoals recent
```

## Output

All commands output structured text to stdout. You can redirect output to a file:

```bash
lifegoals report annual-review > review.txt
lifegoals export csv
```

## Configuration

The data directory defaults to `~/.local/share/lifegoals/`. Modify the `DATA_DIR` variable at the top of `script.sh` to customize the storage path.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
