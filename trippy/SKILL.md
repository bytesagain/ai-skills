---
name: Trippy
description: "A network diagnostic tool  Based on fujiapple852/trippy (6,693+ GitHub stars). trippy, rust, cli, command-line-interface, command-line-tool, dns, icmp"
version: "2.0.0"
license: Apache-2.0
runtime: python3
---

# Trippy

A network diagnostic tool 

Inspired by [fujiapple852/trippy]([configured-endpoint]) (6,693+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from fujiapple852/trippy

## Usage

Run any command: `trippy <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
trippy help
trippy run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick trippy from the command line

## Output

Returns results to stdout. Redirect to a file with `trippy run > output.txt`.

## Configuration

Set `TRIPPY_DIR` environment variable to change the data directory. Default: `~/.local/share/trippy/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
