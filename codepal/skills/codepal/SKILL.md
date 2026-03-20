---
name: CodePal
description: "Analyze codebases quickly with AI-powered intelligence and insights. Use when understanding unfamiliar repos, checking quality, or generating summaries."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["code","developer","analysis","todo","loc","dependencies","programming","devtools"]
categories: ["Developer Tools", "Productivity"]
---

# CodePal

A full-featured devtools toolkit for checking, validating, generating, formatting, linting, explaining, converting, diffing, previewing, and fixing code — with built-in logging, search, statistics, and data export.

## Commands

| Command | Description |
|---------|-------------|
| `check <input>` | Check code and log the result; without args shows recent check entries |
| `validate <input>` | Validate code input; without args shows recent validate entries |
| `generate <input>` | Generate code from a description; without args shows recent entries |
| `format <input>` | Format code; without args shows recent format entries |
| `lint <input>` | Lint code for potential issues; without args shows recent lint entries |
| `explain <input>` | Explain a code snippet or concept; without args shows recent entries |
| `convert <input>` | Convert code between languages or formats; without args shows recent entries |
| `template <input>` | Create or apply code templates; without args shows recent entries |
| `diff <input>` | Log code differences; without args shows recent diff entries |
| `preview <input>` | Preview code output; without args shows recent preview entries |
| `fix <input>` | Record a code fix; without args shows recent fix entries |
| `report <input>` | Generate a code report; without args shows recent report entries |
| `stats` | Show summary statistics across all log categories |
| `export <fmt>` | Export all data (json, csv, or txt) |
| `search <term>` | Search across all logged entries for a keyword |
| `recent` | Show the 20 most recent entries from the activity log |
| `status` | Health check — version, data dir, total entries, disk usage, last activity |
| `help` | Show all available commands |
| `version` | Print version (v2.0.0) |

## Usage

```bash
codepal <command> [args]
```

Each command with arguments logs the input with a timestamp to a category-specific log file. Running a command with no arguments shows the most recent entries for that category.

## Data Storage

- **Default location**: `~/.local/share/codepal`
- **Log files**: Each command has its own log file (e.g., `check.log`, `lint.log`, `generate.log`)
- **History**: All actions are also recorded in `history.log` with timestamps
- **Export formats**: JSON (structured array of objects), CSV (type/time/value columns), plain text (grouped by category)

## Requirements

- Bash 4+ (strict mode: `set -euo pipefail`)
- No external dependencies or API keys required
- Standard Unix tools (`date`, `wc`, `grep`, `du`, `head`, `tail`)

## When to Use

1. **Code review tracking** — Use `check`, `lint`, and `validate` to log issues discovered during code review sessions, then `search` to find them later
2. **Learning unfamiliar codebases** — Use `explain` to document your understanding of code patterns, then `report` to create summaries
3. **Code generation and templating** — Use `generate` to log code generation prompts and `template` to track template usage
4. **Diffing and debugging** — Use `diff` to record code changes and `fix` to document bug fixes, creating an audit trail
5. **Team metrics and reporting** — Use `stats` for activity summaries, `export json` to feed into dashboards, and `recent` for quick status checks

## Examples

```bash
# Check a function
codepal check "validateEmail() is missing null check"

# Generate a code snippet description
codepal generate "React hook for debounced search"

# Lint a file
codepal lint "server.js:42 — unused variable 'config'"

# Explain a concept
codepal explain "JavaScript closure in event handler"

# Record a diff
codepal diff "Refactored auth middleware to use async/await"

# Fix a bug
codepal fix "Off-by-one error in pagination logic"

# View aggregate statistics
codepal stats

# Export all logged data as CSV
codepal export csv

# Search for entries about authentication
codepal search "auth"

# Show recent activity
codepal recent

# Health check
codepal status
```

## Output

- Command results print to stdout
- Entries are timestamped (`YYYY-MM-DD HH:MM`) and persisted to `~/.local/share/codepal/<category>.log`
- Export files are written to `~/.local/share/codepal/export.<fmt>` with a byte count confirmation

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
