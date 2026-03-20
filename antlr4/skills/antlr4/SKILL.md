---
version: "2.0.0"
name: Antlr4
description: "ANTLR (ANother Tool for Language Recognition) is a powerful parser generator for reading, processing antlr4, java, antlr, antlr4, cpp, csharp."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Antlr4

Antlr4 v2.0.0 — a multi-purpose utility tool for managing data entries, searching records, and maintaining a structured local data store. Useful for tracking parser-related tasks, managing grammar definitions, and organizing language-processing workflows.

## Commands

| Command | Description |
|---------|-------------|
| `antlr4 run` | Execute main function — logs the run action |
| `antlr4 config` | Show configuration — displays data directory config path |
| `antlr4 status` | Show current status (ready / not ready) |
| `antlr4 init` | Initialize the data directory and confirm setup |
| `antlr4 list` | List all entries in the data log (or show empty) |
| `antlr4 add <entry>` | Add a timestamped entry to the data log |
| `antlr4 remove <entry>` | Remove an entry from the data log |
| `antlr4 search <term>` | Search the data log for matching entries (case-insensitive) |
| `antlr4 export` | Export the entire data log to stdout |
| `antlr4 info` | Show version and data directory path |
| `antlr4 help` | Show usage info and all available commands |
| `antlr4 version` | Show version (v2.0.0) |

## How It Works

Antlr4 operates as a local data management CLI. It stores entries in a flat-file data log (`data.log`) and records all command activity in a separate `history.log` for auditability.

- **`add`** appends a date-stamped line to `data.log`
- **`list`** prints the full contents of `data.log`
- **`search`** performs case-insensitive grep across the data log
- **`export`** dumps the raw data log to stdout for piping or redirection
- Every command is logged to `history.log` with a timestamp

## Data Storage

- **Location**: `~/.local/share/antlr4/` (override with `ANTLR4_DIR` or `XDG_DATA_HOME`)
- **Data log**: `data.log` — primary storage for added entries
- **History**: `history.log` — audit trail of all commands executed
- **Config**: `config.json` (referenced by the config command)

## Requirements

- Bash (4.0+)
- Standard Unix utilities (`grep`, `wc`, `date`, `cat`)
- No external dependencies or API keys required

## When to Use

1. **Tracking grammar definitions** — use `antlr4 add "Grammar: SQLParser.g4 — added SELECT support"` to log grammar changes over time
2. **Maintaining a task list** — `antlr4 add "TODO: refactor visitor pattern"` then `antlr4 list` to review
3. **Searching past entries** — `antlr4 search "visitor"` to find all entries mentioning a specific pattern
4. **Quick project initialization** — `antlr4 init` to set up the data directory for a new project
5. **Exporting data for reports** — `antlr4 export > report.txt` to capture all entries for documentation

## Examples

```bash
# Initialize the data store
antlr4 init

# Add entries to track your work
antlr4 add "Created lexer grammar for JSON"
antlr4 add "Added error recovery to parser rules"
antlr4 add "Visitor pattern for AST traversal"

# List all recorded entries
antlr4 list

# Search for specific entries
antlr4 search "grammar"

# Check current status
antlr4 status

# View version and data location
antlr4 info

# Export all data for backup
antlr4 export > antlr4-backup.txt

# Show all available commands
antlr4 help
```

## Output

Results go to stdout. Save with `antlr4 export > output.txt`. All commands are logged to `history.log` for full traceability.

## Configuration

Set `ANTLR4_DIR` environment variable to change the data directory. Alternatively, set `XDG_DATA_HOME` (data will go to `$XDG_DATA_HOME/antlr4/`). Default: `~/.local/share/antlr4/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
