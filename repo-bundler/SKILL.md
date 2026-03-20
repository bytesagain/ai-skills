---
version: "1.0.0"
name: Repomix
description: "📦 Repomix is a powerful tool that packs your entire repository into a single, AI-friendly file. Perf repo-bundler, typescript, ai, anthropic."
---

# Repo Bundler

📦 Repo Bundler v2.0.0 is a utility toolkit for bundling, analyzing, converting, and managing repository data. It provides a thorough CLI with timestamped logging, data export in multiple formats, and full activity history tracking.

## Commands

All commands accept optional `<input>` arguments. When called without arguments, they display recent entries from their respective logs. When called with input, they record a new timestamped entry.

| Command | Usage | Description |
|---------|-------|-------------|
| `run` | `repo-bundler run [input]` | Run a bundler operation and log the result |
| `check` | `repo-bundler check [input]` | Check repository state or validate input |
| `convert` | `repo-bundler convert [input]` | Convert data between formats |
| `analyze` | `repo-bundler analyze [input]` | Analyze repository structure or content |
| `generate` | `repo-bundler generate [input]` | Generate output files or reports |
| `preview` | `repo-bundler preview [input]` | Preview bundler output before committing |
| `batch` | `repo-bundler batch [input]` | Process multiple items in batch mode |
| `compare` | `repo-bundler compare [input]` | Compare two repositories or snapshots |
| `export` | `repo-bundler export [input]` | Log an export operation |
| `config` | `repo-bundler config [input]` | Manage configuration settings |
| `status` | `repo-bundler status [input]` | Log or view status entries |
| `report` | `repo-bundler report [input]` | Generate or log reports |

### Utility Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `stats` | `repo-bundler stats` | Show summary statistics across all log files |
| `export <fmt>` | `repo-bundler export json\|csv\|txt` | Export all data in JSON, CSV, or plain text format |
| `search <term>` | `repo-bundler search <term>` | Search across all log entries (case-insensitive) |
| `recent` | `repo-bundler recent` | Show the 20 most recent activity entries |
| `status` | `repo-bundler status` | Health check — version, data dir, entry count, disk usage |
| `help` | `repo-bundler help` | Show full command reference |
| `version` | `repo-bundler version` | Print version string (`repo-bundler v2.0.0`) |

## Data Storage

All data is stored locally in `~/.local/share/repo-bundler/`:

- **`history.log`** — Master activity log with timestamps for every operation
- **`run.log`**, **`check.log`**, **`convert.log`**, etc. — Per-command log files storing `timestamp|input` entries
- **`export.json`**, **`export.csv`**, **`export.txt`** — Generated export files

Each entry is stored in pipe-delimited format: `YYYY-MM-DD HH:MM|value`. The data directory is created automatically on first use.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`, `local` variables)
- **Standard Unix tools**: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `basename`, `cat`
- No external dependencies, API keys, or network access required
- Works on Linux, macOS, and WSL

## When to Use

1. **Bundling a repository for AI consumption** — Use `run` to process and pack repo contents into a single file suitable for LLM context windows
2. **Analyzing repository structure** — Use `analyze` to examine file counts, directory layout, and content patterns across a codebase
3. **Comparing repository snapshots** — Use `compare` to track differences between two versions or branches of a repository bundle
4. **Batch processing multiple repos** — Use `batch` to queue and process several repositories in sequence with logged results
5. **Exporting bundler history for auditing** — Use `export json` to generate a structured record of all bundler operations for compliance or review

## Examples

```bash
# Bundle a repository and log the operation
repo-bundler run my-project-v2.3

# Analyze repository structure
repo-bundler analyze ./src --depth=3

# Compare two repository snapshots
repo-bundler compare main-branch feature-branch

# Batch process multiple repos
repo-bundler batch repo1 repo2 repo3

# Export all history as JSON
repo-bundler export json

# Search for a specific entry across all logs
repo-bundler search "my-project"

# View summary statistics
repo-bundler stats

# Check system health
repo-bundler status
```

## Output

All commands output structured text to stdout. Use standard shell redirection to capture output:

```bash
repo-bundler stats > summary.txt
repo-bundler export json  # writes to ~/.local/share/repo-bundler/export.json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
