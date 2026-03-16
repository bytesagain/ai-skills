---
name: Networkmanager
description: "A powerful open-source tool for managing networks and troubleshooting network problems! Based on BornToBeRoot/NETworkManager (8,130+ GitHub stars). networkmanager, c#, aws-ssm, dns, dns-lookup, icmp, ip-scanner"
version: "2.0.0"
license: GPL-3.0
runtime: python3
---

# Networkmanager

A powerful open-source tool for managing networks and troubleshooting network problems!

Inspired by [BornToBeRoot/NETworkManager]([configured-endpoint]) (8,130+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from BornToBeRoot/NETworkManager

## Usage

Run any command: `networkmanager <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
networkmanager help
networkmanager run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick networkmanager from the command line

## Output

Returns summaries to stdout. Redirect to a file with `networkmanager run > output.txt`.

## Configuration

Set `NETWORKMANAGER_DIR` environment variable to change the data directory. Default: `~/.local/share/networkmanager/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
