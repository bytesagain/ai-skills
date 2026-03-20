---
version: "1.0.0"
name: Sealed Secrets
description: "A Kubernetes controller and tool for one-way encrypted Secrets sealed secrets, go, devops-workflow, encrypt-secrets, gitops, kubernetes."
---

# Secret Sealer

Secret Sealer v2.0.0 is a utility toolkit for sealing, managing, and tracking encrypted Kubernetes secrets. It provides a thorough CLI with timestamped logging, multi-format data export, and full activity history tracking for GitOps secret management workflows.

## Commands

All commands accept optional `<input>` arguments. When called without arguments, they display the 20 most recent entries from their respective logs. When called with input, they record a new timestamped entry.

| Command | Usage | Description |
|---------|-------|-------------|
| `run` | `secret-sealer run [input]` | Run a secret sealing operation and log the result |
| `check` | `secret-sealer check [input]` | Check sealed secret validity or status |
| `convert` | `secret-sealer convert [input]` | Convert between secret formats (plain, sealed, base64) |
| `analyze` | `secret-sealer analyze [input]` | Analyze sealed secrets for issues or patterns |
| `generate` | `secret-sealer generate [input]` | Generate new sealed secret manifests |
| `preview` | `secret-sealer preview [input]` | Preview sealed secret output before applying |
| `batch` | `secret-sealer batch [input]` | Batch seal multiple secrets at once |
| `compare` | `secret-sealer compare [input]` | Compare sealed secrets across environments |
| `export` | `secret-sealer export [input]` | Log an export operation |
| `config` | `secret-sealer config [input]` | Manage sealer configuration settings |
| `status` | `secret-sealer status [input]` | Log or view status entries |
| `report` | `secret-sealer report [input]` | Generate or log sealed secret reports |

### Utility Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `stats` | `secret-sealer stats` | Show summary statistics across all log files |
| `export <fmt>` | `secret-sealer export json\|csv\|txt` | Export all data in JSON, CSV, or plain text format |
| `search <term>` | `secret-sealer search <term>` | Search across all log entries (case-insensitive) |
| `recent` | `secret-sealer recent` | Show the 20 most recent activity entries |
| `status` | `secret-sealer status` | Health check — version, data dir, entry count, disk usage |
| `help` | `secret-sealer help` | Show full command reference |
| `version` | `secret-sealer version` | Print version string (`secret-sealer v2.0.0`) |

## Data Storage

All data is stored locally in `~/.local/share/secret-sealer/`:

- **`history.log`** — Master activity log with timestamps for every operation
- **`run.log`**, **`check.log`**, **`convert.log`**, etc. — Per-command log files storing `timestamp|input` entries
- **`export.json`**, **`export.csv`**, **`export.txt`** — Generated export files

Each entry is stored in pipe-delimited format: `YYYY-MM-DD HH:MM|value`. The data directory is created automatically on first use.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`, `local` variables)
- **Standard Unix tools**: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `basename`, `cat`
- No external dependencies, API keys, or network access required
- Works on Linux, macOS, and WSL

## When to Use

1. **Sealing secrets for Kubernetes GitOps** — Use `run` to seal plaintext secrets into encrypted SealedSecret resources safe for Git storage
2. **Validating sealed secrets before deployment** — Use `check` to verify that sealed secrets are properly encrypted and match expected namespaces
3. **Batch sealing across multiple environments** — Use `batch` to seal secrets for staging, production, and development clusters in one pass
4. **Comparing secrets across clusters** — Use `compare` to detect drift between sealed secrets in different Kubernetes environments
5. **Generating sealed secret manifests** — Use `generate` to create new SealedSecret YAML manifests from templates or environment variables

## Examples

```bash
# Seal a secret for a Kubernetes namespace
secret-sealer run "db-password namespace=production"

# Check sealed secret validity
secret-sealer check my-sealed-secret.yaml

# Convert secret format
secret-sealer convert "base64 to sealed-secret"

# Analyze sealed secrets for expiry
secret-sealer analyze "cluster=prod check-cert-expiry"

# Generate a new sealed secret manifest
secret-sealer generate "api-key namespace=staging"

# Batch seal multiple secrets
secret-sealer batch "secret1" "secret2" "secret3"

# Compare secrets across environments
secret-sealer compare "staging vs production db-creds"

# Export all history as CSV
secret-sealer export csv

# Search for past operations
secret-sealer search "production"

# View summary statistics
secret-sealer stats
```

## Output

All commands output structured text to stdout. Use standard shell redirection to capture output:

```bash
secret-sealer stats > summary.txt
secret-sealer export json  # writes to ~/.local/share/secret-sealer/export.json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
