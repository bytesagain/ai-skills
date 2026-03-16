---
name: Sops
description: "Simple and flexible tool for managing secrets Based on getsops/sops (21,173+ GitHub stars). sops, go, aws, azure, devops, gcp, pgp"
version: "2.0.0"
license: MPL-2.0
runtime: python3
---

# Sops

Simple and flexible tool for managing secrets

Inspired by [getsops/sops]([configured-endpoint]) (21,173+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from getsops/sops

## Usage

Run any command: `sops <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
sops help
sops run
```

## When to Use

- for batch processing sops operations
- as part of a larger automation pipeline

## Output

Returns summaries to stdout. Redirect to a file with `sops run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*


## Features

- Simple command-line interface for quick access
- Local data storage with JSON/CSV export
- History tracking and activity logs
- Search across all entries
- No external dependencies required

## Quick Start

```bash
# Check status
sops status

# View help
sops help

# View statistics
sops stats

# Export data
sops export json
```

## How It Works

Sops stores all data locally in `~/.local/share/sops/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
