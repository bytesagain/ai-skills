---
name: "chain"
version: "1.0.0"
description: "Build and run named command chains with logging and status tracking. Use when creating multi-step workflows or automating sequential tasks."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# chain

Build and run named command chains with logging and status tracking. Use when creating multi-step workflows or automating sequential tasks.

## Commands

### `create`

```bash
scripts/script.sh create <name>
```

### `add`

```bash
scripts/script.sh add <name cmd>
```

### `run`

```bash
scripts/script.sh run <name>
```

### `list`

```bash
scripts/script.sh list
```

### `show`

```bash
scripts/script.sh show <name>
```

### `remove`

```bash
scripts/script.sh remove <name>
```

## Requirements

- bash 4.0+

## Data Storage

Data stored in `~/.local/share/chain/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
