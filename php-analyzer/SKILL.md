---
version: "1.0.0"
name: Phpstan
description: "PHP Static Analysis Tool - discover bugs in your code without running it! php-analyzer, php, php, php7, php-analyzer, static-analysis."
---

# PHP Analyzer

A thorough PHP development toolkit for checking, validating, formatting, linting, and analyzing PHP code. Works entirely offline with local storage, zero configuration, and a clean command-line interface.

## Why PHP Analyzer?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- 12 core PHP analysis commands plus utility commands
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging

## Commands

| Command | Description |
|---------|-------------|
| `php-analyzer check <input>` | Check PHP code or configuration for issues |
| `php-analyzer validate <input>` | Validate PHP syntax, structure, or schemas |
| `php-analyzer generate <input>` | Generate PHP boilerplate, stubs, or scaffolding |
| `php-analyzer format <input>` | Format PHP code to consistent style standards |
| `php-analyzer lint <input>` | Lint PHP files for code quality issues |
| `php-analyzer explain <input>` | Explain PHP concepts, errors, or code patterns |
| `php-analyzer convert <input>` | Convert between PHP versions or formats |
| `php-analyzer template <input>` | Create or manage PHP code templates |
| `php-analyzer diff <input>` | Diff PHP files or configurations |
| `php-analyzer preview <input>` | Preview changes before applying |
| `php-analyzer fix <input>` | Auto-fix common PHP issues |
| `php-analyzer report <input>` | Generate analysis reports |
| `php-analyzer stats` | Show summary statistics for all logged entries |
| `php-analyzer export <fmt>` | Export data (json, csv, or txt) |
| `php-analyzer search <term>` | Search across all logged entries |
| `php-analyzer recent` | Show last 20 activity entries |
| `php-analyzer status` | Health check — version, data dir, disk usage |
| `php-analyzer help` | Show full help with all available commands |
| `php-analyzer version` | Show current version (v2.0.0) |

Each core command (check, validate, generate, format, lint, explain, convert, template, diff, preview, fix, report) works in two modes:
- **Without arguments:** shows recent entries from that command's log
- **With arguments:** records the input with a timestamp and saves to the command-specific log file

## Data Storage

All data is stored locally at `~/.local/share/php-analyzer/`. Each command maintains its own `.log` file (e.g., `check.log`, `lint.log`, `format.log`). A unified `history.log` tracks all activity across commands with timestamps. Use the `export` command to back up your data in JSON, CSV, or plain text format at any time.

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`
- No external dependencies or API keys required
- Works on Linux, macOS, and WSL

## When to Use

1. **PHP code review** — Run `php-analyzer check` and `php-analyzer lint` to catch issues before committing code
2. **Code formatting standardization** — Use `php-analyzer format` to enforce consistent code style across a project
3. **Migration assistance** — Use `php-analyzer convert` and `php-analyzer diff` when upgrading PHP versions
4. **Learning and debugging** — Run `php-analyzer explain` to understand error messages or PHP patterns
5. **Project reporting** — Use `php-analyzer report` and `php-analyzer stats` to generate summaries of code quality over time

## Examples

```bash
# Check a PHP file for issues
php-analyzer check "src/Controller/UserController.php — missing return type"

# Lint a directory of PHP files
php-analyzer lint "app/Models/*.php — unused imports detected"

# Format code to PSR-12 standard
php-analyzer format "src/Services/PaymentService.php — PSR-12 compliance"

# Generate a boilerplate class
php-analyzer generate "Laravel controller for OrderService with CRUD methods"

# Explain a PHP error
php-analyzer explain "Fatal error: Cannot use object of type stdClass as array"

# View statistics across all commands
php-analyzer stats

# Export all data as JSON
php-analyzer export json

# Search for a specific term in all logs
php-analyzer search "Controller"

# Check system health
php-analyzer status
```

## Output

All commands return structured text to stdout. Redirect to a file with `php-analyzer <command> > output.txt`. Exported files are saved to the data directory with the chosen format extension.

## Configuration

The data directory defaults to `~/.local/share/php-analyzer/`. The tool auto-creates this directory on first run.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
