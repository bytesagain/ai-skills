---
version: "2.0.0"
name: ring-security
description: "Control Ring doorbells and cameras from the terminal. Use when scanning motion events, auditing device access, checking firmware, reporting activity."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Ring Security

Security scanning and hardening tool for auditing systems, generating reports, and enforcing compliance from the command line.

## Overview

ring-security provides a suite of security-focused commands for vulnerability scanning, compliance auditing, encryption helpers, password generation, and hardening guidance. All operations are local and logged for traceability.

## Commands

| Command | Description |
|---------|-------------|
| `ring-security scan` | Run a vulnerability scan |
| `ring-security audit` | Execute a security audit checklist |
| `ring-security check <target>` | Quick security check on a specific target |
| `ring-security report` | Generate a security report |
| `ring-security harden` | Display hardening steps (Update → Firewall → Auth) |
| `ring-security encrypt <file>` | Encryption helper for a given file or string |
| `ring-security hash <string>` | Generate SHA-256 hash of a string |
| `ring-security password` | Generate a random 16-character password |
| `ring-security compliance` | Show compliance checklist (Access controls, Encryption, Logging) |
| `ring-security alerts` | Check for active security alerts |
| `ring-security help` | Show help message |
| `ring-security version` | Show version (v2.0.0) |

## Data Storage

- **Location:** `$RING_SECURITY_DIR` or `~/.local/share/ring-security/`
- **Data file:** `data.log` — general operation log
- **History:** `history.log` — timestamped action log for audit trail
- All data is plain text, stored locally. No cloud services required.

## Requirements

- bash (with `set -euo pipefail`)
- python3 (standard library only — used for password generation via `random` and `string`)
- Standard Unix utilities (`sha256sum`, `date`, `echo`)
- No external API keys or accounts needed

## When to Use

1. **Quick vulnerability scanning** — Run `scan` to identify potential security issues on a system
2. **Security audits** — Use `audit` to walk through a checklist of security controls
3. **Password generation** — Generate strong random passwords with `password` — 16 chars with letters, digits, and symbols
4. **Compliance reviews** — Use `compliance` to check Access Controls, Encryption, and Logging status
5. **System hardening** — Follow the `harden` guide for a step-by-step approach: Update → Firewall → Auth

## Examples

```bash
# Run a full vulnerability scan
ring-security scan

# Perform a security audit
ring-security audit

# Quick check on a specific target
ring-security check "web-server-01"

# Generate a security report
ring-security report
```

```bash
# Get hardening guidance
ring-security harden
#  Output: Step 1: Update | Step 2: Firewall | Step 3: Auth

# Generate a random password
ring-security password
#  Output: e.g. "aB3!xK9mQ2@nP7wL"

# Hash a string with SHA-256
ring-security hash "my-secret-value"
#  Output: SHA-256 hash of the input
```

```bash
# Check compliance status
ring-security compliance
#  Output: [ ] Access controls | [ ] Encryption | [ ] Logging

# Check for active security alerts
ring-security alerts

# Encrypt a file
ring-security encrypt "sensitive-data.txt"
```

## How It Works

Each command performs its security operation and logs the action with a timestamp to `history.log`. The `hash` command uses `sha256sum` for real cryptographic hashing. The `password` command leverages Python's `random` and `string` modules to generate 16-character passwords mixing uppercase, lowercase, digits, and special characters (`!@#`).

## Tips

- Pipe `hash` output for scripting: `ring-security hash "value" | xargs echo`
- Use `report` in a cron job for regular security summaries
- Override the data directory: `export RING_SECURITY_DIR=/path/to/custom/dir`
- Combine `scan` and `audit` in a daily cron for automated security monitoring

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
