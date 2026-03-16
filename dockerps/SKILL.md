---
name: DockerPS
description: "Docker container status viewer. List running containers with resource usage, show container logs, inspect container details, and monitor Docker system resources."
version: "2.0.0"
author: "BytesAgain"
tags: ["docker","container","status","devops","monitor"]
categories: ["Developer Tools", "Utility"]
---
# DockerPS

Docker container status viewer. List running containers with resource usage, show container logs, inspect container details, and monitor Docker system resources.

## Quick Start

Run `dockerps help` for available commands and usage examples.

## Features

- Fast and lightweight — pure bash with embedded Python
- No external dependencies required
 in `~/.dockerps/`
- Works on Linux and macOS

## Usage

```bash
dockerps help
```

---
💬 Feedback: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

- Run `dockerps help` for all commands

## When to Use

- as part of a larger automation pipeline
- when you need quick dockerps from the command line

## Output

Returns formatted output to stdout. Redirect to a file with `dockerps run > output.txt`.

## Configuration

Set `DOCKERPS_DIR` environment variable to change the data directory. Default: `~/.local/share/dockerps/`
