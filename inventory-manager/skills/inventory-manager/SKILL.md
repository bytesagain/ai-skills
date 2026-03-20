---
name: "inventory-manager"
version: "3.0.0"
description: "Track inventory with stock levels, pricing, and low-stock alerts. Use when managing product inventory."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# inventory-manager

Track inventory with stock levels, pricing, and low-stock alerts. Use when managing product inventory.

## Commands

### `add`

```bash
scripts/script.sh add <item qty price>
```

### `list`

```bash
scripts/script.sh list <filter>
```

### `remove`

```bash
scripts/script.sh remove <item qty>
```

### `low-stock`

```bash
scripts/script.sh low-stock <threshold>
```

### `value`

```bash
scripts/script.sh value
```

### `export`

```bash
scripts/script.sh export <file>
```

## Data Storage

Data stored in `~/.local/share/inventory-manager/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
