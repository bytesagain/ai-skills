---
name: G Helper
description: "Lightweight, open-source control tool for ASUS laptops and ROG Ally. Manage performance modes, fans, Based on seerge/g-helper (12,446+ GitHub stars). g helper, c#, ally, amd, armoury, armoury-crate, asus"
version: "2.0.0"
license: GPL-3.0
runtime: python3
---

# G Helper

Lightweight, open-source control tool for ASUS laptops and ROG Ally. Manage performance modes, fans, GPU, battery, and RGB lighting across Zephyrus, Flow, TUF, Strix, Scar, and other models.

Inspired by [seerge/g-helper]([configured-endpoint]) (12,446+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from seerge/g-helper

## Usage

Run any command: `g-helper <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
g-helper help
g-helper run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick g helper from the command line

## Output

Returns reports to stdout. Redirect to a file with `g-helper run > output.txt`.

## Configuration

Set `G_HELPER_DIR` environment variable to change the data directory. Default: `~/.local/share/g-helper/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
