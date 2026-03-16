---
name: Mimikatz
description: "A little tool to play with Windows security Based on gentilkiwi/mimikatz (21,330+ GitHub stars). mimikatz, c"
version: "2.0.0"
license: MIT-0
runtime: python3
---

# Mimikatz

A little tool to play with Windows security

Inspired by [gentilkiwi/mimikatz]([configured-endpoint]) (21,330+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from gentilkiwi/mimikatz

## Usage

Run any command: `mimikatz <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
mimikatz help
mimikatz run
```

## When to Use

- for batch processing mimikatz operations
- as part of a larger automation pipeline

## Output

Returns summaries to stdout. Redirect to a file with `mimikatz run > output.txt`.

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
mimikatz status

# View help
mimikatz help

# View statistics
mimikatz stats

# Export data
mimikatz export json
```

## How It Works

Mimikatz stores all data locally in `~/.local/share/mimikatz/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
