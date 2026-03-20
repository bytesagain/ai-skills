---
name: "certcheck"
version: "3.0.0"
description: "Check SSL certificates on remote domains for expiry and chain validity. Use when auditing SSL health."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# certcheck

Check SSL certificates on remote domains for expiry and chain validity. Use when auditing SSL health.

## Commands

### `check`

```bash
scripts/script.sh check <domain>
```

### `expiry`

```bash
scripts/script.sh expiry <domain>
```

### `chain`

```bash
scripts/script.sh chain <domain>
```

### `compare`

```bash
scripts/script.sh compare <d1 d2>
```

### `batch`

```bash
scripts/script.sh batch <file>
```

### `report`

```bash
scripts/script.sh report <domain>
```

## Data Storage

Data stored in `~/.local/share/certcheck/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
