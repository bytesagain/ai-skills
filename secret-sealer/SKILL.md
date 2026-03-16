---
version: "2.0.0"
name: Sealed Secrets
description: "A Kubernetes controller and tool for one-way encrypted Secrets sealed secrets, go, devops-workflow, encrypt-secrets, gitops, kubernetes, kubernetes-secrets. Use when you need sealed secrets capabilities. Triggers on: sealed secrets."
---

# Sealed Secrets

A Kubernetes controller and tool for one-way encrypted Secrets ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from bitnami-labs/secret-sealer

## Usage

Run any command: `secret-sealer <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
secret-sealer help
secret-sealer run
```

## When to Use

- when you need quick secret sealer from the command line
- to automate secret tasks in your workflow

## Output

Returns formatted output to stdout. Redirect to a file with `secret-sealer run > output.txt`.


## Features

- Simple command-line interface for quick access
- Local data storage with JSON/CSV export
- History tracking and activity logs
- Search across all entries
- No external dependencies required

## Quick Start

```bash
# Check status
secret-sealer status

# View help
secret-sealer help

# View statistics
secret-sealer stats

# Export data
secret-sealer export json
```

## How It Works

Secret Sealer stores all data locally in `~/.local/share/secret-sealer/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
