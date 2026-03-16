---
name: Kopia
description: "Cross-platform backup tool for Windows, macOS & Linux with fast, incremental backups, client-side en Based on kopia/kopia (12,783+ GitHub stars). kopia, go, backup, cloud, deduplication, encryption, google-cloud-storage"
version: "2.0.0"
license: Apache-2.0
runtime: python3
---

# Kopia

Cross-platform backup tool for Windows, macOS & Linux with fast, incremental backups, client-side end-to-end encryption, compression and data deduplication. CLI and GUI included.

Inspired by [kopia/kopia]([configured-endpoint]) (12,783+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from kopia/kopia

## Usage

Run any command: `kopia <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
kopia help
kopia run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick kopia from the command line

## Output

Returns results to stdout. Redirect to a file with `kopia run > output.txt`.

## Configuration

Set `KOPIA_DIR` environment variable to change the data directory. Default: `~/.local/share/kopia/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
