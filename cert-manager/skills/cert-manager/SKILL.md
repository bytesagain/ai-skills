---
version: "2.0.0"
name: Certimate
description: "An open-source and free self-hosted SSL certificates ACME tool, automates the full-cycle of issuance cert-manager, go, acme, acme-client, automation."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Cert Manager

Cert Manager is a security scanning and hardening tool that provides vulnerability scanning, security audits, compliance checklists, encryption helpers, password generation, and alerting — all from the terminal.

## Commands

| Command | Description |
|---------|-------------|
| `cert-manager scan` | Run a vulnerability scan on the system |
| `cert-manager audit` | Execute a full security audit checklist |
| `cert-manager check <target>` | Quick security check on a specific target |
| `cert-manager report` | Generate a security report |
| `cert-manager harden` | Show hardening guide: Update → Firewall → Auth |
| `cert-manager encrypt <data>` | Encrypt the given data |
| `cert-manager hash <input>` | Generate SHA-256 hash of the input string |
| `cert-manager password` | Generate a random 16-character secure password |
| `cert-manager compliance` | Show a compliance checklist (access controls, encryption, logging) |
| `cert-manager alerts` | Check for active security alerts |
| `cert-manager help` | Show all available commands |
| `cert-manager version` | Show version number |

## How It Works

Cert Manager dispatches commands through a `case` statement. Each security operation prints results to stdout and appends a timestamped entry to `history.log` for full audit trail.

Key features:

- **scan** — Checks for known vulnerabilities in the current environment
- **audit** — Runs through a thorough security audit checklist
- **harden** — Provides a step-by-step guide: Step 1 (Update system) → Step 2 (Configure firewall) → Step 3 (Strengthen authentication)
- **hash** — Uses `sha256sum` to compute a cryptographic hash of any input string
- **password** — Generates a 16-character random password using Python's `random` module (letters, digits, and `!@#` symbols)
- **compliance** — Outputs a checklist covering access controls, encryption, and logging

## Data Storage

All data is stored locally in `~/.local/share/cert-manager/` by default:

- `history.log` — Timestamped audit trail of every command executed
- `data.log` — General data storage

Override the storage location by setting the `CERT_MANAGER_DIR` environment variable:

```bash
export CERT_MANAGER_DIR="$HOME/security-data/cert-manager"
```

Alternatively, `XDG_DATA_HOME` is respected if `CERT_MANAGER_DIR` is not set.

## Requirements

- **bash 4+** (uses `set -euo pipefail` for strict mode)
- **python3** (standard library only — used for password generation)
- Standard Unix tools (`sha256sum`, `date`, `echo`)
- No API keys needed

## When to Use

1. **Quick vulnerability scanning** — Run `cert-manager scan` to check your system for known security issues before deploying
2. **Security audits and compliance** — Use `cert-manager audit` and `cert-manager compliance` to walk through security checklists for SOC2, ISO 27001, or internal policies
3. **System hardening** — Run `cert-manager harden` to get a step-by-step guide for updating, firewall configuration, and authentication hardening
4. **Generating secure passwords** — Use `cert-manager password` to create strong random passwords for new accounts or services
5. **Hashing sensitive data** — Run `cert-manager hash <input>` to quickly compute SHA-256 checksums for integrity verification or data comparison

## Examples

```bash
# Run a full vulnerability scan
cert-manager scan

# Execute a security audit
cert-manager audit

# Quick check on a specific service
cert-manager check nginx

# Generate a security report
cert-manager report
```

```bash
# Get hardening recommendations
cert-manager harden

# Generate a secure password
cert-manager password

# Hash a string (SHA-256)
cert-manager hash "my-secret-data"

# Check compliance status
cert-manager compliance
```

```bash
# Encrypt data
cert-manager encrypt "sensitive-config-value"

# Check for active security alerts
cert-manager alerts

# Show version
cert-manager version

# Show all commands
cert-manager help
```

## Output

All command output goes to stdout. The history log is always written to `$DATA_DIR/history.log`. Redirect output as needed:

```bash
cert-manager report > security-report.txt
cert-manager scan > scan-results.txt
```

## Configuration

| Variable | Purpose | Default |
|----------|---------|---------|
| `CERT_MANAGER_DIR` | Override data/config directory | `~/.local/share/cert-manager/` |
| `XDG_DATA_HOME` | Fallback base directory | `~/.local/share/` |

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
