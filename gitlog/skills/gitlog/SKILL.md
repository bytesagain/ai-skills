---
name: GitLog
description: "View formatted commit history, author stats, and commit frequency patterns. Use when reviewing logs, comparing contributions, or generating repo reports."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["git","log","commits","repository","changelog","developer","vcs"]
categories: ["Developer Tools", "Utility"]
---

# GitLog

GitLog v2.0.0 — a developer toolkit for managing commit history and log analysis from the command line. Log checks, validations, changelog generations, lint results, diffs, and more. Each entry is timestamped and persisted locally. Works entirely offline — your data never leaves your machine.

## Why GitLog?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface with no GUI dependency
- Export to JSON, CSV, or plain text at any time for sharing or archival
- Automatic activity history logging across all commands
- Each domain command doubles as both a logger and a viewer

## Commands

### Domain Commands

Each domain command works in two modes: **log mode** (with arguments) saves a timestamped entry, **view mode** (no arguments) shows the 20 most recent entries.

| Command | Description |
|---------|-------------|
| `gitlog check <input>` | Log a check operation such as verifying commit signatures, author consistency, or branch protection compliance. Track verification outcomes across releases and branches. |
| `gitlog validate <input>` | Log a validation entry for commit message format checks, conventional commit compliance, or PR title standards. Record pass/fail outcomes and specific violations found. |
| `gitlog generate <input>` | Log a generation task for changelog creation, release notes drafting, or commit summary generation. Track what was generated, the commit range covered, and contributor counts. |
| `gitlog format <input>` | Log a formatting operation for reformatting log output, adjusting date formats, or restructuring commit displays. Record the format changes applied and the resulting output style. |
| `gitlog lint <input>` | Log a lint result identifying commits with missing scopes, non-standard prefixes, or overly long subject lines. Useful for enforcing consistent commit message quality across teams. |
| `gitlog explain <input>` | Log an explanation entry documenting why specific commits were made, architectural decisions behind changes, or context for complex merges. Build an annotated history. |
| `gitlog convert <input>` | Log a conversion task for transforming log formats between representations such as markdown changelogs, HTML release pages, or RSS feeds. Record source and target formats. |
| `gitlog template <input>` | Log a template operation for creating commit message templates, PR description templates, or changelog section templates. Track template versions and adoption. |
| `gitlog diff <input>` | Log a diff result comparing branches, tags, or time ranges. Record commits ahead/behind, divergence points, and merge conflict potential between branches. |
| `gitlog preview <input>` | Log a preview entry for reviewing staged commits, upcoming release contents, or draft changelogs before publishing. Useful for pre-release audits. |
| `gitlog fix <input>` | Log a fix operation for commit message rewrites, author corrections, or history cleanup. Track what was fixed, the method used (amend, rebase, filter-branch), and the scope of changes. |
| `gitlog report <input>` | Log a report entry for commit frequency analysis, contributor statistics, or release cadence summaries. Capture key metrics and trends from repository history. |

### Utility Commands

| Command | Description |
|---------|-------------|
| `gitlog stats` | Show summary statistics across all log files, including entry counts per category and total data size on disk. |
| `gitlog export <fmt>` | Export all data to a file in the specified format. Supported formats: `json`, `csv`, `txt`. Output is saved to the data directory. |
| `gitlog search <term>` | Search all log entries for a term using case-insensitive matching. Results are grouped by log category for easy scanning. |
| `gitlog recent` | Show the 20 most recent entries from the unified activity log, giving a quick overview of recent work across all commands. |
| `gitlog status` | Health check showing version, data directory path, total entry count, disk usage, and last activity timestamp. |
| `gitlog help` | Show the built-in help message listing all available commands and usage information. |
| `gitlog version` | Print the current version (v2.0.0). |

## Data Storage

All data is stored locally at `~/.local/share/gitlog/`. Each domain command writes to its own log file (e.g., `check.log`, `lint.log`). A unified `history.log` tracks all actions across commands. Use `export` to back up your data at any time.

## Requirements

- Bash (4.0+)
- No external dependencies — pure shell script
- No network access required

## When to Use

- Verifying commit message compliance and signature validity across releases and pull requests
- Generating changelogs and release notes from commit history with contributor attribution
- Linting commit messages to enforce conventional commit standards across the team
- Comparing branch histories and tracking divergence for merge planning and conflict prevention
- Building a searchable archive of commit explanations, fixes, and format conversion records

## Examples

```bash
# Log a check operation
gitlog check "Verified all 47 commits in v2.0 release are GPG-signed by authorized authors"

# Generate a changelog entry
gitlog generate "v2.0.0 changelog — 47 commits, 12 contributors, 3 breaking changes"

# Validate commit messages
gitlog validate "All 23 commits follow conventional format: feat(scope): message"

# Log a lint result
gitlog lint "Found 3 commits with missing scope in message, 1 with subject over 72 chars"

# Record a diff comparison
gitlog diff "main..feature-auth: 23 commits ahead, 5 behind, no merge conflicts detected"

# View all statistics
gitlog stats

# Export everything to CSV
gitlog export csv

# Search entries mentioning release
gitlog search release

# Check recent activity
gitlog recent

# Health check
gitlog status
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
