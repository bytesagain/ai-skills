---
version: "2.0.0"
name: Debate Helper
description: "Build debate arguments and plan rebuttals with structured evidence. Use when constructing arguments, preparing rebuttals, structuring outlines."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# Debate Helper

Multi-purpose utility tool for managing data entries, configuring settings, searching records, and exporting information. Provides a simple command-line interface for adding, listing, removing, and searching items in a local data store with full history logging.

## Commands

| Command | Description |
|---------|-------------|
| `debate-helper run <args>` | Execute the main function with the provided arguments. Logs the operation to history. |
| `debate-helper config <args>` | Show or manage configuration. Displays the config file path (`config.json` in the data directory). |
| `debate-helper status <args>` | Show current status of the tool (reports "ready" when operational). |
| `debate-helper init <args>` | Initialize the data directory and prepare the tool for first use. |
| `debate-helper list <args>` | List all entries currently stored in the data log. Shows "(empty)" if no data exists. |
| `debate-helper add <text>` | Add a new entry to the data log. Each entry is prefixed with the current date (YYYY-MM-DD). |
| `debate-helper remove <item>` | Remove an entry from the data log by identifier. |
| `debate-helper search <term>` | Search the data log for entries matching the given term (case-insensitive). |
| `debate-helper export <args>` | Export all data from the data log to stdout. Shows "No data" if the log is empty. |
| `debate-helper info <args>` | Show tool version and data directory path. |
| `debate-helper help` | Display all available commands and usage information. |
| `debate-helper version` | Show the current version (v2.0.0). |

## Data Storage

All data is stored in the directory specified by `$DEBATE_HELPER_DIR` (defaults to `~/.local/share/debate-helper/`):

- **`data.log`** — Primary data file where entries added via `add` are stored, one per line with date prefix
- **`history.log`** — Activity history tracking all commands executed with timestamps (format: `MM-DD HH:MM command: args`)
- **`config.json`** — Configuration file referenced by the `config` command
- The directory is created automatically on first run

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `cat`, `grep`, `echo`
- No external API keys or network access required
- No additional dependencies to install
- Optionally set `DEBATE_HELPER_DIR` or `XDG_DATA_HOME` environment variables to customize the data location

## When to Use

1. **Quick note-taking and idea capture** — Use `add` to jot down ideas, arguments, or observations with automatic date-stamping for easy retrieval later.
2. **Managing a simple knowledge base** — Use `add`, `list`, `search`, and `remove` to maintain a lightweight, searchable collection of entries without needing a database.
3. **Project initialization and setup** — Use `init` and `config` to set up the data directory and verify configuration before starting a new workflow.
4. **Searching and exporting records** — Use `search` to find specific entries by keyword and `export` to dump all data for use in other tools or pipelines.
5. **Batch processing in automation pipelines** — Use `run` to execute operations programmatically and `status` to verify the tool is ready before chaining commands in scripts.

## Examples

### Initialize and add entries
```bash
debate-helper init
debate-helper add "Universal basic income improves economic resilience"
debate-helper add "Counter: UBI may reduce workforce participation"
debate-helper add "Evidence: Finland 2017-2018 UBI trial showed improved wellbeing"
debate-helper list
```

### Search and manage entries
```bash
debate-helper search "UBI"
debate-helper search "evidence"
debate-helper remove "outdated-entry"
debate-helper list
```

### Check status and export
```bash
debate-helper status
debate-helper info
debate-helper export
debate-helper export > debate_notes.txt
```

### Configuration and execution
```bash
debate-helper config
debate-helper run "analyze arguments for immigration policy debate"
debate-helper version
```

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
