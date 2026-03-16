---
name: Lynis
description: "Lynis - Security auditing tool for Linux, macOS, and UNIX-based systems. Assists with compliance tes Based on CISOfy/lynis (15,393+ GitHub stars). lynis, shell, auditing, compliance, devops, devops-tools, gdpr"
version: "2.0.0"
license: GPL-3.0
runtime: python3
---

# Lynis

Lynis - Security auditing tool for Linux, macOS, and UNIX-based systems. Assists with compliance testing (HIPAA/ISO27001/PCI DSS) and system hardening. Agentless, and installation optional.

Inspired by [CISOfy/lynis]([configured-endpoint]) (15,393+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from CISOfy/lynis

## Usage

Run any command: `lynis <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
lynis help
lynis run
```

## When to Use

- for batch processing lynis operations
- as part of a larger automation pipeline

## Output

Returns structured data to stdout. Redirect to a file with `lynis run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
