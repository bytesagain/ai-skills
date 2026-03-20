---
name: "chaos-testing"
version: "3.0.0"
description: "Run controlled chaos and stress tests on your system. Use when testing resilience or load capacity."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# chaos-testing

Run controlled chaos and stress tests on your system. Use when testing resilience or load capacity.

## Commands

### `cpu-stress`

```bash
scripts/script.sh cpu-stress <seconds>
```

### `mem-stress`

```bash
scripts/script.sh mem-stress <mb>
```

### `disk-fill`

```bash
scripts/script.sh disk-fill <mb dir>
```

### `io-stress`

```bash
scripts/script.sh io-stress <seconds>
```

### `report`

```bash
scripts/script.sh report
```

### `status`

```bash
scripts/script.sh status
```

## Data Storage

Data stored in `~/.local/share/chaos-testing/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
