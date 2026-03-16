---
name: SSLGen
description: "Self-signed SSL certificate generator. Create SSL certificates for development, generate CA certificates, create certificate signing requests, and manage dev TLS setup."
version: "2.0.0"
author: "BytesAgain"
tags: ["ssl","certificate","tls","openssl","security","developer"]
categories: ["Developer Tools", "Utility"]
---
# SSLGen

Self-signed SSL certificate generator. Create SSL certificates for development, generate CA certificates, create certificate signing requests, and manage dev TLS setup.

## Quick Start

Run `sslgen help` for available commands and usage examples.

## Features

- Fast and lightweight — pure bash with embedded Python
- No external dependencies required
 in `~/.sslgen/`
- Works on Linux and macOS

## Usage

```bash
sslgen help
```

---
💬 Feedback: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

- Run `sslgen help` for all commands

## When to Use

- as part of a larger automation pipeline
- when you need quick sslgen from the command line

## Output

Returns reports to stdout. Redirect to a file with `sslgen run > output.txt`.

## Configuration

Set `SSLGEN_DIR` environment variable to change the data directory. Default: `~/.local/share/sslgen/`
