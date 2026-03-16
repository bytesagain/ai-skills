---
version: "2.0.0"
name: Go Cloud
description: "The Go Cloud Development Kit (Go CDK): A library and tools for open cloud development in Go. go cloud, go, aws, azure, cloud, gcp, go. Use when you need go cloud capabilities. Triggers on: go cloud."
author: BytesAgain
---

# Go Cloud

The Go Cloud Development Kit (Go CDK): A library and tools for open cloud development in Go. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from google/cloud-sdk

## Usage

Run any command: `cloud-sdk <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Show help
cloud-sdk help

# Run
cloud-sdk run
```

- Run `cloud-sdk help` for all commands

## When to Use

- as part of a larger automation pipeline
- when you need quick cloud sdk from the command line

## Output

Returns summaries to stdout. Redirect to a file with `cloud-sdk run > output.txt`.

## Configuration

Set `CLOUD_SDK_DIR` environment variable to change the data directory. Default: `~/.local/share/cloud-sdk/`
