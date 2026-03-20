---
version: "2.0.0"
name: Code Viewer
description: "Display source files with syntax highlighting and Git decorations. Use when reading code, inspecting file diffs, or reviewing configs in terminal."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Code Viewer

A thorough devtools toolkit for checking, validating, formatting, linting, explaining, converting, diffing, previewing, and fixing code — with built-in logging, search, statistics, and data export.

## Commands

| Command | Description |
|---------|-------------|
| `check <input>` | Record and check code input; without args shows recent check entries |
| `validate <input>` | Validate code input; without args shows recent validate entries |
| `generate <input>` | Generate code from input; without args shows recent entries |
| `format <input>` | Format code input; without args shows recent format entries |
| `lint <input>` | Lint code for issues; without args shows recent lint entries |
| `explain <input>` | Explain code; without args shows recent explain entries |
| `convert <input>` | Convert code between formats; without args shows recent entries |
| `template <input>` | Create or apply templates; without args shows recent entries |
| `diff <input>` | Compare code differences; without args shows recent diff entries |
| `preview <input>` | Preview code output; without args shows recent preview entries |
| `fix <input>` | Fix code issues; without args shows recent fix entries |
| `report <input>` | Generate a report; without args shows recent report entries |
| `stats` | Show summary statistics across all log categories |
| `export <fmt>` | Export all data in json, csv, or txt format |
| `search <term>` | Search across all logged entries for a term |
| `recent` | Show the 20 most recent entries from the activity log |
| `status` | Health check — version, data dir, entry count, disk usage |
| `help` | Show all available commands |
| `version` | Print version (v2.0.0) |

## Usage

```bash
code-viewer <command> [args]
```

Each command with an argument logs the input with a timestamp and saves it to a category-specific log file. Running a command without arguments displays the most recent entries for that category.

## Data Storage

- **Default location**: `~/.local/share/code-viewer`
- **Log files**: Each command category stores entries in its own file (e.g., `check.log`, `lint.log`, `diff.log`)
- **History**: All commands are also logged to `history.log` with timestamps
- **Export formats**: JSON (structured array), CSV (type/time/value), or plain text

## Requirements

- Bash 4+ (strict mode: `set -euo pipefail`)
- No external dependencies or API keys required
- Standard Unix tools (`date`, `wc`, `grep`, `du`, `head`, `tail`)

## When to Use

1. **Code review workflow** — Use `check`, `lint`, and `validate` to log and track code issues during review sessions
2. **Learning and documentation** — Use `explain` to break down unfamiliar code, then `report` to generate summaries
3. **Format conversion** — Use `convert` to transform code between formats, and `format` to standardize style
4. **Diff tracking** — Use `diff` to log code comparisons, then `search` to find specific changes later
5. **Team metrics and audit** — Use `stats` to see activity summaries, `export json` to feed data into dashboards

## Examples

```bash
# Check a code snippet
code-viewer check "function add(a, b) { return a + b; }"

# Lint a file reference
code-viewer lint "src/main.js has unused imports"

# Explain a code block
code-viewer explain "Array.prototype.reduce callback"

# View diff history
code-viewer diff

# Generate a report entry
code-viewer report "Sprint 12 code quality summary"

# Show aggregate stats across all categories
code-viewer stats

# Export all data as JSON
code-viewer export json

# Search logs for a keyword
code-viewer search "reduce"

# Show recent activity
code-viewer recent

# Health check
code-viewer status
```

## Output

- Command results print to stdout
- All entries are timestamped and persisted to `~/.local/share/code-viewer/<category>.log`
- Export files are written to `~/.local/share/code-viewer/export.<fmt>`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
