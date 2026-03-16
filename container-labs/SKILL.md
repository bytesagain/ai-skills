---
version: "2.0.0"
name: Dockerlabs
description: "This is a collection of tutorials for learning how to use Docker with various tools. Contributions w docker-labs, php, containers, docker, docker-compose, docker-tutorial, dotnet. Use when you need docker-labs capabilities. Triggers on: docker-labs."
---

# Dockerlabs

This is a collection of tutorials for learning how to use Docker with various tools. Contributions welcome. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from docker-archive-public/docker.labs

## Usage

Run any command: `docker-labs <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
container-labs help
container-labs run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick container labs from the command line

## Output

Returns summaries to stdout. Redirect to a file with `container-labs run > output.txt`.

## Configuration

Set `CONTAINER_LABS_DIR` environment variable to change the data directory. Default: `~/.local/share/container-labs/`
