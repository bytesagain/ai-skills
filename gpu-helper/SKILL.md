---
version: "2.0.0"
name: G Helper
description: "Lightweight, open-source control tool for ASUS laptops and ROG Ally. Manage performance modes, fans, g helper, c#, ally, amd, armoury, armoury-crate, asus. Use when you need g helper capabilities. Triggers on: g helper."
---

# G Helper

Lightweight, open-source control tool for ASUS laptops and ROG Ally. Manage performance modes, fans, GPU, battery, and RGB lighting across Zephyrus, Flow, TUF, Strix, Scar, and other models. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from seerge/gpu-helper

## Usage

Run any command: `gpu-helper <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
gpu-helper help
gpu-helper run
```

## When to Use

- to automate gpu tasks in your workflow
- for batch processing helper operations

## Output

Returns logs to stdout. Redirect to a file with `gpu-helper run > output.txt`.

## Configuration

Set `GPU_HELPER_DIR` environment variable to change the data directory. Default: `~/.local/share/gpu-helper/`
