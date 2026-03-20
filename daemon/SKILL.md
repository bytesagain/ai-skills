---
name: "daemon"
version: "1.0.0"
description: "Manage background processes with PID files and logging. Use when running or monitoring services."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# daemon

Manage background processes with PID files and logging. Use when running or monitoring services.

## Commands

### `start`

```bash
scripts/script.sh start <name cmd>
```

### `stop`

```bash
scripts/script.sh stop <name>
```

### `status`

```bash
scripts/script.sh status <name>
```

### `list`

```bash
scripts/script.sh list
```

### `log`

```bash
scripts/script.sh log <name>
```

### `restart`

```bash
scripts/script.sh restart <name>
```

## Data Storage

Data stored in `~/.local/share/daemon/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
