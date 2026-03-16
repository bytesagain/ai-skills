---
version: "2.0.0"
name: Sqlmap
description: "Automatic SQL injection and database takeover tool sql-scanner, python, database, detection, exploitation, pentesting, python. Use when you need sql-scanner capabilities. Triggers on: sql-scanner."
---

# Sqlmap

Automatic SQL injection and database takeover tool ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from sql-scannerproject/sql-scanner

## Usage

Run any command: `sql-scanner <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
sql-scanner help
sql-scanner run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick sql scanner from the command line

## Output

Returns summaries to stdout. Redirect to a file with `sql-scanner run > output.txt`.

## Configuration

Set `SQL_SCANNER_DIR` environment variable to change the data directory. Default: `~/.local/share/sql-scanner/`
