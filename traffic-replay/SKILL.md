---
version: "2.0.0"
name: Goreplay
description: "GoReplay is an open-source tool for capturing and replaying live HTTP traffic into a test environmen traffic-replay, go, devops, go, qa, testing, testing-tools. Use when you need traffic-replay capabilities. Triggers on: traffic-replay."
---

# Goreplay

GoReplay is an open-source tool for capturing and replaying live HTTP traffic into a test environment in order to continuously test your system with real data. It can be used to increase confidence in code deployments, configuration changes and infrastructure changes. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from probelabs/traffic-replay

## Usage

Run any command: `traffic-replay <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
traffic-replay help
traffic-replay run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick traffic replay from the command line

## Output

Returns logs to stdout. Redirect to a file with `traffic-replay run > output.txt`.

## Configuration

Set `TRAFFIC_REPLAY_DIR` environment variable to change the data directory. Default: `~/.local/share/traffic-replay/`
