---
version: "2.0.0"
name: Acmesh
description: "A pure Unix shell script ACME client for SSL / TLS certificate automation acmesh, shell, acme, acme-challenge, acme-protocol, acme-v2, ash. Use when you need acmesh capabilities. Triggers on: acmesh."
author: BytesAgain
---

# Acmesh

A pure Unix shell script ACME client for SSL / TLS certificate automation ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from acmesh-official/acme.sh

## Usage

Run any command: `acmesh <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Show help
acmesh help

# Run
acmesh run
```

- Run `acmesh help` for all commands

- Run `acmesh help` for all commands

## When to Use

- to automate acmesh tasks in your workflow
- for batch processing acmesh operations

## Output

Returns reports to stdout. Redirect to a file with `acmesh run > output.txt`.

## Configuration

Set `ACMESH_DIR` environment variable to change the data directory. Default: `~/.local/share/acmesh/`
