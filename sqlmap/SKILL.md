---
name: Sqlmap
description: "Automatic SQL injection and database takeover tool Based on sqlmapproject/sqlmap (36,821+ GitHub stars). sqlmap, python, database, detection, exploitation, pentesting, python"
version: "2.0.0"
license: NOASSERTION
runtime: python3
---

# Sqlmap

Automatic SQL injection and database takeover tool

Inspired by [sqlmapproject/sqlmap]([configured-endpoint]) (36,821+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from sqlmapproject/sqlmap

## Usage

Run any command: `sqlmap <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
sqlmap help
sqlmap run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick sqlmap from the command line

## Output

Returns formatted output to stdout. Redirect to a file with `sqlmap run > output.txt`.

## Configuration

Set `SQLMAP_DIR` environment variable to change the data directory. Default: `~/.local/share/sqlmap/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
