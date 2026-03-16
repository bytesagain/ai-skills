---
version: "2.0.0"
name: Networkmanager
description: "A powerful open-source tool for managing networks and troubleshooting network problems! network-config, c#, aws-ssm, dns, dns-lookup, icmp, ip-scanner. Use when you need network-config capabilities. Triggers on: network-config."
---

# Networkmanager

A powerful open-source tool for managing networks and troubleshooting network problems! ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from BornToBeRoot/NETworkManager

## Usage

Run any command: `network-config <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
network-config help
network-config run
```

## When to Use

- to automate network tasks in your workflow
- for batch processing config operations

## Output

Returns structured data to stdout. Redirect to a file with `network-config run > output.txt`.

## Configuration

Set `NETWORK_CONFIG_DIR` environment variable to change the data directory. Default: `~/.local/share/network-config/`
