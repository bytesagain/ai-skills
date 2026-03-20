---
name: Regexr
description: "Create, test, and learn regular expressions with live matching. Use when validating patterns, checking groups, generating regex, linting syntax."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["regex", "regexp", "正则表达式", "pattern", "javascript", "utility", "developer"]
categories: ["Developer Tools", "Utility"]
commands:
  - name: "help"
    description: "显示RegExr工具的帮助信息和可用命令列表。"
    usage: "regexr help"
  - name: "run"
    description: "启动RegExr交互式界面，允许用户创建、测试和调试正则表达式。"
    usage: "regexr run"
  - name: "info"
    description: "提供RegExr工具的版本信息和相关资源链接。"
    usage: "regexr info"
  - name: "status"
    description: "检查RegExr工具的运行状态和依赖项健康状况。"
    usage: "regexr status"
changelog:
  - version: "1.0.0"
    date: "2026-03-15"
    changes:
      - "初始版本发布"
pricing_model: "free"
license: "MIT"
docs_url: "https://bytesagain.com/skills/regexr"
support_url: "https://bytesagain.com/feedback"
---

# Regexr

Developer tools CLI for checking, validating, generating, and working with regular expressions and code patterns. Lint syntax, explain complex expressions, convert between formats, generate templates, diff pattern versions, preview matches, fix common regex issues, and produce reports — all from the command line with persistent local logging.

## Commands

Run `regexr <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `check` | Check regex patterns for correctness and common pitfalls |
| `validate` | Validate regex syntax and structure |
| `generate` | Generate regex patterns from descriptions or examples |
| `format` | Format and prettify regex expressions |
| `lint` | Lint regex for style, performance, and safety issues |
| `explain` | Explain what a regex pattern does in plain language |
| `convert` | Convert regex between flavors (PCRE, JS, Python, etc.) |
| `template` | Apply or manage regex templates for common use cases |
| `diff` | Diff two regex patterns and show behavioral differences |
| `preview` | Preview regex matches against sample text |
| `fix` | Auto-fix common regex issues (escaping, anchoring, etc.) |
| `report` | Generate regex quality and coverage reports |
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

All data is stored locally in `~/.local/share/regexr/`:

- Each command creates its own log file (e.g., `check.log`, `validate.log`, `generate.log`)
- A unified `history.log` tracks all activity across commands
- Entries are stored in `timestamp|value` pipe-delimited format
- Export supports JSON, CSV, and plain text formats

## Requirements

- Bash 4+ with `set -euo pipefail` strict mode
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Building and testing regex patterns** — use `generate` to create patterns from descriptions, `check` to verify correctness, and `preview` to test against sample data
2. **Learning and understanding regex** — use `explain` to break down complex patterns into plain-language descriptions, perfect for code reviews or onboarding
3. **Linting and fixing regex in codebases** — run `lint` to catch performance and safety issues (catastrophic backtracking, unanchored patterns), then `fix` to auto-correct them
4. **Converting regex across languages** — use `convert` to translate patterns between JavaScript, Python, PCRE, and other flavors when porting code
5. **Documenting regex usage in projects** — log patterns with `template`, generate `report` summaries, and `export` data for documentation or audits

## Examples

```bash
# Check a regex pattern for issues
regexr check "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$ — email validation"

# Validate regex syntax
regexr validate "(?<=@)[a-z]+\.com — lookbehind syntax OK"

# Generate a pattern from description
regexr generate "match IPv4 addresses: \d{1,3}(\.\d{1,3}){3}"

# Explain a complex regex
regexr explain "^(?=.*[A-Z])(?=.*\d).{8,}$ — password: 1 uppercase, 1 digit, 8+ chars"

# Lint for performance issues
regexr lint "(a+)+ — warning: catastrophic backtracking possible"

# Convert between flavors
regexr convert "JS→Python: /\d+/g becomes re.findall(r'\d+', text)"

# Fix common issues
regexr fix "added anchors: ^pattern$ and escaped special chars"

# Preview matches
regexr preview "pattern=[0-9]{3}-[0-9]{4} matched: 555-1234, 800-9999"

# View summary statistics
regexr stats

# Export all data as JSON
regexr export json

# Search logged patterns
regexr search "email"
```

## Output

All commands output to stdout. Redirect to a file if needed:

```bash
regexr report "weekly pattern audit" > report.txt
regexr export csv  # saves to ~/.local/share/regexr/export.csv
```

## Configuration

Set `DATA_DIR` by modifying the script, or use the default: `~/.local/share/regexr/`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
