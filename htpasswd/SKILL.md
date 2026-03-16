---
name: HtPasswd
description: "HTTP basic auth password file manager. Generate htpasswd entries, create password files, verify passwords, and manage Apache/Nginx basic authentication credentials."
version: "2.0.0"
author: "BytesAgain"
tags: ["htpasswd","password","auth","apache","nginx","security"]
categories: ["Developer Tools", "Utility"]
---
# HtPasswd

HTTP basic auth password file manager. Generate htpasswd entries, create password files, verify passwords, and manage Apache/Nginx basic authentication credentials.

## Quick Start

Run `htpasswd help` for available commands and usage examples.

## Features

- Fast and lightweight — pure bash with embedded Python
- No external dependencies required
 in `~/.htpasswd/`
- Works on Linux and macOS

## Usage

```bash
htpasswd help
```

---
💬 Feedback: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

- Run `htpasswd help` for all commands

## When to Use

- as part of a larger automation pipeline
- when you need quick htpasswd from the command line

## Output

Returns structured data to stdout. Redirect to a file with `htpasswd run > output.txt`.

## Configuration

Set `HTPASSWD_DIR` environment variable to change the data directory. Default: `~/.local/share/htpasswd/`
