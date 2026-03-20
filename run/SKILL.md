---
name: "run"
version: "1.0.0"
description: "Execute commands with timing, retries, and parallel support. Use when benchmarking commands, retrying flaky scripts, or running tasks in parallel."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# run

Execute commands with timing, retries, and parallel support. Use when benchmarking commands, retrying flaky scripts, or running tasks in parallel.

## Commands

### `exec`

```bash
scripts/script.sh exec <cmd>
```

### `timed`

```bash
scripts/script.sh timed <cmd>
```

### `retry`

```bash
scripts/script.sh retry <count cmd>
```

### `parallel`

```bash
scripts/script.sh parallel <cmd1 cmd2>
```

### `watch`

```bash
scripts/script.sh watch <interval cmd>
```

### `log`

```bash
scripts/script.sh log <cmd>
```

## Data Storage

Data stored in `~/.local/share/run/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
