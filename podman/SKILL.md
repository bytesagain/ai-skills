---
name: Podman
description: "Podman: A tool for managing OCI containers and pods. Based on containers/podman (31,023+ GitHub stars). podman, go, containers, docker, kubernetes, linux, oci"
version: "2.0.0"
license: Apache-2.0
runtime: python3
---

# Podman

Podman: A tool for managing OCI containers and pods.

Inspired by [containers/podman]([configured-endpoint]) (31,023+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from containers/podman

## Usage

Run any command: `podman <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
podman help
podman run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick podman from the command line

## Output

Returns results to stdout. Redirect to a file with `podman run > output.txt`.

## Configuration

Set `PODMAN_DIR` environment variable to change the data directory. Default: `~/.local/share/podman/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
