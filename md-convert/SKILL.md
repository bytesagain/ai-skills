---
version: "1.0.0"
name: md-convert
description: "Convert PDF, DOCX, HTML, and PPTX files to clean Markdown via Markitdown. Use when converting PDFs to MD, extracting DOCX text, migrating to Markdown."
---
# MD Convert

Utility toolkit for running, checking, converting, analyzing, generating, previewing, batching, comparing, exporting, configuring, reporting, and managing file conversion operations. MD Convert provides a thorough utility workflow with timestamped logging for every operation. All entries are stored locally for full traceability.

## Commands

### Core Operations
| Command | Description |
|---------|-------------|
| `md-convert run <input>` | Run a conversion task. Run without args to view recent run entries |
| `md-convert convert <input>` | Convert content between formats. Run without args to view recent conversions |
| `md-convert generate <input>` | Generate output from templates or rules. Run without args to view recent generations |
| `md-convert batch <input>` | Batch-process multiple items. Run without args to view recent batch entries |
| `md-convert preview <input>` | Preview conversion output. Run without args to view recent previews |

### Analysis & Validation
| Command | Description |
|---------|-------------|
| `md-convert check <input>` | Check files or inputs for issues. Run without args to view recent checks |
| `md-convert analyze <input>` | Analyze content structure or quality. Run without args to view recent analyses |
| `md-convert compare <input>` | Compare two inputs or outputs. Run without args to view recent comparisons |

### Configuration & Reporting
| Command | Description |
|---------|-------------|
| `md-convert config <input>` | Store or update configuration settings. Run without args to view recent config entries |
| `md-convert export <input>` | Export processed data. Run without args to view recent export entries |
| `md-convert status <input>` | Record or check status of operations. Run without args to view recent status entries |
| `md-convert report <input>` | Generate reports from logged data. Run without args to view recent reports |

### Utility Commands
| Command | Description |
|---------|-------------|
| `md-convert stats` | Show summary statistics across all entry types |
| `md-convert search <term>` | Search across all entries by keyword |
| `md-convert recent` | Show the 20 most recent activity log entries |
| `md-convert help` | Show usage information and available commands |
| `md-convert version` | Show version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/md-convert/`:

- Each command type has its own log file (e.g., `run.log`, `convert.log`, `analyze.log`)
- Entries are timestamped in `YYYY-MM-DD HH:MM|value` format
- A unified `history.log` tracks all activity across commands
- Export supports JSON, CSV, and plain text formats via the `stats`/utility commands
- No external services or API keys required

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard UNIX utilities (`wc`, `du`, `grep`, `tail`, `sed`, `date`)
- No external dependencies — works on any POSIX-compatible system

## When to Use

1. **File format conversion** — Use `convert` and `run` to transform content between formats with logged history of every operation
2. **Batch processing** — Use `batch` to process multiple files at once, with full logging of each batch operation
3. **Quality assurance** — Use `check`, `analyze`, and `compare` to validate conversions and catch issues before finalizing
4. **Conversion pipeline management** — Use `config`, `status`, and `report` to track pipeline configuration and operational health
5. **Audit trail** — Use `stats`, `search`, and `export` to review conversion history, find specific operations, and generate compliance reports

## Examples

```bash
# Run a conversion task
md-convert run "Convert quarterly-report.docx to markdown format"

# Check a file for conversion issues
md-convert check "Validate formatting in README.md before export"

# Batch-process a directory
md-convert batch "Process all .html files in /data/imports/"

# Compare two conversion outputs
md-convert compare "diff output-v1.md vs output-v2.md — check heading structure"

# Generate a report of recent operations
md-convert report "Weekly conversion summary for team review"

# Search for all entries about a specific file
md-convert search quarterly-report

# View overall statistics
md-convert stats
```

## How It Works

Each command (run, check, convert, etc.) works the same way:
- **With arguments**: Saves the input as a new timestamped entry and logs it to history
- **Without arguments**: Displays the 20 most recent entries for that command type

This makes MD Convert both an operational tool and a searchable operations journal.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
