---
version: "1.0.0"
name: readme-maker
description: "Design beautiful GitHub profile READMEs with templates. Use when styling profiles, validating badges, generating stat widgets, formatting bio sections."
---

# Readme Maker

Developer tools CLI for checking, validating, generating, and formatting README files and documentation. Lint your markdown, generate templates, convert between formats, diff versions, preview output, fix common issues, and produce reports — all from the command line with persistent local logging.

## Commands

Run `readme-maker <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `check` | Check README files for completeness and common issues |
| `validate` | Validate markdown structure and formatting rules |
| `generate` | Generate README content from project metadata |
| `format` | Format and beautify markdown content |
| `lint` | Lint markdown for style and syntax issues |
| `explain` | Explain markdown elements or README sections |
| `convert` | Convert between documentation formats |
| `template` | Apply or manage README templates |
| `diff` | Diff two README versions or sections |
| `preview` | Preview rendered markdown output |
| `fix` | Auto-fix common README issues |
| `report` | Generate documentation quality reports |
| `stats` | Show summary statistics across all categories |
| `export <fmt>` | Export data in json, csv, or txt format |
| `search <term>` | Search across all logged entries |
| `recent` | Show recent activity from history log |
| `status` | Health check — version, data dir, disk usage |
| `help` | Show help and available commands |
| `version` | Show version (v2.0.0) |

Each domain command (check, validate, generate, etc.) works in two modes:
- **Without arguments**: displays the most recent 20 entries from that category
- **With arguments**: logs the input with a timestamp and saves to the category log file

## Data Storage

All data is stored locally in `~/.local/share/readme-maker/`:

- Each command creates its own log file (e.g., `check.log`, `generate.log`, `lint.log`)
- A unified `history.log` tracks all activity across commands
- Entries are stored in `timestamp|value` pipe-delimited format
- Export supports JSON, CSV, and plain text formats

## Requirements

- Bash 4+ with `set -euo pipefail` strict mode
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Starting a new project** — generate a README from a template, then lint and format it to ensure quality before committing
2. **Auditing existing documentation** — check and validate your README for missing sections (license, contributing, install instructions) and auto-fix common issues
3. **Converting documentation formats** — convert README content between markdown, reStructuredText, or other formats as part of a docs pipeline
4. **Comparing README changes** — diff two versions of your README to review what changed across releases or branches
5. **CI/CD documentation quality gates** — integrate lint and validate commands into your pipeline to enforce documentation standards on every PR

## Examples

```bash
# Check a README for completeness
readme-maker check "missing: license section, contributing guide, badges"

# Validate markdown structure
readme-maker validate "## headers OK, links 3/3 valid, images 1/1 accessible"

# Generate README from project info
readme-maker generate "name=my-app lang=python license=MIT"

# Lint for style issues
readme-maker lint "line 42: trailing whitespace; line 58: no blank line before heading"

# Format markdown content
readme-maker format "normalized headings, fixed list indentation, wrapped at 80 cols"

# Apply a template
readme-maker template "minimal — added: title, description, install, usage, license"

# Preview rendered output
readme-maker preview "rendered 128 lines, 3 code blocks, 2 tables"

# View summary statistics
readme-maker stats

# Export all data as JSON
readme-maker export json

# Search for specific entries
readme-maker search "license"
```

## Output

All commands output to stdout. Redirect to a file if needed:

```bash
readme-maker report "weekly audit" > report.txt
readme-maker export csv  # saves to ~/.local/share/readme-maker/export.csv
```

## Configuration

Set `DATA_DIR` by modifying the script, or use the default: `~/.local/share/readme-maker/`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
