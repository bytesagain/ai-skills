---
name: SeedGen
description: "Generate reproducible seeds and deterministic test data. Use when creating random seeds, rotating salt values, auditing randomness, storing seed records."
version: "3.0.1"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["seed","random","generator","testing","data","deterministic","developer"]
categories: ["Developer Tools", "Utility"]
---

# SeedGen

Random seed and data generator. Generate random strings, hex, bytes, integers, floats, UUIDs, passwords, and batch outputs — using /dev/urandom and standard tools.

## Commands

| Command | Description |
|---------|-------------|
| `seedgen string <length>` | Random alphanumeric string of given length |
| `seedgen hex <bytes>` | Random hex string (2 hex chars per byte) |
| `seedgen bytes <count>` | Random bytes, base64 encoded |
| `seedgen int <min> <max>` | Random integer in range [min, max] |
| `seedgen float` | Random float between 0 and 1 |
| `seedgen pick <item1> <item2> ...` | Randomly pick one item from a list |
| `seedgen uuid` | Generate a UUID v4 |
| `seedgen password <length>` | Generate a strong mixed-char password |
| `seedgen batch <type> <count> [args]` | Generate multiple values at once |
| `seedgen version` | Show version |

## Examples

```bash
seedgen string 32          # → "aB3kQ9..."
seedgen hex 16             # → "4f2a1c..."
seedgen bytes 64           # → base64-encoded random bytes
seedgen int 1 100          # → 42
seedgen float              # → 0.73812...
seedgen pick red green blue # → "green"
seedgen uuid               # → "550e8400-e29b-41d4-..."
seedgen password 20        # → "kP#9xL!mQ..."
seedgen batch string 5 16  # → 5 random 16-char strings
```

## Requirements

- `/dev/urandom` (standard on Linux/macOS)
- `shuf`, `awk`, `od`, `base64` (standard coreutils)
