---
version: "1.0.0"
name: Terragrunt
description: "Terragrunt is a flexible orchestration tool that allows Infrastructure as Code written in OpenTofu/T terraform-wrapper, go, aws, cli, developer-tools."
---

# Infra Wrapper

Infra Wrapper v2.0.0 — a utility toolkit for running, checking, converting, analyzing, generating, previewing, batching, comparing, exporting, configuring, monitoring status, and reporting on infrastructure wrapper operations. All entries are timestamped and logged locally for history tracking.

## Commands

### Core Commands

- `run <input>` — Record and log a run entry. Without arguments, shows the 20 most recent run entries.
- `check <input>` — Record and log a check entry. Without arguments, shows recent check entries.
- `convert <input>` — Record and log a convert entry. Without arguments, shows recent convert entries.
- `analyze <input>` — Record and log an analyze entry. Without arguments, shows recent analyze entries.
- `generate <input>` — Record and log a generate entry. Without arguments, shows recent generate entries.
- `preview <input>` — Record and log a preview entry. Without arguments, shows recent preview entries.
- `batch <input>` — Record and log a batch entry. Without arguments, shows recent batch entries.
- `compare <input>` — Record and log a compare entry. Without arguments, shows recent compare entries.
- `export <input>` — Record and log an export entry. Without arguments, shows recent export entries.
- `config <input>` — Record and log a config entry. Without arguments, shows recent config entries.
- `status <input>` — Record and log a status entry. Without arguments, shows recent status entries.
- `report <input>` — Record and log a report entry. Without arguments, shows recent report entries.

### Utility Commands

- `stats` — Show summary statistics across all log files (entry counts per type, total entries, disk usage).
- `export <fmt>` — Export all logged data to a file. Supported formats: `json`, `csv`, `txt`. (Note: also doubles as a core command when given non-format arguments.)
- `search <term>` — Search all log files for a case-insensitive term match.
- `recent` — Show the 20 most recent entries from the activity history log.
- `status` — Health check showing version, data directory, total entries, disk usage, and last activity. (Note: also doubles as a core command when given arguments.)
- `help` — Display the full help message with all available commands.
- `version` — Print the current version (v2.0.0).

## Data Storage

All data is stored in `~/.local/share/infra-wrapper/`:

- Each core command writes timestamped entries to its own log file (e.g., `run.log`, `check.log`, `batch.log`).
- A unified `history.log` tracks all operations across commands.
- Export files are written to the same directory as `export.json`, `export.csv`, or `export.txt`.

## Requirements

- Bash (with `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`

## When to Use

- When you need to log and track infrastructure wrapper operations (runs, checks, conversions, batch jobs, etc.)
- For maintaining an audit trail of Terragrunt/OpenTofu/Terraform orchestration activities
- To analyze and compare infrastructure configurations with timestamped records
- To export accumulated infra wrapper data in JSON, CSV, or plain text for downstream processing
- As part of a larger IaC automation pipeline that needs timestamped operation records
- When you need to search across historical infrastructure orchestration entries
- For batch processing multiple infrastructure operations and tracking their status

## Examples

```bash
# Run an operation
infra-wrapper run "terragrunt apply --all"

# Check configuration
infra-wrapper check "module dependencies in staging"

# Convert infrastructure format
infra-wrapper convert "HCL to JSON for ci pipeline"

# Analyze infrastructure
infra-wrapper analyze "cost impact of scaling change"

# Generate configurations
infra-wrapper generate "module boilerplate for new service"

# Preview changes before applying
infra-wrapper preview "plan output for production"

# Batch process operations
infra-wrapper batch "apply all modules in us-east-1"

# Compare environments
infra-wrapper compare "staging vs production configs"

# Update config
infra-wrapper config "set backend to s3://terraform-state"

# View recent activity
infra-wrapper recent

# Search across all logs
infra-wrapper search "production"

# Export everything to CSV
infra-wrapper export csv

# Show stats
infra-wrapper stats

# Health check
infra-wrapper status
```

## Output

All commands output results to stdout. Redirect to a file if needed:

```bash
infra-wrapper stats > report.txt
infra-wrapper export json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
