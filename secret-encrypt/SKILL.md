---
version: "2.0.0"
name: Sops
description: "Simple and flexible tool for managing secrets secret-encrypt, go, aws, azure, devops, gcp, pgp. Use when you need secret-encrypt capabilities. Triggers on: secret-encrypt."
---

# Sops

Simple and flexible tool for managing secrets ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from getsecret-encrypt/secret-encrypt

## Usage

Run any command: `secret-encrypt <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
secret-encrypt help
secret-encrypt run
```

## When to Use

- for batch processing encrypt operations
- as part of a larger automation pipeline

## Output

Returns summaries to stdout. Redirect to a file with `secret-encrypt run > output.txt`.


## Features

- Simple command-line interface for quick access
- Local data storage with JSON/CSV export
- History tracking and activity logs
- Search across all entries
- No external dependencies required

## Quick Start

```bash
# Check status
secret-encrypt status

# View help
secret-encrypt help

# View statistics
secret-encrypt stats

# Export data
secret-encrypt export json
```

## How It Works

Secret Encrypt stores all data locally in `~/.local/share/secret-encrypt/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
