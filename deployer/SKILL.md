---
name: Deployer
description: "The PHP deployment tool with support for popular frameworks out of the box Based on deployphp/deployer (11,015+ GitHub stars). deployer, php, deploy, deployment, php, provision, tool"
version: "2.0.0"
license: MIT
runtime: python3
---

# Deployer

The PHP deployment tool with support for popular frameworks out of the box

Inspired by [deployphp/deployer]([configured-endpoint]) (11,015+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from deployphp/deployer

## Usage

Run any command: `deployer <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
deployer help
deployer run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick deployer from the command line

## Output

Returns reports to stdout. Redirect to a file with `deployer run > output.txt`.

## Configuration

Set `DEPLOYER_DIR` environment variable to change the data directory. Default: `~/.local/share/deployer/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
