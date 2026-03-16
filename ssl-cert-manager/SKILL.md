---
version: "2.0.0"
name: Ssl Cert Manager
description: "A pure Unix shell script ACME client for SSL / TLS certificate automation ssl cert manager, shell, acme, acme-challenge, acme-protocol, acme-v2, ash. Use when you need ssl cert manager capabilities. Triggers on: ssl cert manager."
---

# Ssl Cert Manager

A pure Unix shell script ACME client for SSL / TLS certificate automation ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from acmesh-official/acme.sh

## Usage

Run any command: `ssl-cert-manager <command> [args]`

---
> **Disclaimer**: This skill is an independent, original implementation. It is not affiliated with, endorsed by, or derived from the referenced open-source project. No code was copied. The reference is for context only.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
ssl-cert-manager help
ssl-cert-manager run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick ssl cert manager from the command line

## Output

Returns reports to stdout. Redirect to a file with `ssl-cert-manager run > output.txt`.

## Configuration

Set `SSL_CERT_MANAGER_DIR` environment variable to change the data directory. Default: `~/.local/share/ssl-cert-manager/`
