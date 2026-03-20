---
version: "1.0.0"
name: Go Zero
description: "A cloud-native Go microservices framework with cli tool for productivity. go zero, go, ai-native, ai-native-development, cloud-native, code-generation."
---
# Microservice Gen

Developer tools toolkit for checking, validating, generating, formatting, linting, explaining, converting, templating, diffing, previewing, fixing, and reporting on code and configurations. Microservice Gen provides a complete devtools workflow with timestamped logging for every operation. All entries are stored locally for full traceability.

## Commands

### Code Generation & Templating
| Command | Description |
|---------|-------------|
| `microservice-gen generate <input>` | Generate code, configs, or boilerplate. Run without args to view recent generations |
| `microservice-gen template <input>` | Create or apply templates. Run without args to view recent template entries |
| `microservice-gen convert <input>` | Convert between formats or languages. Run without args to view recent conversions |

### Code Quality & Validation
| Command | Description |
|---------|-------------|
| `microservice-gen check <input>` | Run checks on code or configs. Run without args to view recent check entries |
| `microservice-gen validate <input>` | Validate structure or schema compliance. Run without args to view recent validations |
| `microservice-gen lint <input>` | Lint code for style and quality issues. Run without args to view recent lint entries |
| `microservice-gen format <input>` | Format code or configuration files. Run without args to view recent format entries |

### Analysis & Review
| Command | Description |
|---------|-------------|
| `microservice-gen explain <input>` | Explain code, errors, or concepts. Run without args to view recent explanations |
| `microservice-gen diff <input>` | Record or analyze diffs between versions. Run without args to view recent diff entries |
| `microservice-gen preview <input>` | Preview generated output before applying. Run without args to view recent previews |

### Maintenance & Reporting
| Command | Description |
|---------|-------------|
| `microservice-gen fix <input>` | Log fix actions or patches applied. Run without args to view recent fix entries |
| `microservice-gen report <input>` | Generate reports from logged data. Run without args to view recent reports |

### Utility Commands
| Command | Description |
|---------|-------------|
| `microservice-gen stats` | Show summary statistics across all entry types |
| `microservice-gen export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `microservice-gen search <term>` | Search across all entries by keyword |
| `microservice-gen recent` | Show the 20 most recent activity log entries |
| `microservice-gen status` | Health check — version, data dir, entry count, disk usage |
| `microservice-gen help` | Show usage information and available commands |
| `microservice-gen version` | Show version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/microservice-gen/`:

- Each command type has its own log file (e.g., `check.log`, `generate.log`, `lint.log`)
- Entries are timestamped in `YYYY-MM-DD HH:MM|value` format
- A unified `history.log` tracks all activity across commands
- Export supports JSON, CSV, and plain text formats
- No external services or API keys required

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard UNIX utilities (`wc`, `du`, `grep`, `tail`, `sed`, `date`)
- No external dependencies — works on any POSIX-compatible system

## When to Use

1. **Microservice scaffolding** — Use `generate` and `template` to create boilerplate code, API definitions, and project structures for new services
2. **Code quality enforcement** — Use `check`, `validate`, `lint`, and `format` to ensure code meets standards before committing or deploying
3. **Code review workflow** — Use `diff`, `explain`, and `preview` to document changes, understand complex code, and review generated output
4. **Refactoring & fixes** — Use `fix`, `convert`, and `format` to log refactoring decisions, format migrations, and patch applications
5. **Development auditing** — Use `stats`, `search`, `report`, and `export` to review development activity, track patterns, and generate team reports

## Examples

```bash
# Generate a new service scaffold
microservice-gen generate "REST API service with user CRUD endpoints — Go + Chi router"

# Validate a configuration file
microservice-gen validate "Check docker-compose.yml against schema v3.8"

# Lint code for issues
microservice-gen lint "Run style checks on pkg/handler/*.go — enforce gofmt + golint"

# Create a template
microservice-gen template "Dockerfile template for Go microservice with multi-stage build"

# Diff two versions
microservice-gen diff "Compare v1.2 vs v1.3 API spec — breaking changes in /users endpoint"

# Search for all entries about a specific service
microservice-gen search user-service

# Export all data as JSON
microservice-gen export json

# View overall statistics
microservice-gen stats
```

## How It Works

Each devtools command (check, generate, lint, etc.) works the same way:
- **With arguments**: Saves the input as a new timestamped entry and logs it to history
- **Without arguments**: Displays the 20 most recent entries for that command type

This makes Microservice Gen both a development tool and a searchable devops journal.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
