---
name: "bridge"
version: "1.0.0"
description: "Forward ports and create network tunnels between hosts. Use when setting up port forwarding, testing connectivity, or creating local proxies."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# bridge

Forward ports and create network tunnels between hosts. Use when setting up port forwarding, testing connectivity, or creating local proxies.

## Commands

### `forward`

```bash
scripts/script.sh forward <local remote_host remote_port>
```

### `list`

```bash
scripts/script.sh list
```

### `status`

```bash
scripts/script.sh status
```

### `proxy`

```bash
scripts/script.sh proxy <port>
```

### `test`

```bash
scripts/script.sh test <host port>
```

### `dns`

```bash
scripts/script.sh dns <domain>
```

## Requirements

- bash 4.0+

## Data Storage

Data stored in `~/.local/share/bridge/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
