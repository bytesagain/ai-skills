---
name: Certimate
description: "An open-source and free self-hosted SSL certificates ACME tool, automates the full-cycle of issuance Based on certimate-go/certimate (8,234+ GitHub stars). certimate, go, acme, acme-client, automation, certbot, certificate"
version: "2.0.0"
license: MIT
runtime: python3
---

# Certimate

An open-source and free self-hosted SSL certificates ACME tool, automates the full-cycle of issuance, deployment, renewal, and monitoring visually. 完全开源免费的自托管 SSL 证书 ACME 工具，申请、部署、续期、监控全流程自动化可视化，支持各大主流云厂商。

Inspired by [certimate-go/certimate]([configured-endpoint]) (8,234+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from certimate-go/certimate

## Usage

Run any command: `certimate <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
certimate help
certimate run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick certimate from the command line

## Output

Returns formatted output to stdout. Redirect to a file with `certimate run > output.txt`.

## Configuration

Set `CERTIMATE_DIR` environment variable to change the data directory. Default: `~/.local/share/certimate/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
