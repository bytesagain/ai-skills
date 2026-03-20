---
name: "capture"
version: "1.0.0"
description: "Capture command output, diffs, and system snapshots for debugging. Use when recording script output, comparing runs, or collecting diagnostics."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# capture

Capture command output, diffs, and system snapshots for debugging. Use when recording script output, comparing runs, or collecting diagnostics.

## Commands

### `command`

```bash
scripts/script.sh command <cmd>
```

### `diff`

```bash
scripts/script.sh diff <cmd1 cmd2>
```

### `env`

```bash
scripts/script.sh env
```

### `system`

```bash
scripts/script.sh system
```

### `log`

```bash
scripts/script.sh log <cmd file>
```

### `timed`

```bash
scripts/script.sh timed <cmd>
```

## Requirements

- bash 4.0+

## Data Storage

Data stored in `~/.local/share/capture/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
