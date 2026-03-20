---
name: "bus"
version: "1.0.0"
description: "Publish and subscribe to local message topics using file-based queues. Use when building event-driven workflows or decoupling script communication."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# bus

Publish and subscribe to local message topics using file-based queues. Use when building event-driven workflows or decoupling script communication.

## Commands

### `publish`

```bash
scripts/script.sh publish <topic message>
```

### `subscribe`

```bash
scripts/script.sh subscribe <topic>
```

### `topics`

```bash
scripts/script.sh topics
```

### `messages`

```bash
scripts/script.sh messages <topic count>
```

### `purge`

```bash
scripts/script.sh purge <topic>
```

### `stats`

```bash
scripts/script.sh stats
```

## Requirements

- bash 4.0+

## Data Storage

Data stored in `~/.local/share/bus/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
